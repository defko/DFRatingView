//
//  DFRatingView.m
//  DFRatingView
//
//  Created by Kiss Tamás on 05/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "DFRatingView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface DFRatingView()
@property (nonatomic,assign) NSInteger lastSelectedTag;
@end

static const NSInteger kTagOffset = 50;
static const NSInteger kTagSelf = 999;
@implementation DFRatingView

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.isActionEnabled = YES;
    _starCount = 5;
    self.tag = kTagSelf;
    [self addViews];
}

- (void) addViews
{
    CGRect selfFrame = self.bounds;
    int width = CGRectGetMaxX(selfFrame);
    int height = CGRectGetMaxY(selfFrame);
    int widthofOneStar = MIN(height, width / (float)self.starCount);
    for (int i = 0; i<self.starCount; i++) {
        CGRect rect = CGRectMake(i*widthofOneStar, 0, widthofOneStar, widthofOneStar);
        DFRatingStar* star = [[DFRatingStar alloc] initWithFrame:rect];
        star.hidden = YES;
        star.tag = i;
        [self addSubview:star];
        
        CGRect circleRect = CGRectMake((i*widthofOneStar) + (widthofOneStar/4), (widthofOneStar/4), widthofOneStar/2, widthofOneStar/2);
        DFRatingCircle* circle = [[DFRatingCircle alloc] initWithFrame:circleRect];
        circle.circleColor = [UIColor grayColor];
        circle.tag = i+kTagOffset;
        [self addSubview:circle];
    }
}

- (void) removeViews
{
    NSArray* subviews = [self subviews];
    for (UIView* view in subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - Properties

- (void) setRating:(NSInteger)rating
{
    NSString* errormsg = [NSString stringWithFormat:@"rating muss be in range (0, %li) (rating = %li)",(long)self.starCount,(long)rating];
    NSAssert((rating<=self.starCount) && (rating >= 0), errormsg);
    [self showTo:rating-1];
}

- (void) setStarCount:(NSInteger)starCount
{
    _starCount = starCount;
    [self removeViews];
    [self addViews];
}

- (void) setStarColor:(UIColor *)starColor
{
    _starColor = starColor;
    for (int i = 0; i<self.starCount; i++) {
         DFRatingStar* starview = (DFRatingStar*)[self viewWithTag:i];
        starview.starColor = starColor;
        [starview setNeedsDisplay];
    }
}

- (void) setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    for (int i = 0; i<self.starCount; i++) {
        DFRatingCircle* circleView = (DFRatingCircle*)[self viewWithTag:i+kTagOffset];
        circleView.circleColor = circleColor;
        [circleView setNeedsDisplay];
    }
}

#pragma mark - uiresponder

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isActionEnabled) {
        [self changeRating:touches];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isActionEnabled) {
        UIView *view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
        if (view.tag>=kTagOffset && view.tag != kTagSelf) {
            if (self.lastSelectedTag != view.tag && self.lastSelectedTag != view.tag-kTagOffset) {
                [self changeRating:touches];
            }
        } else if (view.tag != kTagSelf){
            if (self.lastSelectedTag != view.tag && self.lastSelectedTag != view.tag+kTagOffset) {
                [self changeRating:touches];
            }
        }
    }
    [super touchesMoved:touches withEvent:event];
}

- (void) changeRating:(NSSet *)touches
{
    UIView *view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (view) {
        if (view.tag >= kTagOffset && view.tag <kTagSelf) {
            [self showTo:view.tag-kTagOffset];
        } else if (view.tag < kTagSelf){
            [self hidesTo:view.tag];
        }
        self.lastSelectedTag = view.tag;
    }
}

- (void) hidesTo:(NSInteger) tag
{
    for (NSInteger i = tag; i<self.starCount; i++) {
        [self animate:i hide:YES];
    }
}

- (void) showTo:(NSInteger) tag
{
    for (NSInteger i = 0; i<=tag; i++) {
        [self animate:i hide:NO];
    }
}

- (void) animate:(NSInteger) tag hide:(BOOL) isHide
{
    UIView* starview = [self viewWithTag:tag];
    UIView* circleview = [self viewWithTag:tag+kTagOffset];
    CATransform3D t1 = [self scaleWithView:starview direction:isHide];
    CATransform3D t2 = [self scaleWithView:circleview direction:!isHide];
    [UIView animateKeyframesWithDuration:0.1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.f animations:^{
            starview.layer.transform = t1;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.f animations:^{
            circleview.layer.transform = t2;
        }];
        
    } completion:^(BOOL finished) {
        starview.hidden = isHide;
        circleview.hidden = !isHide;
    }];
}

- (CATransform3D) scaleWithView:(UIView*)view direction:(BOOL) isIncrease
{
    CATransform3D scaleT = CATransform3DIdentity;
    CGFloat scale = isIncrease ? 0.1f : 1.0f;
    scaleT = CATransform3DScale(scaleT, scale, scale, 1);
    return scaleT;
}


@end

@implementation DFRatingStar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _starColor = [UIColor colorWithRed:(255/255.f) green:(200/255.f) blue:(0/255.f) alpha:1];
}

- (void) drawRect:(CGRect)rect
{
    CGRect selfFrame = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    double sinAlfa = sinf(DEGREES_TO_RADIANS(72/2));
    double cosAlfa = cosf(DEGREES_TO_RADIANS(72/2));
    double a = CGRectGetMidY(selfFrame) * sinAlfa;
    double b = CGRectGetMidY(selfFrame) * cosAlfa;
    
    double sinAlfa2 = sinf(DEGREES_TO_RADIANS(90-72));
    double cosAlfa2 = cosf(DEGREES_TO_RADIANS(90-72));
    double a2 = CGRectGetMidY(selfFrame) * sinAlfa2;
    double b2 = CGRectGetMidY(selfFrame) * cosAlfa2;
    
    CGContextMoveToPoint(context, CGRectGetMidX(selfFrame), CGRectGetMinY(selfFrame));
    CGContextAddLineToPoint(context, CGRectGetMidX(selfFrame)-a, CGRectGetMidY(selfFrame)+b);
    CGContextAddLineToPoint(context, CGRectGetMidX(selfFrame)+b2, CGRectGetMidY(selfFrame)-a2);
    CGContextAddLineToPoint(context, CGRectGetMidX(selfFrame)-b2, CGRectGetMidY(selfFrame)-a2);
    CGContextAddLineToPoint(context, CGRectGetMidX(selfFrame)+a, CGRectGetMidY(selfFrame)+b);
    CGContextAddLineToPoint(context, CGRectGetMidX(selfFrame), CGRectGetMinY(selfFrame));
    CGContextSetFillColorWithColor(context, _starColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
}

@end

@implementation DFRatingCircle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _circleColor = [UIColor grayColor];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect circle = CGRectMake(2, 2, CGRectGetMaxX(rect) - 4, CGRectGetMaxY(rect) - 4);
    CGContextAddEllipseInRect(ctx, circle);
    CGContextSetFillColorWithColor(ctx, _circleColor.CGColor);
    CGContextFillPath(ctx);
}

@end

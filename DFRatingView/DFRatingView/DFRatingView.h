//
//  DFRatingView.h
//  DFRatingView
//
//  Created by Kiss Tamás on 05/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFRatingView : UIView
@property (nonatomic,assign) NSInteger starCount;
@property (nonatomic,assign) NSInteger rating;
@property (nonatomic,assign) BOOL isActionEnabled;
@property (nonatomic,strong) UIColor* starColor;
@property (nonatomic,strong) UIColor* circleColor;
@end

@interface DFRatingStar : UIView
@property (nonatomic,strong) UIColor* starColor;
@end

@interface DFRatingCircle : UIView
@property (nonatomic,strong) UIColor* circleColor;
@end

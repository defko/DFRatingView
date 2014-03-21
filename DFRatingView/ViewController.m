//
//  ViewController.m
//  DFRatingView
//
//  Created by Kiss Tamás on 20/03/14.
//  Copyright (c) 2014 defko@me.com. All rights reserved.
//

#import "ViewController.h"
#import "DFRatingView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DFRatingView *ratingView;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.ratingView.starCount = 5;
  //  self.ratingView.rating = 3;
   // self.ratingView.isActionEnabled = NO;
}


- (IBAction)change:(id)sender
{
    self.ratingView.starColor = [UIColor brownColor];
    self.ratingView.circleColor = [UIColor blueColor];
}
@end

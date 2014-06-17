//
//  JHLoadingHUD.m
//  ColumnLight
//
//  Created by Alan on 6/17/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHLoadingHUD.h"
#import "JHNotificationName.h"

@interface JHLoadingHUD ()

@property (nonatomic, strong) UIColor *HUDBackgroundColor;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *stringLabel;
@end

@implementation JHLoadingHUD



+ (id)sharedInstance
{
	static JHLoadingHUD *this = nil;
	
	if (!this)
		this = [[JHLoadingHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];//ios resolution
	
	return this;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.HUDBackgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.75];
		
		self.indicator = [[UIActivityIndicatorView alloc] init];
		self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		self.indicator.center = CGPointMake(self.center.x, self.center.y - 50);
		[self addSubview:self.indicator];
		[self.indicator startAnimating];
		
		self.stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
		self.stringLabel.textAlignment = NSTextAlignmentCenter;
		self.stringLabel.adjustsFontSizeToFitWidth = YES;
		self.stringLabel.textColor = [UIColor whiteColor];
		self.stringLabel.center = CGPointMake(self.center.x, self.center.y - 15);
		self.stringLabel.text = @"Looking for devices";
		[self addSubview:self.stringLabel];
    }
    return self;
}

- (void)showLoadingHUDInView:(UIView *)view
{

	self.transform = CGAffineTransformScale(self.transform, 1.3, 1.3);
	self.alpha = 0;
	[view addSubview:self];
	[view bringSubviewToFront:self];
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.transform = CGAffineTransformScale(self.transform, 1/1.3, 1/1.3);
						 self.alpha = 1;
					 }
					 completion:NULL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(hideLoadingHUD)
												 name:HUDSearchingDevicesNotification
											   object:nil];
}
- (void)hideLoadingHUD
{
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
						 self.alpha = 0;
					 } completion:^(BOOL finished) {
						 if (finished) {
							 [[NSNotificationCenter defaultCenter] removeObserver:self];
							 [self removeFromSuperview];
						 }
					 }];
}

- (void)drawRect:(CGRect)rect
{
	CGRect frame = CGRectMake(self.frame.size.width/2 - 70, self.center.y - 90, 140, 100);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame
											   byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 1)];
	[self.HUDBackgroundColor setFill];
	[path fill];
	
}


@end

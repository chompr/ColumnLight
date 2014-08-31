//
//  JHAlarmBrightnessSettingView.m
//  ColumnLight
//
//  Created by Alan on 8/20/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHAlarmBrightnessSettingView.h"
#import <QuartzCore/QuartzCore.h>

#define TITLE_Y 0
#define MIN_SLIDER_VALUE_LABEL_Y 40
#define MIN_SLIDER_Y 60
#define MAX_SLIDER_VALUE_LABEL_Y 110
#define MAX_SLIDER_Y 130
#define BUTTON_Y self.whiteBoard.frame.size.height - 50
#define WHITEBOARD_WIDTH self.bounds.size.width - 20

#define WHITEBOARD_ANIMATION_DURATION 0.5

#define ARROW_LENGTH 13.0
#define MIN_POPUPVIEW_WIDTH 36.0
#define MIN_POPUPVIEW_HEIGHT 27.0
#define POPUPVIEW_WIDTH_PAD 1.15
#define POPUPVIEW_HEIGHT_PAD 1.1



@interface JHAlarmBrightnessSettingView ()


@property (nonatomic, strong) UIView *whiteBoard;
@property (nonatomic, strong) JHAlarmBrightnessSlider *slider;

@end

@implementation JHAlarmBrightnessSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupComponents];
    }
    return self;
}
- (void)setupComponents
{
	self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	
	self.whiteBoard = [[UIView alloc] initWithFrame:CGRectMake(10, 250, WHITEBOARD_WIDTH, 250)];
	self.whiteBoard.backgroundColor = [UIColor whiteColor];
	self.whiteBoard.layer.cornerRadius = 3;
	self.whiteBoard.layer.masksToBounds = YES;
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancelButton.frame = CGRectMake(0, BUTTON_Y, 150, 50);
	cancelButton.backgroundColor = [UIColor redColor];
	[cancelButton setTitle:@"NO" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	yesButton.frame = CGRectMake(150, BUTTON_Y, 150, 50);
	yesButton.backgroundColor = [UIColor blackColor];
	[yesButton setTitle:@"YES" forState:UIControlStateNormal];
	[yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[yesButton addTarget:self action:@selector(yesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_Y, WHITEBOARD_WIDTH, 50)];
	titleLabel.text = @"Alarm Brightness Setting";
	titleLabel.textAlignment = NSTextAlignmentCenter;
	/*
	UILabel *minSliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MIN_SLIDER_VALUE_LABEL_Y, WHITEBOARD_WIDTH, 50)];
	minSliderValueLabel.text = @"min";
	minSliderValueLabel.textAlignment = NSTextAlignmentCenter;
	
	UILabel *maxSliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MAX_SLIDER_VALUE_LABEL_Y, WHITEBOARD_WIDTH, 50)];
	maxSliderValueLabel.text = @"max";
	maxSliderValueLabel.textAlignment = NSTextAlignmentCenter;
	*/
	
	self.slider = [[JHAlarmBrightnessSlider alloc] initWithFrame:CGRectMake(0, MIN_SLIDER_Y, WHITEBOARD_WIDTH, 80) andBrightness:0.8];
	self.slider.filledColor = [UIColor orangeColor];
	self.slider.unfilledColor = [UIColor grayColor];
	
	
	[self addSubview:self.whiteBoard];
	
	[self.whiteBoard addSubview:titleLabel];
	//[self.whiteBoard addSubview:maxSliderValueLabel];
	//[self.whiteBoard addSubview:minSliderValueLabel];
	
	[self.whiteBoard addSubview:self.slider];
	[self.whiteBoard addSubview:yesButton];
	[self.whiteBoard addSubview:cancelButton];
	
}

- (void)showWhiteBoard
{
	self.alpha = 0;
	[self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:0.5
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 1;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 10 - self.whiteBoard.bounds.size.height/2)];
						  }
					 completion:NULL];
	
}

- (void)cancelButtonClicked
{
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:0.5
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 0;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
					 }
					 completion:^(BOOL finished) {
						 if (finished) {

							 [self removeFromSuperview];
						 }
					 }];
}

- (void)yesButtonClicked
{
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:0.5
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 0;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 
							 [self removeFromSuperview];
						 }
					 }];
}


@end

@interface JHAlarmBrightnessSlider ()

@property (nonatomic, strong) UIImageView *minHandleView;
@property (nonatomic, strong) UIImageView *maxHandleView;
@property (nonatomic, strong) JHPopupView *popupView;
@end
									   								
@implementation JHAlarmBrightnessSlider

- (id)initWithFrame:(CGRect)frame andBrightness:(CGFloat)brightness
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.barOffset = 38;
		self.currentMinValue = self.barOffset + brightness * (self.frame.size.width - 2 * self.barOffset);
		
		self.minHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barHandle.png"]];
		self.minHandleView.center = CGPointMake(self.currentMinValue, self.frame.size.height/2);
		
		self.popupView = [[JHPopupView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		[self.popupView setTextColor:[UIColor whiteColor]];
		[self addSubview:self.popupView];
		self.popupView.layer.opacity = 0;
		[self addSubview:self.minHandleView];
		
	}
	return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
	CGFloat brightness = [self calculateBrightness];
	
	self.popupView.center = CGPointMake(self.currentMinValue, 0);
	[self.popupView show];
	[self.popupView setString:[NSString stringWithFormat:@"%2.f%%",brightness * 100]];
	
	
	if (touchPoint.y > self.frame.size.height/2 - 20 && touchPoint.y < self.frame.size.height/2 + 20) {
		if (touchPoint.x > self.currentMinValue - 25 && touchPoint.x < self.currentMinValue + 25) {
			NSLog(@"In touch range");
			return YES;
		}
	}

	
	
	NSLog(@"Not in touch range");
	return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
	
	self.currentMinValue = touchPoint.x;
	if (self.currentMinValue < self.barOffset) {
		self.currentMinValue = self.barOffset;
	} else if (self.currentMinValue > self.frame.size.width - self.barOffset) {
		self.currentMinValue = self.frame.size.width - self.barOffset; // the value is exceeding the bar length. so keep the maximum value
	}
	
	CGFloat brightness = [self calculateBrightness];
	self.minHandleView.center = CGPointMake(self.currentMinValue, self.frame.size.height/2);
	self.popupView.center = CGPointMake(self.currentMinValue, 0);
	[self.popupView setString:[NSString stringWithFormat:@"%2.f%%",brightness * 100]];
	[self setNeedsDisplay];
	
	return YES;
	
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self.popupView hide];
}

- (CGFloat)calculateBrightness
{
	CGFloat brightness = (self.currentMinValue - self.barOffset) / (self.frame.size.width - 2 * self.barOffset);
	return brightness;
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//Draw unfilled arc;
	CGContextMoveToPoint(context, self.barOffset, self.frame.size.height/2);
	CGContextAddLineToPoint(context, self.frame.size.width - self.barOffset, self.frame.size.height/2);
	[self.unfilledColor setStroke];
	CGContextSetLineWidth(context, 6);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextDrawPath(context, kCGPathStroke);
	
	CGContextMoveToPoint(context, self.barOffset, self.frame.size.height/2);
	CGContextAddLineToPoint(context, self.currentMinValue, self.frame.size.height/2);
	[self.filledColor setStroke];
	CGContextSetLineWidth(context, 6);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextDrawPath(context, kCGPathStroke);
		
	
}
@end

@interface JHPopupView ()


@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat arrowCenterOffset;


@end

@implementation JHPopupView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		
		
		self.backgroundLayer = [CAShapeLayer layer];
		self.backgroundLayer.fillColor = [UIColor darkGrayColor].CGColor;
		self.backgroundLayer.anchorPoint = CGPointZero;
		
		self.textLayer = [CATextLayer layer];
		self.textLayer.alignmentMode = kCAAlignmentCenter;
		self.textLayer.anchorPoint = CGPointZero;
		self.textLayer.contentsScale = [UIScreen mainScreen].scale;
		
		
		[self.layer addSublayer:self.backgroundLayer];
		[self.layer addSublayer:self.textLayer];
		
		self.attributedString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:nil];
		
		self.cornerRadius = 4;
		self.arrowCenterOffset = 0;
		[self drawPath];
	}
	return self;
}

#pragma mark - Setter & Getter -

- (void)setTextColor:(UIColor *)color
{
	[self.attributedString addAttribute:NSForegroundColorAttributeName
								  value:(id)color.CGColor
								  range:NSMakeRange(0, [self.attributedString length])];
}

- (void)setString:(NSString *)string
{
	[[self.attributedString mutableString] setString:string];
	self.textLayer.string = self.attributedString;
}

- (CGSize)popupSizeForString:(NSString *)string
{
	[[self.attributedString mutableString] setString:string];
	CGFloat w, h;
	w = ceilf(MAX([self.attributedString size].width, MIN_POPUPVIEW_WIDTH) * POPUPVIEW_WIDTH_PAD);
	h = ceilf(MAX([self.attributedString size].height, MIN_POPUPVIEW_HEIGHT) * POPUPVIEW_HEIGHT_PAD + ARROW_LENGTH);
	
	return CGSizeMake(w, h);
}

#pragma mark - Animation -

- (void)show
{
	[CATransaction begin];
	
	// start the transform animation from its current value if it's already running
	NSValue *fromValue = [self.layer animationForKey:@"transform"] ?
	[self.layer.presentationLayer valueForKey:@"transform"] : [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	scaleAnimation.fromValue = fromValue;
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	[scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.8 :2.5 :0.35 :0.5]];
	scaleAnimation.duration = 0.3;
	scaleAnimation.removedOnCompletion = NO;
	scaleAnimation.fillMode = kCAFillModeForwards;

	[self.layer addAnimation:scaleAnimation forKey:@"transform"];
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.fromValue = [self.layer.presentationLayer valueForKey:@"opacity"];
	fadeInAnimation.toValue = @1.0;
	fadeInAnimation.duration = 0.1;
	
	[self.layer addAnimation:fadeInAnimation forKey:@"opacity"];
	
	self.layer.opacity = 1.0;
	[CATransaction commit];
}

- (void)hide
{
	[CATransaction begin];
	[CATransaction setCompletionBlock:^{
		//remove the transform animation if the animation finished and wasn't interrupted
		if (self.layer.opacity == 0) {
			[self.layer removeAnimationForKey:@"transform"];
		}
	}];
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	scaleAnimation.fromValue = [self.layer.presentationLayer valueForKey:@"transform"];
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1)];
	[scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.0:0.0:1.0:0.0]];
	scaleAnimation.duration = 0.2;
	scaleAnimation.removedOnCompletion = NO;
	scaleAnimation.fillMode = kCAFillModeForwards;
	
	[self.layer addAnimation:scaleAnimation forKey:@"transform"];
	
	CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnimation.fromValue = [self.layer.presentationLayer valueForKey:@"opacity"];
	fadeOutAnimation.toValue = @0.0;
	fadeOutAnimation.duration = 0.8;
	[self.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
	self.layer.opacity = 0.0;
	[CATransaction commit];
	
	
}

#pragma mark - Drawings -

- (void)layoutSubviews
{
	CGFloat textHeight = [self.textLayer.string size].height;
	CGRect textRect = CGRectMake(self.bounds.origin.x,
								 (self.bounds.size.height - ARROW_LENGTH - textHeight)/2,
								 self.bounds.size.width,
								 textHeight);
	self.textLayer.frame = CGRectIntegral(textRect);
}

- (void)drawPath
{
	CGRect roundRect = self.bounds;
	roundRect.size.height -= ARROW_LENGTH;
	UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:self.cornerRadius];
	
	CGFloat maxX = CGRectGetMaxX(roundRect); // prevent arrow from extending beyond this point
	CGFloat arrowTipX = CGRectGetMidX(self.bounds) + self.arrowCenterOffset;
	CGPoint tip = CGPointMake(arrowTipX, CGRectGetMaxY(self.bounds));
	
	CGFloat arrowLength = CGRectGetHeight(roundRect)/2.0;
	CGFloat x = arrowLength;
	
	UIBezierPath *arrowPath = [UIBezierPath bezierPath];
	[arrowPath moveToPoint:tip];
	[arrowPath addLineToPoint:CGPointMake(MAX(arrowTipX - x, 0), CGRectGetMaxY(roundRect) - arrowLength)];
	[arrowPath addLineToPoint:CGPointMake(MIN(arrowTipX + x, maxX), CGRectGetMaxY(roundRect) - arrowLength)];
	[arrowPath closePath];
	
	[roundRectPath appendPath:arrowPath];
	self.backgroundLayer.path = roundRectPath.CGPath;
	
	
}



@end























//
//  JHBrightnessSlider.m
//  ColumnLight
//
//  Created by Alan on 5/30/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHBrightnessSlider.h"

@interface JHBrightnessSlider ()

@property (nonatomic, strong) UIImageView *handleView;

@end

@implementation JHBrightnessSlider

- (id)initWithFrame:(CGRect)frame andBrightness:(CGFloat)brightness
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.barOffset = 38;
		self.currentValue = self.barOffset + brightness * (self.frame.size.width - 2 * self.barOffset);
		
		self.handleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barHandle.png"]];
		self.handleView.center = CGPointMake(self.currentValue, self.frame.size.height/2);
		
		[self addSubview:self.handleView];
		
		UIImageView *minBright = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
		minBright.image = [UIImage imageNamed:@"minBright.png"];
		minBright.center = CGPointMake(15, self.frame.size.height/2);
		[self addSubview:minBright];
		
		UIImageView *maxBright = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
		maxBright.image = [UIImage imageNamed:@"maxBright.png"];
		maxBright.center = CGPointMake(self.frame.size.width - 15, self.frame.size.height/2);
		[self addSubview:maxBright];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	//[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();

	//Draw unfilled arc;
	//CGContextAddArc(context, self.frame.size.width/2, 0, 200, 55/180.f * M_PI, 125/180.f * M_PI, 0);
	CGContextMoveToPoint(context, self.barOffset, self.frame.size.height/2);
	CGContextAddLineToPoint(context, self.frame.size.width - self.barOffset, self.frame.size.height/2);
	[self.unfilledColor setStroke];
	CGContextSetLineWidth(context, 6);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextDrawPath(context, kCGPathStroke);
	
	//CGContextAddArc(context, self.frame.size.width/2, 0, 200, 0.5 * M_PI, 125/180.f * M_PI, 0);
	CGContextMoveToPoint(context, self.barOffset, self.frame.size.height/2);
	CGContextAddLineToPoint(context, self.currentValue, self.frame.size.height/2);
	[self.filledColor setStroke];
	CGContextSetLineWidth(context, 6);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextDrawPath(context, kCGPathStroke);
	
	//Draw filled arc;
	

}


#pragma mark - UIControl Functions

- (void)updateSliderCurrentValue:(float)currentValue
{
	self.currentValue = currentValue;
	CGFloat brightness = [self calculateBrightness];
	[self setNeedsDisplay];
	[self.delegate sliderEndChangingBrightness:brightness];
}

- (CGFloat)calculateBrightness
{
	CGFloat brightness = (self.currentValue - self.barOffset) / (self.frame.size.width - 2 * self.barOffset);
	return brightness;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
	//NSLog(@" %f", touchPoint.y);
	if (touchPoint.y > self.frame.size.height/2 - 20 && touchPoint.y < self.frame.size.height/2 + 20) {
		if (touchPoint.x > self.currentValue - 25 && touchPoint.x < self.currentValue + 25) {
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
	
	self.currentValue = touchPoint.x;
	if (self.currentValue < self.barOffset) {
		self.currentValue = self.barOffset;
		
	} else if (self.currentValue > self.frame.size.width - self.barOffset) {
		self.currentValue = self.frame.size.width - self.barOffset;
		
	}
	CGFloat brightness = [self calculateBrightness];
	//NSLog(@"brightness : %f", brightness);
	
	self.handleView.center = CGPointMake(self.currentValue, self.frame.size.height/2);

	[self setNeedsDisplay];
	[self.delegate sliderContinueChangingBrightness:brightness];
	
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGFloat brightness = [self calculateBrightness];
	[self.delegate sliderEndChangingBrightness:brightness];
}


@end










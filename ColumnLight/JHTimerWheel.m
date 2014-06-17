//
//  JHTimerWheel.m
//  ColumnLight
//
//  Created by Alan on 6/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHTimerWheel.h"

static float deltaAngle;

@implementation JHTimerWheel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.unfilledMinColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
		self.unfilledHourColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
		
		self.currentAngleInHour = M_PI/2;
		self.currentAngleInMin = M_PI/2;
		[self drawLabels];
    }
    return self;
}
- (void)drawLabels
{
	self.minLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
	self.minLabel.backgroundColor = [UIColor clearColor];
	self.minLabel.layer.anchorPoint = CGPointMake(1.0, 0.5);
	self.minLabel.layer.position = CGPointMake(self.frame.size.width/2,
											   self.frame.size.height/2);
	self.minLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
	self.minLabel.userInteractionEnabled = NO;
	UIImageView *minBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	minBG.image = [UIImage imageNamed:@"minLabel.png"];
	[self.minLabel addSubview:minBG];
	minBG.center = CGPointMake(20, 20);
	[self addSubview:self.minLabel];
	
	self.hourLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
	self.hourLabel.backgroundColor = [UIColor clearColor];
	self.hourLabel.layer.anchorPoint = CGPointMake(1.0, 0.5);
	self.hourLabel.layer.position = CGPointMake(self.frame.size.width/2,
												self.frame.size.height/2);
	self.hourLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
	self.hourLabel.userInteractionEnabled = NO;
	UIImageView *hourBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	hourBG.image = [UIImage imageNamed:@"hourLabel.png"];
	[self.hourLabel addSubview:hourBG];
	hourBG.center = CGPointMake(20, 20);
	[self addSubview:self.hourLabel];
	
	self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
	//self.timeLabel.backgroundColor = [UIColor orangeColor];
	self.timeLabel.textAlignment = NSTextAlignmentCenter;
	self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36];
	self.timeLabel.textColor = [UIColor grayColor];
	self.timeLabel.text = @"00:00";
	self.timeLabel.adjustsFontSizeToFitWidth = YES;
	self.timeLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 5);
	[self addSubview:self.timeLabel];
	
	self.amLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	//self.amLabel.backgroundColor = [UIColor orangeColor];
	self.amLabel.textAlignment = NSTextAlignmentCenter;
	self.amLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	self.amLabel.textColor = [UIColor grayColor];
	self.amLabel.text = @"AM";
	self.amLabel.adjustsFontSizeToFitWidth = YES;
	self.amLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 30);
	[self addSubview:self.amLabel];
	
	
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, 90, 0.f, 2 * M_PI, YES);
	[self.unfilledHourColor setStroke];
	CGContextSetLineWidth(context, 40);
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextDrawPath(context, kCGPathStroke);
	
	CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, 130, 0.f, 2 * M_PI, YES);
	[self.unfilledMinColor setStroke];
	CGContextSetLineWidth(context, 40);
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextDrawPath(context, kCGPathStroke);
}


- (float)calculateDistanceFromCenter:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrtf(dx*dx + dy*dy);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
	
	float dist = [self calculateDistanceFromCenter:touchPoint];
	
	if (dist < 70 || dist > 150) {
		NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
		return NO;
	}
	float dx = touchPoint.x - self.minLabel.center.x;
	float dy = touchPoint.y - self.minLabel.center.y;
	
	deltaAngle = atan2f(dy, dx);
	//self.startTransform = self.minLabel.transform;
	
	if (dist > 70 && dist < 110) {
		//self.startTransform = self.hourLabel.transform;
		self.isSettingHour = YES;
		self.isSettingMin = NO;
		float dx = touchPoint.x - self.hourLabel.center.x;
		float dy = touchPoint.y - self.hourLabel.center.y;
		
		deltaAngle = atan2f(dy, dx);
	}
	if (dist > 110 && dist < 150) {
		//self.startTransform = self.minLabel.transform;
		self.isSettingMin = YES;
		self.isSettingHour = NO;
		float dx = touchPoint.x - self.minLabel.center.x;
		float dy = touchPoint.y - self.minLabel.center.y;
		
		deltaAngle = atan2f(dy, dx);
	}
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	//CGFloat radians = atan2f(self.container.transform.b, self.container.transform.a);
	//NSLog(@"rad is %f", radians);
	CGPoint touchPoint = [touch locationInView:self];
	
	 float dist = [self calculateDistanceFromCenter:touchPoint];
	 if (dist < 30 || dist > 160) {
	 NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
	 return NO;
	 }
	 
	
	if (self.isSettingHour) {
		float dx = touchPoint.x - self.hourLabel.center.x ;
		float dy = touchPoint.y - self.hourLabel.center.y ;
		float ang = atan2f(dy, dx);
		float angleDifference = ang - deltaAngle;
		
		
		//NSLog(@"angle difference is %f", angleDifference);
		
		self.currentAngleInHour += angleDifference;
		
		if (self.currentAngleInHour > M_PI) self.currentAngleInHour -= 2 * M_PI;
		else if (self.currentAngleInHour < -M_PI) self.currentAngleInHour += 2 * M_PI;
		
		self.hourLabel.transform = CGAffineTransformMakeRotation(self.currentAngleInHour);
		
		
		
		if (self.currentAngleInHour < M_PI && self.currentAngleInHour > 0)
			self.percInHour = self.currentAngleInHour/M_PI * 0.5;
		
		else if (self.currentAngleInHour > -M_PI && self.currentAngleInHour < 0)
			self.percInHour = 1 + self.currentAngleInHour/M_PI * 0.5;
		
		// percent in hour has 0.25 offset, but I cant borther
		self.hour = floor(self.percInHour  * 12) + 9;
		if (self.hour > 11) self.hour -= 12;
		self.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)self.hour,(unsigned long)self.min];
		//NSLog(@"hour percent is %lu", (long)self.hour);
		deltaAngle = ang;
	}
	if (self.isSettingMin) {
		float dx = touchPoint.x - self.minLabel.center.x ;
		float dy = touchPoint.y - self.minLabel.center.y ;
		float ang = atan2f(dy, dx);
		float angleDifference = ang - deltaAngle;
		
		
		//NSLog(@"angle difference is %f", angleDifference);
		
		self.currentAngleInMin += angleDifference;
		
		if (self.currentAngleInMin > M_PI) self.currentAngleInMin -= 2 * M_PI;
		else if (self.currentAngleInMin < -M_PI) self.currentAngleInMin += 2 * M_PI;
		
		self.minLabel.transform = CGAffineTransformMakeRotation(self.currentAngleInMin);
		
		
		
		if (self.currentAngleInMin < M_PI && self.currentAngleInMin > 0)
			self.percInMin = self.currentAngleInMin/M_PI * 0.5;
		
		else if (self.currentAngleInMin > -M_PI && self.currentAngleInMin < 0)
			self.percInMin = 1 + self.currentAngleInMin/M_PI * 0.5;
		
		// percent in hour has 0.25 offset, but I cant borther
		self.min = floor(self.percInMin  * 60) + 45;
		if (self.min > 59) self.min -= 60;
		self.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)self.hour,(unsigned long)self.min];
		//NSLog(@"min percent is %lu", (long)self.min);
		
		deltaAngle = ang;
	}
	
	return YES;
	

}
@end

//if (ang > 0 && deltaAngle < 0) angleDifference -= 2 * M_PI;
	//else if (ang < 0 && deltaAngle > 0) angleDifference += 2 * M_PI;
	//NSLog(@"angle difference is %f", angleDifference);
	
	
	/*
	if (self.isSettingMin) {
		if (dist < 110 || dist > 160) {
			NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
			//deltaAngle = ang;
			return NO;
	 */
		/*
		self.currentAngleInMin = angleDifference;
		if (self.currentAngleInMin > M_PI) self.currentAngleInMin -= 2 * M_PI;
		else if (self.currentAngleInMin < -M_PI) self.currentAngleInMin += 2 * M_PI;
		NSLog(@"angle difference is %f | %f | %f | %f", angleDifference, deltaAngle, ang,self.currentAngleInMin);
		//deltaAngle = ang;
		
		if (self.currentAngleInMin < M_PI && self.currentAngleInMin > 0)
			self.percInMin =  1 - (self.currentAngleInMin/M_PI * 0.5);
		else if (self.currentAngleInMin > -M_PI && self.currentAngleInMin < 0)
			self.percInMin = -(self.currentAngleInMin/M_PI * 0.5);
		self.percInMin = 1 - self.percInMin;
		NSLog(@"percent is %f", floor(self.percInMin * 60));*/
		
		//[self setNeedsDisplay];
		//deltaAngle = ang;

	/*
	if (self.isSettingHour) {
		if (dist < 60 || dist > 110) {
			NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
			deltaAngle = ang;
			return NO;
		}
		self.currentAngleInHour += angleDifference;
		NSLog(@"angle difference is %f | %f | %f | %f", angleDifference, deltaAngle, ang,self.currentAngleInHour);
		if (self.currentAngleInHour > M_PI) self.currentAngleInHour -= 2 * M_PI;
		else if (self.currentAngleInHour < -M_PI) self.currentAngleInHour += 2 * M_PI;
		//NSLog(@"angle difference is %f | %f | %f | %f", angleDifference, deltaAngle, ang,self.currentAngleInMin);
		deltaAngle = ang;
		
		if (self.currentAngleInHour < M_PI && self.currentAngleInHour > 0)
			self.percInHour =  1 - (self.currentAngleInHour/M_PI * 0.5);
		else if (self.currentAngleInHour > -M_PI && self.currentAngleInHour < 0)
			self.percInHour = -(self.currentAngleInHour/M_PI * 0.5);
		self.percInHour = 1 - self.percInHour;
		NSLog(@"percent is %f", floor(self.percInHour * 12));
		[self setNeedsDisplay];
	}*/

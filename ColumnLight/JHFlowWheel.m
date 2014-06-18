//
//  JHFlowWheel.m
//  ColumnLight
//
//  Created by Alan on 5/31/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHFlowWheel.h"
#import "JHPickerWheel.h"



@interface JHFlowWheel ()

@property (nonatomic, assign) float currentAngle;
@property (nonatomic, strong) CAShapeLayer *sectorBrightnessLayer;
@property (nonatomic, strong) CALayer *centerShadowLayer;
@end

static float deltaAngle;

@implementation JHFlowWheel

- (id)initWithFrame:(CGRect)frame andDelegate:(id<JHFlowWheelDelegate>)delegate withSections:(int)numberOfSections andColor:(Color *)color
{
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.numberOfSections = numberOfSections;
		self.delegate = delegate;
		self.brightness = color.brightness;
		self.currentAngleInHUE = color.hue;
		
		NSLog(@"Saved HUE is %f", self.currentAngleInHUE);
		if (self.currentAngleInHUE > 0 && self.currentAngleInHUE < 0.5) {
			self.currentAngle = - self.currentAngleInHUE/0.5 * M_PI;
		}
		else if (self.currentAngleInHUE > 0.5 && self.currentAngleInHUE < 1) {
			self.currentAngle = (1 - self.currentAngleInHUE)/0.5 * M_PI;
		}
		else {
			self.currentAngle = 0;
		}
		
		[self drawWheel];
		[self.layer insertSublayer:self.sectorBrightnessLayer atIndex:1];
		[self setPanelShadow:self.brightness];
		
		NSLog(@"current angle is %f",self.currentAngle);
	}
	
	return self;
}
#pragma mark - Setter & Getter

- (NSMutableArray *)colors
{
	if (!_colors) _colors = [[NSMutableArray alloc] init];
	return _colors;
}

- (CALayer *)sectorBrightnessLayer
{
	if (!_sectorBrightnessLayer) {
		_sectorBrightnessLayer = [CAShapeLayer layer];
		_sectorBrightnessLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																	 radius:146
																 startAngle:0.0
																   endAngle:360.0
																  clockwise:YES].CGPath;
		_sectorBrightnessLayer.backgroundColor = [UIColor blackColor].CGColor;
	}
	
	return _sectorBrightnessLayer;
}

- (CALayer *)centerShadowLayer
{
	if (!_centerShadowLayer) {
		_centerShadowLayer = [[CALayer alloc] init];
		_centerShadowLayer.shadowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																	   radius:90
																   startAngle:0.0
																	 endAngle:360.0
																	clockwise:YES].CGPath;
	}
	return _centerShadowLayer;
}
#pragma mark -


- (void)drawWheel
{
	self.container = [[UIView alloc] initWithFrame:self.frame];
	
	self.sectors = [[NSMutableArray alloc] init];
	
	CGFloat angleSize = 2 * M_PI / self.numberOfSections;
	
	// ----- Create sectors
	for (int i = 0; i < self.numberOfSections; i++) {
		JHFlowWheelSectorView *im = [[JHFlowWheelSectorView alloc] initWithFrame:CGRectMake(0, 0, 150, 14)];
		
		im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
		im.layer.position = CGPointMake(self.container.bounds.size.width/2.0 - self.container.frame.origin.x,
										self.container.bounds.size.height/2.0 - self.container.frame.origin.y);
		
		im.transform = CGAffineTransformMakeRotation(i*angleSize);
		CGFloat prepareAngle = 0;
		if (i < 20) {
			// ------- Initial color setups
			prepareAngle = i * 1/360.f + self.currentAngleInHUE;
			if (prepareAngle > 1)
				prepareAngle -= 1;
			UIColor *color = [UIColor colorWithHue:prepareAngle saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			im.sectorColor = color;
		} else if (i >= 20 && i <= 52) {
			prepareAngle = (i-20) * 10/360.f + 20/360.f + self.currentAngleInHUE;
			if (prepareAngle > 1)
				prepareAngle -= 1;
			UIColor *color = [UIColor colorWithHue:prepareAngle saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			im.sectorColor = color;
		} else if (i > 52) {
			prepareAngle = 340/360.f + (i-52) * 1/360.f + self.currentAngleInHUE;
			if (prepareAngle > 1)
				prepareAngle -= 1;
			UIColor *color = [UIColor colorWithHue:prepareAngle saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			im.sectorColor = color;
		}
		[self.sectors addObject:im];
		im.tag = i;
		
		[self.container addSubview:im];
	}
	// -------
	self.container.userInteractionEnabled = NO;
	self.container.transform = CGAffineTransformMakeRotation(M_PI/2.0);
	[self addSubview:self.container];
	

	
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
	bg.image = [UIImage imageNamed:@"wheelBG.png"];
	[self addSubview:bg];
}


- (float)calculateDistanceFromCenter:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrtf(dx*dx + dy*dy);
}

- (void)updateSectorColorsWithAngleDifference:(CGFloat)difference
{
	[self.colors removeAllObjects];
	float temp;
	for (int i = 0; i < self.numberOfSections; i++) {
		JHFlowWheelSectorView *view = [self.sectors objectAtIndex:i];
		if (i < 20) {
			temp = i * 1/360.f + difference;
			if (temp > 1) temp -= 1;
			if (temp < 0) temp += 1;
			UIColor *color = [UIColor colorWithHue:temp saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			view.sectorColor = color;
		} else if (i >= 20 && i <= 52) {
			temp = (i-20) * 10/360.f + 20/360.f + difference;
			if (temp > 1) temp -= 1;
			if (temp < 0) temp += 1;
			UIColor *color = [UIColor colorWithHue:temp saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			view.sectorColor = color;
		} else if (i > 52) {
			temp = (i-52) * 1/360.f + difference + 340/360.f;
			if (temp > 1) temp -= 1;
			if (temp < 0) temp += 1;
			UIColor *color = [UIColor colorWithHue:temp saturation:1 brightness:1 alpha:1];
			[self.colors insertObject:color atIndex:i];
			view.sectorColor = color;
		}
		[view setNeedsDisplay];
	}
}

#pragma mark - UIControl Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
	
	float dist = [self calculateDistanceFromCenter:touchPoint];
	
	if (dist < 90 || dist > 146) {
		NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
		return NO;
	}
	float dx = touchPoint.x - self.container.center.x;
	float dy = touchPoint.y - self.container.center.y;
	
	deltaAngle = atan2f(dy, dx);
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	//CGFloat radians = atan2f(self.container.transform.b, self.container.transform.a);
	//NSLog(@"rad is %f", radians);
	
	CGPoint touchPoint = [touch locationInView:self];

	 float dist = [self calculateDistanceFromCenter:touchPoint];
	 if (dist < 90 || dist > 146) {
	 NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
	 return NO;
	 }

	float dx = touchPoint.x - self.container.center.x ;
	float dy = touchPoint.y - self.container.center.y ;

	float ang = atan2f(dy, dx);
	
	float angleDifference = ang - deltaAngle;
	
	if (ang > 0 && deltaAngle < 0) angleDifference -= 2 * M_PI;
	else if (ang < 0 && deltaAngle > 0) angleDifference += 2 * M_PI;
	
	self.currentAngle += angleDifference;
	//NSLog(@"angle difference is %f | %f | %f | %f", angleDifference, deltaAngle, ang,self.currentAngle);
	if (self.currentAngle > M_PI) self.currentAngle -= 2 * M_PI;
	else if (self.currentAngle < -M_PI) self.currentAngle += 2 * M_PI;
	

	
	if (self.currentAngle < M_PI && self.currentAngle > 0)
		self.currentAngleInHUE =  1 - (self.currentAngle/M_PI * 0.5);
	else if (self.currentAngle > -M_PI && self.currentAngle < 0)
		self.currentAngleInHUE = -(self.currentAngle/M_PI * 0.5);
	
	NSLog(@"angle is %f | %f", self.currentAngle, self.currentAngleInHUE);
	
	//NSLog(@"the angle difference is %f", angleDifference);
	[self updateSectorColorsWithAngleDifference:self.currentAngleInHUE];
	deltaAngle = ang;
	
	
	//NSLog(@"delta angle is %f", touchPoint.x);
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self.delegate wheelDidChangeHUE:self.currentAngleInHUE andBrightness:self.brightness];
}

#pragma mark - Slider Delegate

- (void)sliderContinueChangingBrightness:(CGFloat)brightness
{
	[self setPanelShadow:brightness];
}
- (void)sliderEndChangingBrightness:(CGFloat)brightness
{
	self.brightness = brightness;
	[self setPanelShadow:brightness];
	[self.delegate wheelDidChangeHUE:self.currentAngleInHUE andBrightness:self.brightness];
}


#pragma mark - Components state update -
- (void)setPanelShadow:(CGFloat)percent
{
	//[self.sectorBrightnessLayer removeFromSuperlayer];
	self.sectorBrightnessLayer.opacity = 0.55 - 0.5 * percent;
	//[self.layer insertSublayer:self.sectorBrightnessLayer atIndex:1];
	
}
- (void)switchOn
{
	self.userInteractionEnabled = YES;
	[self.centerShadowLayer removeFromSuperlayer];
	self.centerShadowLayer.shadowOpacity = 0.f ; // typical 3 * brightness
	self.centerShadowLayer.shadowRadius = 10;
	self.centerShadowLayer.shadowOffset = CGSizeZero;
	[self.layer insertSublayer:self.centerShadowLayer atIndex:1];
	[self setPanelShadow:self.brightness];
}

- (void)switchOff
{
	self.userInteractionEnabled = NO;
	[self.centerShadowLayer removeFromSuperlayer];
	self.centerShadowLayer.shadowOpacity = 0.9; // typical 3 * brightness
	self.centerShadowLayer.shadowRadius = 30;
	self.centerShadowLayer.shadowOffset = CGSizeZero;
	[self.layer insertSublayer:self.centerShadowLayer atIndex:1];
	[self setPanelShadow:0.f];
}

@end

@interface JHFlowWheelSectorView ()

@property UIBezierPath *aPath;

@end

@implementation JHFlowWheelSectorView

#pragma mark - Flow WHeel Sector View Class

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		//[self setNeedsDisplay];
		self.sectorColor = [UIColor clearColor];
		self.aPath = [UIBezierPath bezierPath];
		
		[self.aPath moveToPoint:CGPointMake(0.0, 0.0)];
		[self.aPath addLineToPoint:CGPointMake(150, 7)];
		[self.aPath addLineToPoint:CGPointMake(0.0, 14)];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//NSLog(@"drawing a custom sector frame");

	
	[self.aPath closePath];
	[self.sectorColor setFill];
	//[self.aPath fillWithBlendMode:kCGBlendModeColor alpha:0.5];
	[self.aPath fill];
	/*
	[self.layer setShadowPath:self.aPath.CGPath];
	[self.layer setShadowColor:self.sectorColor.CGColor];
	[self.layer setShadowRadius:4];
	[self.layer setShadowOpacity:0.8];
	[self.layer setShadowOffset:CGSizeZero];
	 */
	
}
@end


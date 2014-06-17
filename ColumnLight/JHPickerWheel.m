//
//  JHPickerWheel.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHPickerWheel.h"
#import <QuartzCore/QuartzCore.h>
//#import "JHSector.h"

//static float minAlphaValue = 0.6;
//static float maxAlphaValue = 1.0;



@interface JHPickerWheel()

@property (nonatomic, strong) CALayer *centerShadowLayer;
@property (nonatomic, strong) CALayer *contourShadowLayer;
@property (nonatomic, strong) CALayer *sectorBrightnessLayer;

- (float)calculateDistanceFromCenter:(CGPoint)point;
- (void)buildSectorEven;
- (void)buildSectorOdd;
- (UIImageView *)getSectorByValue:(int)value;

@end

static float deltaAngle;

@implementation JHPickerWheel

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate withSections:(int)numberOfSections andWhite:(White *)white
{
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		
		[self createColors];
		
		self.numberOfSections = numberOfSections;
		self.currentSector = white.sectorNumber;
		
		NSLog(@"sector number is %i", self.currentSector);
		
		self.brightness = white.brightness;
		self.delegate = delegate;
		
		[self drawWheel];
		[self setPanelShadow:self.brightness];
	}

	return self;
}
- (void)createColors
{
	
}
- (void)drawWheel
{
	self.container = [[UIView alloc] initWithFrame:self.frame];

	CGFloat angleSize = 2 * M_PI / self.numberOfSections;
	
	// ----- Create sectors
	for (int i = 0; i < self.numberOfSections; i++) {
		JHPickerWheelSectorView *im = [[JHPickerWheelSectorView alloc] initWithFrame:CGRectMake(0, 0, 150, 52) andColor:[self.colors objectAtIndex:i]];

		//im.backgroundColor = [self.whiteColors objectAtIndex:i];
		//im.image = [UIImage imageNamed:[NSString stringWithFormat:@"segment.png"]];
		
		im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
		im.layer.position = CGPointMake(self.container.bounds.size.width/2.0 - self.container.frame.origin.x,
										self.container.bounds.size.height/2.0 - self.container.frame.origin.y);
		im.transform = CGAffineTransformMakeRotation(angleSize * i);
		
		im.tag = i;
		[self.container addSubview:im];
	}
	// -------
	self.container.userInteractionEnabled = NO;
	self.container.transform = CGAffineTransformMakeRotation(2 * M_PI/self.numberOfSections/2.f + (4 - self.currentSector) * angleSize);
	//self.container.transform = CGAffineTransformMakeRotation(self.currentSector * angleSize);
	[self addSubview:self.container];
	
	self.sectors = [NSMutableArray arrayWithCapacity:self.numberOfSections];
	if (self.numberOfSections % 2 == 0) {
		[self buildSectorEven];
	} else {
		[self buildSectorOdd];
	}
	
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
	bg.image = [UIImage imageNamed:@"wheelBG.png"];
	[self addSubview:bg];
	

	
	
}
- (void)drawRect:(CGRect)rect
{
	UIBezierPath *contourCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																 radius:154
															 startAngle:0.0
															   endAngle:360.0
															  clockwise:YES];
	[[UIColor whiteColor] setFill];
	[contourCircle fill];
	// this shadows opacity is a constant;
	self.layer.shadowPath = contourCircle.CGPath;
	self.layer.shadowOpacity = 0.f; // typically 0.05
	self.layer.shadowRadius = 10;		// typically 6
	self.layer.shadowOffset = CGSizeZero;


	
}
- (CALayer *)sectorBrightnessLayer
{
	if (!_sectorBrightnessLayer) _sectorBrightnessLayer = [[CALayer alloc] init];
	return _sectorBrightnessLayer;
}
- (CALayer *)centerShadowLayer
{
	if (!_centerShadowLayer) _centerShadowLayer = [[CALayer alloc] init];
	return _centerShadowLayer;
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
	
	self.startTransform = self.container.transform;
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	//CGFloat radians = atan2f(self.container.transform.b, self.container.transform.a);
	//NSLog(@"rad is %f", radians);
	
	CGPoint touchPoint = [touch locationInView:self];
	/*
	float dist = [self calculateDistanceFromCenter:touchPoint];
	if (dist < 40 || dist > 146) {
		NSLog(@"ignoring tap (%f, %f", touchPoint.x, touchPoint.y);
		return NO;
	}
	 */
	float dx = touchPoint.x - self.container.center.x ;
	float dy = touchPoint.y - self.container.center.y ;
	
	float ang = atan2f(dy, dx);
	
	float angleDifference = deltaAngle - ang;
	
	self.container.transform = CGAffineTransformRotate(self.startTransform, -angleDifference);
	//NSLog(@"delta angle is %f", touchPoint.x);
	return YES;

}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGFloat radians = atan2f(self.container.transform.b, self.container.transform.a);
	CGFloat newVal = 0.0;
	
	for (JHSector *sector in self.sectors) {
		
		if (sector.minValue > 0 && sector.maxValue < 0) {
			if (sector.maxValue > radians || sector.minValue < radians) {
				if (radians > 0) {
					newVal = radians - M_PI;
				} else {
					newVal = M_PI + radians;
				}
				self.currentSector = sector.sector;
			}
		}
		if (radians > sector.minValue && radians < sector.maxValue) {
			newVal = radians - sector.midValue;
			self.currentSector = sector.sector;
			break;
		}

	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	CGAffineTransform t = CGAffineTransformRotate(self.container.transform, -newVal);
	self.container.transform = t;
	[UIView commitAnimations];
	
	//self.selectedColor = [self.colors objectAtIndex:self.currentSector];
	[self.delegate wheelDidChangeSectorNumber:self.currentSector andBrightness:self.brightness];
}

#pragma mark - Slider Delegate

- (void)sliderDidChangeBrightness:(CGFloat)brightness
{
	self.brightness = brightness;
	[self.delegate wheelDidChangeSectorNumber:self.currentSector andBrightness:self.brightness];
	
	[self setPanelShadow:brightness];
}

- (void)setPanelShadow:(CGFloat)percent
{
	
	UIBezierPath *brightnessCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																 radius:146
															 startAngle:0.0
															   endAngle:360.0
															  clockwise:YES];
	[self.sectorBrightnessLayer removeFromSuperlayer];
	self.sectorBrightnessLayer.shadowPath = brightnessCircle.CGPath;
	self.sectorBrightnessLayer.shadowOpacity = 0.3 * (1 - percent);//typical 0.01
	self.sectorBrightnessLayer.shadowRadius = 3;
	self.sectorBrightnessLayer.shadowOffset = CGSizeZero;
	[self.layer insertSublayer:self.sectorBrightnessLayer atIndex:1];
	
}

#pragma mark -
-(void)switchOn
{
	UIBezierPath *innerCenterCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																	 radius:90
																 startAngle:0.0
																   endAngle:360.0
																  clockwise:YES];
	[self.centerShadowLayer removeFromSuperlayer];
	self.centerShadowLayer.shadowPath = innerCenterCircle.CGPath;
	self.centerShadowLayer.shadowOpacity = 0.f ; // typical 3 * brightness
	self.centerShadowLayer.shadowRadius = 10;
	self.centerShadowLayer.shadowOffset = CGSizeZero;
	[self.layer insertSublayer:self.centerShadowLayer atIndex:1];
	[self setPanelShadow:self.brightness];
}
- (void)switchOff
{
	UIBezierPath *innerCenterCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
																	 radius:90
																 startAngle:0.0
																   endAngle:360.0
																  clockwise:YES];
	[self.centerShadowLayer removeFromSuperlayer];
	self.centerShadowLayer.shadowPath = innerCenterCircle.CGPath;
	self.centerShadowLayer.shadowOpacity = 0.9; // typical 3 * brightness
	self.centerShadowLayer.shadowRadius = 30;
	self.centerShadowLayer.shadowOffset = CGSizeZero;
	[self.layer insertSublayer:self.centerShadowLayer atIndex:1];
	[self setPanelShadow:0.f];

}

- (float)calculateDistanceFromCenter:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrtf(dx*dx + dy*dy);
}

- (UIImageView *)getSectorByValue:(int)value
{
	UIImageView *imageView;
	NSArray *views = [self.container subviews];
	for (UIImageView *im in views) {
		if (im.tag == value) {
			imageView = im;
			break;
		}
	}
	return imageView;
}

- (void)buildSectorOdd
{
	CGFloat fanWidth = M_PI * 2 / self.numberOfSections;
	CGFloat mid = M_PI / 2;
	
	for (int i = 0; i < self.numberOfSections; i++) {
		JHSector *sector = [[JHSector alloc] init];
		sector.midValue = mid;
		sector.minValue = mid - (fanWidth/2);
		sector.maxValue = mid + (fanWidth/2);
		sector.sector = i;
		mid -= fanWidth;
		if (sector.minValue < -M_PI) {
			mid = -mid;
			mid -= fanWidth;
		}
		
		[self.sectors addObject:sector];
		//NSLog(@"sector is %@", sector);
	}
}

- (void)buildSectorEven
{
	CGFloat fanWidth = M_PI * 2 / self.numberOfSections;
	CGFloat mid = M_PI / 2;
	
	for (int i = 0; i < self.numberOfSections; i++) {
		JHSector *sector = [[JHSector alloc] init];
		sector.midValue = mid;
		sector.minValue = mid - (fanWidth/2);
		sector.maxValue = mid + (fanWidth/2);
		sector.sector = i;
		if (sector.maxValue - fanWidth < -M_PI) {
			mid = M_PI + (mid + M_PI);
			sector.midValue = mid;
			sector.minValue = mid - (fanWidth/2);
			sector.maxValue = mid + (fanWidth/2);

		}
		mid -= fanWidth;
		//NSLog(@"sector mid       is %f", sector.midValue);
		//NSLog(@"sector max is %f", sector.maxValue);
		//NSLog(@"sector min is %f", sector.minValue);
		
		[self.sectors addObject:sector];

	}
	
}

@end

#pragma mark - Picker Wheel Sector View Class

@implementation JHPickerWheelSectorView

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
		self.sectorColor = color;
		self.backgroundColor = [UIColor clearColor];
		//[self setNeedsDisplay];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//NSLog(@"drawing a custom sector frame");
	UIBezierPath *aPath = [UIBezierPath bezierPath];
	
	[aPath moveToPoint:CGPointMake(0.0, 0.0)];
	[aPath addLineToPoint:CGPointMake(150, 26)];
	[aPath addLineToPoint:CGPointMake(0.0, 52)];
	
	aPath.lineWidth = 1;
	
	[aPath closePath];
	[self.sectorColor setFill];
	[aPath fillWithBlendMode:kCGBlendModeColor alpha:0.9];
	//[aPath fill];
	
	[[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1] setStroke];
	[aPath stroke];
	
	[self.layer setShadowPath:aPath.CGPath];
	[self.layer setShadowColor:self.sectorColor.CGColor];
	[self.layer setShadowRadius:8];
	[self.layer setShadowOpacity:0.3];
	[self.layer setShadowOffset:CGSizeZero];
	
	
}

@end


@implementation JHSector


@end

//
//  JHColorViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//


#import "JHColorViewController.h"
#import "JHNotificationName.h"
#import "Color+Create.h"
#import "BTDiscovery.h"

@interface JHColorViewController ()

@end

@implementation JHColorViewController

-(void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserverForName:MainDatabaseAvailabilityNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *note) {
													  self.context = note.userInfo[MainDatabaseAvailabilityContext];
													  [self setComponents];
												  }];
}

- (void)setComponents
{
	self.view.backgroundColor = [UIColor colorWithRed:247/255.f green:249/255.f blue:255/255.f alpha:1];
	self.sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 30)];
	self.sectorLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.sectorLabel];
	
	Color *savedColor = [self restoreSavedColor];
	
	
	
	self.slider = [[JHBrightnessSlider alloc] initWithFrame:CGRectMake(0, 0, 300, 80)
											  andBrightness:savedColor.brightness];
	
	self.slider.filledColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
	self.slider.unfilledColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
	self.slider.center = CGPointMake(160, 440);
	[self.view addSubview:self.slider];
	
	self.wheel = [[JHFlowWheel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)
										andDelegate:self
									   withSections:72
										   andColor:savedColor];
	self.selectedColor = [self colorWithHue:savedColor.hue andBrightness:savedColor.brightness];
	
	self.wheel.center = CGPointMake(160, 230);
	self.slider.delegate = self.wheel;
	[self.view addSubview:self.wheel];
	
	self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	self.switchButton.center = CGPointMake(160, 230);
	self.switchButton.backgroundColor = [UIColor clearColor];
	self.switchButton.tag = 0;
	[self.switchButton addTarget:self action:@selector(isSwitchPushed) forControlEvents:UIControlEventTouchUpInside];
	
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.switchButton.frame];
	bg.image = [UIImage imageNamed:@"switchOff.png"];
	bg.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
	[self.switchButton addSubview:bg];
	[self.view addSubview:self.switchButton];
	
	[self.wheel switchOff];

	
}

- (void)isSwitchPushed
{
	if (!self.isSwitchOn) {
		self.isSwitchOn = YES;
		
		[self.delegate didPushTheSwitchButton];
	} else {
		self.isSwitchOn = NO;
		
		[self.delegate didPushTheSwitchButton];
	}
}
- (void)updateSwitchBgImage
{
	if (self.isSwitchOn) {
		[[self.switchButton subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		UIImageView *bg = [[UIImageView alloc] initWithFrame:self.switchButton.frame];
		bg.image = [UIImage imageNamed:@"switchOn.png"];
		bg.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
		[self.switchButton addSubview:bg];
	} else {
		[[self.switchButton subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		UIImageView *bg = [[UIImageView alloc] initWithFrame:self.switchButton.frame];
		bg.image = [UIImage imageNamed:@"switchOff.png"];
		bg.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
		[self.switchButton addSubview:bg];
	}
}

- (Color *)restoreSavedColor
{
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Color"];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hue"
															  ascending:YES
															   selector:nil]];
	NSError *error;
	NSArray *array = [self.context executeFetchRequest:request
												 error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
	Color *savedColor = nil;
	if ([array count] == 1) {
		savedColor = [array objectAtIndex:0];
	} else {
		if ([array count] > 1) {
			NSLog(@"WARNING!! Multiple color profile saved in database!!");
			for (Color *color in array) {
				[self.context deleteObject:color];
			}
		}
		savedColor = [Color createNewColorProfileInManagedObjectContext:self.context];
	}
	return savedColor;
}

- (UIColor *)colorWithHue:(CGFloat)hue andBrightness:(CGFloat)brightness
{
	UIColor *color = [UIColor colorWithHue:hue
								saturation:1
								brightness:brightness * 0.5 + 0.5
									 alpha:1];
	return color;
	
}

- (void)wheelDidChangeHUE:(CGFloat)hue andBrightness:(CGFloat)brightness
{
	Color *savedColor = [self restoreSavedColor];
	savedColor.hue = hue;
	savedColor.brightness = brightness;
	self.selectedColor = [self colorWithHue:hue andBrightness:brightness];
	
	UIColor *color = [self colorWithHue:hue andBrightness:brightness];
	[self updateNewColor:color andBrightness:brightness];
	
}

- (void)updateNewColor:(UIColor *)color andBrightness:(CGFloat)brightness
{
	CGFloat red, green, blue;
	[color getRed:&red green:&green blue:&blue alpha:NULL];

	int redInt = red * 255;
	int greenInt = green * 255;
	int blueInt = blue * 255;
	int whiteInt = brightness * 255;
	NSLog(@"Colors are about to write: R%i, G%i, B%i, W%i", redInt, greenInt, blueInt, whiteInt);
	
	for (JHLightService *service in [[BTDiscovery sharedInstance] selectedServices]) {
		[service writeRedValue:redInt];
		[service writeGreenValue:greenInt];
		[service writeBlueValue:blueInt];
		[service writeWhiteValue:whiteInt];
	}
}


- (IBAction)MoveToShowLeftPanel:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
		case 0:
		{
			[self.delegate movePanelToOriginalPosition];
			break;
		}
		case 1:
		{
			[self.delegate movePanelRight];
			break;
		}
		default:
			break;
	}
}
- (IBAction)MoveToShowRightPanel:(id)sender
{
	UIButton *button = sender;
	switch (button.tag) {
		case 0:
		{
			[self.delegate movePanelToOriginalPosition];
			break;
		}
		case 1:
		{
			[self.delegate movePanelLeft];
			break;
		}
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

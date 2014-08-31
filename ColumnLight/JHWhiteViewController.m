//
//  JHWhiteViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHWhiteViewController.h"
#import "JHNotificationName.h"
#import "White+Create.h"
#import "BTDiscovery.h"

@interface JHWhiteViewController ()

@end

@implementation JHWhiteViewController

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserverForName:MainDatabaseAvailabilityNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *note) {
													  self.context = note.userInfo[MainDatabaseAvailabilityContext];
													  [self setComponents];
												  }];
}

- (void)viewDidLoad
{
	UIImage *bgPattern = [UIImage imageNamed:@"bgPattern.png"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:bgPattern];
	
	self.leftButton.backgroundColor = [UIColor clearColor];
	self.rightButton.backgroundColor = [UIColor clearColor];
	
	[self.leftButton setBackgroundImage:[UIImage imageNamed:@"leftButtonIcon.png"] forState:UIControlStateNormal];
	[self.rightButton setBackgroundImage:[UIImage imageNamed:@"rightButtonIcon.png"] forState:UIControlStateNormal];
	/*
	 UIImageView *leftButtonIcon = [[UIImageView alloc] initWithFrame:self.leftButton.frame];
	 leftButtonIcon.image = [UIImage imageNamed:@"leftButtonIcon.png"];
	 leftButtonIcon.center = CGPointMake(self.leftButton.frame.size.width/2, self.leftButton.frame.size.height/2);
	 [self.leftButton addSubview:leftButtonIcon];
	 
	 UIImageView *rightButtonIcon = [[UIImageView alloc] initWithFrame:self.rightButton.frame];
	 rightButtonIcon.image = [UIImage imageNamed:@"rightButtonIcon.png"];
	 rightButtonIcon.center = CGPointMake(self.rightButton.frame.size.width/2, self.rightButton.frame.size.height/2);
	 [self.rightButton addSubview:rightButtonIcon];
	 */
	
}

- (void)setComponents
{
	//self.view.backgroundColor = [UIColor colorWithRed:247/255.f green:249/255.f blue:255/255.f alpha:1];
	
	self.sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 30)];
	self.sectorLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.sectorLabel];
	
	White *savedWhite = [self restoreSavedColor];
	
	self.slider = [[JHBrightnessSlider alloc] initWithFrame:CGRectMake(0, 0, 300, 80)
											  andBrightness:savedWhite.brightness];
	
	self.slider.filledColor = [UIColor colorWithRed:247/255.f green:189/255.f blue:115/255.f alpha:1];
	self.slider.unfilledColor = [UIColor colorWithRed:177/255.f green:177/255.f blue:177/255.f alpha:1];
	self.slider.center = CGPointMake(160, 440);
	
	
	[self.view addSubview:self.slider];
	
	self.wheel = [[JHWhitePickerWheel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)
											   andDelegate:self
											  withSections:18
												  andWhite:savedWhite];
	self.selectedColor = [self colorWithSectorNumber:savedWhite.sectorNumber andBrightness:savedWhite.brightness];
	
	self.slider.delegate = self.wheel;
	self.wheel.center = CGPointMake(160, 230);
	[self.view addSubview:self.wheel];
	
	self.switchButton = [[JHRoundButton alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
	self.switchButton.center = CGPointMake(160, 230);
	self.switchButton.backgroundColor = [UIColor clearColor];
	self.switchButton.tag = 0;
	[self.switchButton addTarget:self action:@selector(switchIsPushed) forControlEvents:UIControlEventTouchUpInside];

	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.switchButton.frame];
	bg.image = [UIImage imageNamed:@"switchOff.png"];
	bg.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
	[self.switchButton addSubview:bg];
	[self.view addSubview:self.switchButton];
	
	[self.wheel switchOff];
	
}

- (void)switchIsPushed
{
	if (!self.isSwitchOn) {
		self.isSwitchOn= YES;

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
- (White *)restoreSavedColor
{
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"White"];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sectorNumber"
															  ascending:YES
															   selector:nil]];
	NSError *error;
	NSArray *array = [self.context executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
	White *savedWhite = nil;
	if ([array count] == 1) {
		savedWhite = [array objectAtIndex:0];
	} else  {
		if ([array count] > 1) {
			NSLog(@"WARNING !! Multiple white profile saved in database!!");
			for (White *white in array) {
				[self.context deleteObject:white];
			}
		}
		savedWhite = [White createNewWhiteProfileInManagedObjectContext:self.context];
	}
	return savedWhite;
}

- (UIColor *)colorWithSectorNumber:(NSUInteger)sectorNumber andBrightness:(CGFloat)brightness
{
	UIColor *color = [self.wheel.colors objectAtIndex:sectorNumber];

	CGFloat hue, sat, bright, alpha;
	[color getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
	UIColor *colorWithBrightness = [UIColor colorWithHue:hue
											  saturation:sat
											  brightness:brightness * 0.5 + 0.5
												   alpha:alpha];
	
	return colorWithBrightness;
	
}

#pragma mark - JHWheel Delegate
- (void)wheelDidChangeSectorNumber:(int)sectorNumber andBrightness:(CGFloat)brightness
{
	self.sectorLabel.text = [NSString stringWithFormat:@"%i", sectorNumber];
	
	White *savedWhite = [self restoreSavedColor];
	
	savedWhite.brightness = brightness;
	savedWhite.sectorNumber = sectorNumber;
	self.selectedColor = [self colorWithSectorNumber:savedWhite.sectorNumber andBrightness:savedWhite.brightness];
	UIColor *color = [self.wheel.colors objectAtIndex:sectorNumber];
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
	
	for (JHLightService *service in [[BTDiscovery sharedInstance] connectedServices]) {
		[service writeColorValueWithRed:redInt green:greenInt blue:blueInt white:whiteInt];
	}
}


#pragma mark - IBActions -
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

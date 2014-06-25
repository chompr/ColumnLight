//
//  JHMainViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHMainViewController.h"
#import "JHNotificationName.h"

#import "JHColorViewController.h"
#import "JHWhiteViewController.h"
#import "JHTImerViewController.h"
#import "JHLeftPanelViewController.h"
#import "JHRightPanelViewController.h"

#import "BTDiscovery.h"
#import "JHLightService.h"

#import "JHLoadingHUD.h"

static const CGFloat kJHAnimationDuration = 0.5;
static const CGFloat kJHOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kJHOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kJHClosingAnimationSpringDamping = 1.0f;
static const CGFloat kJHClosingAnimationSpringInitialVelocity = 0.5f;

#define COLOR_VC_TAG 1
#define WHITE_VC_TAG 2
#define TIMER_VC_TAG 3

#define LEFT_PANEL_TAG 4
#define RIGHT_PANEL_TAG 5


#define CORNER_RADIUS 4
#define PANEL_WIDTH 60
//#define SLIDE_TIMING .30

@interface JHMainViewController () <JHColorViewControllerDelegate, JHWhiteViewControllerDelegate, JHTimerViewControllerDelegate, UIGestureRecognizerDelegate, JHLeftPanelViewDelegate>

@property (nonatomic, strong) JHColorViewController *colorVC;
@property (nonatomic, strong) JHWhiteViewController *whiteVC;
@property (nonatomic, strong) JHTImerViewController *timerVC;

@property (nonatomic, strong) JHLeftPanelViewController *leftPanelVC;
@property (nonatomic, strong) JHRightPanelViewController *rightPanelVC;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, assign) BOOL isShowingLeftPanel;
@property (nonatomic, assign) BOOL isShowingRightPanel;
@property (nonatomic, assign) BOOL isShowingMainPanel;

@property (nonatomic, assign) BOOL isSwitchOn;

//@property (nonatomic, strong) NSMutableArray *connectedServices;
//@property (nonatomic, strong) NSMutableArray *foundPeripherals;

@property (nonatomic, strong) JHLoadingHUD *loadingHUD;

@end

@implementation JHMainViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
	[self createManagedDocument];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)createManagedDocument
{
	NSString *documentName = @"JHColumnLightDocument";
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
													 inDomains:NSUserDomainMask] lastObject];
	
	NSURL *url  = [documentsDirectory URLByAppendingPathComponent:documentName];
	self.document = [[UIManagedDocument alloc] initWithFileURL:url];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
		
		[self.document openWithCompletionHandler:^(BOOL success) {
			if (success) {
				[self documentIsReady];
			} else {
				NSLog(@"Couldn't open document at %@", url);
			}
		}];
	} else {
		[self.document saveToURL:url
				forSaveOperation:UIDocumentSaveForCreating
			   completionHandler:^(BOOL success) {
				   if (success) {
					   [self documentIsReady];
				   } else {
					   NSLog(@"Couldn't open document at %@", url);
				   }
			   }];
	}}

- (void)documentIsReady
{
	if (self.document.documentState == UIDocumentStateNormal) {
		self.context = self.document.managedObjectContext;
		[self setupView];
		[self notifyContext];

	}
}
- (void)notifyContext
{
	NSDictionary *userInfo = self.context ? @{MainDatabaseAvailabilityContext : self.context} : nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:MainDatabaseAvailabilityNotification
														object:self
													  userInfo:userInfo];
	
	NSLog(@"notifying managedObjectContext");
}
- (void)setupView
{
	
	//******************************* Center ViewControllers **************************************
	self.MainTBC = [[UITabBarController alloc] init];
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.colorVC = [storyBoard instantiateViewControllerWithIdentifier:@"ColorViewController"];
	self.whiteVC = [storyBoard instantiateViewControllerWithIdentifier:@"WhiteViewController"];
	self.timerVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerViewController"];
	// add tabbar item image later here;
	self.colorVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Color" image:nil tag:1];
	self.whiteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"White" image:nil tag:2];
	self.timerVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Alarm" image:nil tag:3];
	
	self.MainTBC.tabBar.barTintColor = [UIColor blackColor];
	self.colorVC.view.tag = COLOR_VC_TAG;
	self.colorVC.delegate = self;
	
	self.whiteVC.view.tag = WHITE_VC_TAG;
	self.whiteVC.delegate = self;

	
	self.timerVC.view.tag = TIMER_VC_TAG;
	self.timerVC.delegate = self;
	
	//[self.colorVC.view.layer setCornerRadius:CORNER_RADIUS];
	//[self.whiteVC.view.layer setCornerRadius:CORNER_RADIUS];
	//[self.timerVC.view.layer setCornerRadius:CORNER_RADIUS];
	
	self.MainTBC.viewControllers = [NSArray arrayWithObjects:self.colorVC,self.whiteVC,self.timerVC, nil];
	[self addChildViewController:self.MainTBC];
	[self.MainTBC didMoveToParentViewController:self];
	
	[self.view addSubview:self.MainTBC.view];
	self.MainTBC.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
	
	//******************************* Left ViewControllers **************************************
	self.leftPanelVC = [storyBoard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
	self.leftPanelVC.view.tag = LEFT_PANEL_TAG;
	
	// also should set leftPanelView delegate here
	[self addChildViewController:self.leftPanelVC];
	[self.leftPanelVC didMoveToParentViewController:self];
	self.leftPanelVC.delegate = self;
	self.leftPanelVC.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);

	
	//******************************* Right ViewControllers **************************************
	self.rightPanelVC = [storyBoard instantiateViewControllerWithIdentifier:@"RightPanelViewController"];
	self.rightPanelVC.view.tag = RIGHT_PANEL_TAG;
	
	self.rightPanelVC.context = self.context;
	NSLog(@"selected tab %lu", (unsigned long)self.MainTBC.selectedIndex);
	[self addChildViewController:self.rightPanelVC];
	[self.rightPanelVC didMoveToParentViewController:self];
	self.rightPanelVC.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
	
	self.isSwitchOn = NO;
	self.colorVC.isSwitchOn = NO;
	self.whiteVC.isSwitchOn = NO;
	
	[self switchComponentOff];
	
	[self setupGestureRecognizers];

	
}

- (void)setupGestureRecognizers
{
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																		action:@selector(tapGestureRecognized:)];
}
- (void)addClosingGestureRecognizers
{
	if (self.MainTBC.selectedIndex == 0) {
		[self.colorVC.view addGestureRecognizer:self.tapGestureRecognizer];
	} else if (self.MainTBC.selectedIndex == 1) {
		[self.whiteVC.view addGestureRecognizer:self.tapGestureRecognizer];
	}
}
- (void)removeClosingGestureRecognizers
{
	if (self.MainTBC.selectedIndex == 0) {
		[self.colorVC.view removeGestureRecognizer:self.tapGestureRecognizer];
	} else if (self.MainTBC.selectedIndex == 1) {
		[self.whiteVC.view removeGestureRecognizer:self.tapGestureRecognizer];
	}
}
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
	NSLog(@"recognized");
	
	if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[self movePanelToOriginalPosition];
	}
}


- (UIView *)getLeftPanelView
{
	/*
	if (!self.leftPanelVC) {
		
		UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		self.leftPanelVC = [storyBoard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
		self.leftPanelVC.view.tag = LEFT_PANEL_TAG;
		
		// also should set leftPanelView delegate here
		[self addChildViewController:self.leftPanelVC];
		[self.leftPanelVC didMoveToParentViewController:self];
		self.leftPanelVC.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
	}*/
	
	[self.view addSubview:self.leftPanelVC.view];
	self.leftPanelVC.isOnTheMainScreen = YES;
	self.isShowingLeftPanel = YES;
	[self showViewWithShadow:YES withOffset:-2];
	// ? mark here
	UIView *view = self.leftPanelVC.view;
	return view;
}

- (UIView *)getRightPanelView
{
	/*
	if (!self.rightPanelVC) {
		
		UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		self.rightPanelVC = [storyBoard instantiateViewControllerWithIdentifier:@"RightPanelViewController"];
		self.rightPanelVC.view.tag = RIGHT_PANEL_TAG;
		
		self.rightPanelVC.context = self.context;
		NSLog(@"selected tab %lu", (unsigned long)self.MainTBC.selectedIndex);
		[self addChildViewController:self.rightPanelVC];
		
		[self.rightPanelVC didMoveToParentViewController:self];
		self.rightPanelVC.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
	}
	*/
	if (self.MainTBC.selectedIndex == 0) {
		self.rightPanelVC.selectedColor = self.colorVC.selectedColor;
	} else if (self.MainTBC.selectedIndex == 1) {
		self.rightPanelVC.selectedColor = self.whiteVC.selectedColor;
	}
	
	//CGFloat red, green, blue, alpha;
	
	//[self.rightPanelVC.selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
	
	//NSLog(@" R: %f | G: %f | B: %f | A: %f", red, green, blue, alpha);
	 
	//also should set rightPanelView delegate here;

	
	[self.view addSubview:self.rightPanelVC.view];
	self.rightPanelVC.isOnTheMainScreen = YES;
	self.isShowingRightPanel = YES;
	[self showViewWithShadow:YES withOffset:-2];
	// ? mark here
	UIView *view = self.rightPanelVC.view;
	return view;
}

- (void)resetMainView
{
	if (self.leftPanelVC != nil) {
		[self.leftPanelVC.view removeFromSuperview];
		//self.leftPanelVC = nil;
		self.colorVC.leftButton.tag = 1;
		self.whiteVC.leftButton.tag = 1;
		self.timerVC.leftButton.tag = 1;
		self.isShowingLeftPanel = NO;
	}
	if (self.rightPanelVC != nil) {
		[self.rightPanelVC.view removeFromSuperview];
		//self.rightPanelVC = nil;
		self.colorVC.rightButton.tag = 1;
		self.whiteVC.rightButton.tag = 1;
		self.timerVC.rightButton.tag = 1;
		self.isShowingRightPanel = NO;
	}
	[self showViewWithShadow:NO withOffset:0];
}

- (void)showViewWithShadow:(BOOL)value withOffset:(double)offset
{
	if (value) {
		//[self.colorVC.view.layer setCornerRadius:CORNER_RADIUS];
		//[self.whiteVC.view.layer setCornerRadius:CORNER_RADIUS];
		//[self.timerVC.view.layer setCornerRadius:CORNER_RADIUS];
		UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.MainTBC.view.bounds];
		
		[self.MainTBC.view.layer setShadowColor:[UIColor blackColor].CGColor];
		[self.MainTBC.view.layer setShadowOpacity:0.7f];
		self.MainTBC.view.layer.shadowPath = shadowPath.CGPath;
		//[self.MainTBC.view.layer setShadowOffset:CGSizeMake(0, offset)];
		
	} else {
		[self.MainTBC.view.layer setShadowOpacity:0.0f];
		//[self.MainTBC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
	}
}

#pragma mark - LeftPanelVC Delegtate -
- (void)leftPanelVCDidLaunchScanning
{
	[[JHLoadingHUD sharedInstance] showLoadingHUDInView:self.view];
}
- (void)leftPanelVCDidUpadteSelectedServices:(NSMutableArray *)selectedServices
{
	// update UI state here;
	if (!selectedServices || [selectedServices count] == 0) {
		NSLog(@"[JHMainVC] No valid selectedService passed or count is 0.");
		self.isSwitchOn = NO;
		self.colorVC.isSwitchOn = self.isSwitchOn;
		self.whiteVC.isSwitchOn = self.isSwitchOn;
		if (self.isSwitchOn) {
			[self switchComponentOn];
		} else {
			[self switchComponentOff];
		}
		return;
	}
	JHLightService *firstService = [selectedServices objectAtIndex:0];
	BOOL state = firstService.isSwitchOn;
	NSLog(@"[JHMainVC] isSwitchOn ? %i", state);
	
	for (JHLightService *service in selectedServices) {
		if (service.isSwitchOn != state) {
			NSLog(@"[JHMainVC] Detect different device state in selectedService");
			return;
		}
	}
	self.isSwitchOn = state;
	self.colorVC.isSwitchOn = self.isSwitchOn;
	self.whiteVC.isSwitchOn = self.isSwitchOn;
	if (self.isSwitchOn) {
		[self switchComponentOn];
	} else {
		[self switchComponentOff];
	}
}
/*
- (void)lightServiceDidSwitchOnPower:(JHLightService *)service
{
	self.isSwitchOn = YES;
	self.colorVC.isSwitchOn = self.isSwitchOn;
	self.whiteVC.isSwitchOn = self.isSwitchOn;
	if (self.isSwitchOn) {
		[self switchComponentOn];
	} else {
		[self switchComponentOff];
	}
}
- (void)lightServiceDidSwitchOffPower:(JHLightService *)service
{
	self.isSwitchOn = NO;
	self.colorVC.isSwitchOn = self.isSwitchOn;
	self.whiteVC.isSwitchOn = self.isSwitchOn;
	if (self.isSwitchOn) {
		[self switchComponentOn];
	} else {
		[self switchComponentOff];
	}
}
*/
- (void)switchComponentOn
{
	self.colorVC.wheel.userInteractionEnabled = YES;
	self.colorVC.slider.userInteractionEnabled = YES;
	[self.colorVC.wheel switchOn];
	[self.colorVC updateSwitchBgImage];
	
	self.whiteVC.wheel.userInteractionEnabled = YES;
	self.whiteVC.slider.userInteractionEnabled = YES;
	[self.whiteVC.wheel switchOn];
	[self.whiteVC updateSwitchBgImage];
}

- (void)switchComponentOff
{
	self.colorVC.wheel.userInteractionEnabled = NO;
	self.colorVC.slider.userInteractionEnabled = NO;
	[self.colorVC.wheel switchOff];
	[self.colorVC updateSwitchBgImage];
	
	self.whiteVC.wheel.userInteractionEnabled = NO;
	self.whiteVC.slider.userInteractionEnabled = NO;
	[self.whiteVC.wheel switchOff];
	[self.whiteVC updateSwitchBgImage];
}

#pragma mark - Center Controllers Delegate Methods -

- (void)didPushTheSwitchButton
{
	NSUInteger index = self.MainTBC.selectedIndex;
	if (index == 0) {
		self.isSwitchOn = self.colorVC.isSwitchOn;
		self.whiteVC.isSwitchOn = self.colorVC.isSwitchOn;
	} else if (index == 1) {
		self.isSwitchOn = self.whiteVC.isSwitchOn;
		self.colorVC.isSwitchOn = self.whiteVC.isSwitchOn;
	} else if (index == 2) {
#warning add timer vc support later write power on/off state from here
		// for timer VC
	}
	if (self.isSwitchOn) {
		[self switchComponentOn];
	} else {
		[self switchComponentOff];
	}
	
}
- (void)movePanelLeft
{
	[self addClosingGestureRecognizers];
	UIView *childView = [self getRightPanelView]; // here get the view that is being prepared by the getRightView
	[self.view sendSubviewToBack:childView];
	[UIView animateWithDuration:kJHAnimationDuration
						  delay:0
	     usingSpringWithDamping:kJHOpeningAnimationSpringDamping
		  initialSpringVelocity:kJHOpeningAnimationSpringInitialVelocity
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.MainTBC.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
					 }completion:^(BOOL finished) {
						 if (finished) {
							 self.colorVC.rightButton.tag = 0; // 0 means the panel is showing. 1 means the panel isn't shown
							 self.whiteVC.rightButton.tag = 0;
							 self.timerVC.rightButton.tag = 0;
							 self.MainTBC.tabBar.userInteractionEnabled = NO;
							 self.colorVC.wheel.userInteractionEnabled = NO;
							 self.colorVC.slider.userInteractionEnabled = NO;
							 self.whiteVC.wheel.userInteractionEnabled = NO;
							 self.whiteVC.slider.userInteractionEnabled = NO;
						 }
					 }];
}
- (void)movePanelRight
{
	[self addClosingGestureRecognizers];
	UIView *childView = [self getLeftPanelView];
	[self.view sendSubviewToBack:childView];
	[UIView animateWithDuration:kJHAnimationDuration
						  delay:0
		 usingSpringWithDamping:kJHOpeningAnimationSpringDamping
		  initialSpringVelocity:kJHOpeningAnimationSpringInitialVelocity
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.MainTBC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
						 
					 }
					 completion:^(BOOL finished) {
						 self.colorVC.leftButton.tag = 0; // it's showing now
						 self.whiteVC.leftButton.tag = 0;
						 self.timerVC.leftButton.tag = 0;
						 self.MainTBC.tabBar.userInteractionEnabled = NO;
						 self.colorVC.wheel.userInteractionEnabled = NO;
						 self.colorVC.slider.userInteractionEnabled = NO;
						 self.whiteVC.wheel.userInteractionEnabled = NO;
						 self.whiteVC.slider.userInteractionEnabled = NO;
					 }];
}
- (void)movePanelToOriginalPosition
{
	[self removeClosingGestureRecognizers];
	[UIView animateWithDuration:kJHAnimationDuration
						  delay:0
		 usingSpringWithDamping:kJHClosingAnimationSpringDamping
		  initialSpringVelocity:kJHClosingAnimationSpringInitialVelocity
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.MainTBC.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
						 
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 self.MainTBC.tabBar.userInteractionEnabled = YES;
							 if (self.isSwitchOn) {
								 self.colorVC.wheel.userInteractionEnabled = YES;
								 self.colorVC.slider.userInteractionEnabled = YES;
								 self.whiteVC.wheel.userInteractionEnabled = YES;
								 self.whiteVC.slider.userInteractionEnabled = YES;
							 } else {
								 self.colorVC.wheel.userInteractionEnabled = NO;
								 self.colorVC.slider.userInteractionEnabled = NO;
								 self.whiteVC.wheel.userInteractionEnabled = NO;
								 self.whiteVC.slider.userInteractionEnabled = NO;
							 }

							 [self resetMainView];
						 }
					 }];
}
- (void)movePanelToOriginalPositionWithBounce
{
	[self removeClosingGestureRecognizers];
	CGRect f = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
	f.origin.x = self.view.bounds.size.width - 20; //320 - 30 = 290
	
	[UIView animateWithDuration:kJHAnimationDuration / 2
					 animations:^{
						 self.MainTBC.view.frame = f;
					 }
					 completion:^(BOOL finished) {
						 [self movePanelToOriginalPosition];
					 }];
}

#pragma mark - System Generated Code -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






















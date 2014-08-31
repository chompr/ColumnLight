//
//  JHTImerViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHTimerViewController.h"
#import "JHSetNewTimerViewController.h"

@interface JHTimerViewController ()


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *meridianLabel;
@property (weak, nonatomic) IBOutlet UIView *timeDisplayBar;


@end

@implementation JHTimerViewController

- (void)viewDidLoad
{
	//JHTimerWheel *wheel = [[JHTimerWheel alloc] initWithFrame:CGRectMake(0, 0, 310, 310)];
	//wheel.center = CGPointMake(160, 230);
	//[self.view addSubview:wheel];
	
	[super viewDidLoad];
	self.leftButton.backgroundColor = [UIColor clearColor];
	self.rightButton.backgroundColor = [UIColor clearColor];
	
	[self.addButton setBackgroundColor:[UIColor clearColor]];
	[self.timeDisplayBar setBackgroundColor:[UIColor lightGrayColor]];
	
	[self.leftButton setBackgroundImage:[UIImage imageNamed:@"leftButtonIcon.png"] forState:UIControlStateNormal];
	[self.rightButton setBackgroundImage:[UIImage imageNamed:@"rightButtonIcon.png"] forState:UIControlStateNormal];
	
	self.alarmTypeSC = [[JHSegmentedControl alloc] initWithFrame:CGRectMake(10, 100, 300, 37)];
	[self.view addSubview:self.alarmTypeSC];
	
	
}

- (void)loadSavedWakeAlarmSetting
{
	NSArray *wakeAlarmSettingArr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"wakeAlarmSetting"];
	
	if (![wakeAlarmSettingArr isKindOfClass:[NSArray class]]) {
		NSLog(@"[TimerVC] No stored wake alarmsSetting to load");
		self.wakeAlarmSetting = [[JHAlarmSetting alloc] init];
		return;
	}
	
	if ([wakeAlarmSettingArr count] == 1) {
		if ([[wakeAlarmSettingArr objectAtIndex:0] isKindOfClass:[JHAlarmSetting class]]) {
			self.wakeAlarmSetting = [wakeAlarmSettingArr objectAtIndex:0];
		}
	}
}


- (void)updateSavedWakeAlarmSetting
{
	
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//prepare for some input info
	if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
		JHSetNewTimerViewController *sntvc = (JHSetNewTimerViewController *)nvc.topViewController;
		
		if (self.alarmTypeSC.selectedIndex == 1) {
			NSLog(@"selectedIndex is 1");
			sntvc.alarmSetting = self.wakeAlarmSetting;
		} else if (self.alarmTypeSC.selectedIndex == 0) {
			NSLog(@"selectedIndex is 0");
			sntvc.alarmSetting = self.sleepAlarmSetting;
		}
		
	}
	
}

#pragma mark - Setter & Getters -

- (JHAlarmSetting *)wakeAlarmSetting
{
	if (!_wakeAlarmSetting) _wakeAlarmSetting = [[JHAlarmSetting alloc] init];
	_wakeAlarmSetting.alarmType = 1;
	return _wakeAlarmSetting;
}

- (JHAlarmSetting *)sleepAlarmSetting
{
	if (!_sleepAlarmSetting) _sleepAlarmSetting = [[JHAlarmSetting alloc] init];
	_sleepAlarmSetting.alarmType = 0;
	return _sleepAlarmSetting;
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

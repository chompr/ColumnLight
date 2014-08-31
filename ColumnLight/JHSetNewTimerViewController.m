//
//  JHAddNewTimerViewController.m
//  ColumnLight
//
//  Created by Alan on 8/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHSetNewTimerViewController.h"
#import "JHAlarmSettingRepeatVC.h"

#import "JHAlarmBrightnessSettingView.h"
#import "JHAlarmTimeAdvanceSettingView.h"


#define TIME_IN_ADVANCE_SETTING_ROW 0
#define COLOR_SETTING_ROW 1
#define REPEAT_SETTING_ROW 2
#define BRIGHTNESS_SETTING_ROW 3

@interface JHSetNewTimerViewController () <JHAlarmSettingRepeatDelegate>

@property (weak, nonatomic) IBOutlet UITableView *alarmSettingTableView;

@end

@implementation JHSetNewTimerViewController

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1];
	JHTimerPicker *timerPicker = [[JHTimerPicker alloc] initWithFrame:CGRectMake(0.0, 100, self.view.bounds.size.width, 200)];
	
	[timerPicker setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:timerPicker];
	
	[self.alarmSettingTableView setScrollEnabled:NO];
	self.alarmSettingTableView.dataSource = self;
	self.alarmSettingTableView.delegate = self;
}

#pragma mark - JHAlarmSettingRepeatDelegate -

- (void)repeatDidChangeValue:(char)value
{
	self.alarmSetting.repeat = value;
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.destinationViewController isKindOfClass:[JHAlarmSettingRepeatVC class]]) {
		JHAlarmSettingRepeatVC *asrvc = segue.destinationViewController;
		asrvc.repeat = self.alarmSetting.repeat;
		asrvc.delegate = self;
	}
}


#pragma mark - IBAction -

- (IBAction)cancel:(id)sender
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.alarmSettingTableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == COLOR_SETTING_ROW) {
		[self performSegueWithIdentifier:@"ColorSettingSegue" sender:nil];
	} else if (indexPath.row == REPEAT_SETTING_ROW) {
		[self performSegueWithIdentifier:@"RepeatSettingSegue" sender:nil];
	} else if (indexPath.row == BRIGHTNESS_SETTING_ROW) {
		JHAlarmBrightnessSettingView *absv = [[JHAlarmBrightnessSettingView alloc] initWithFrame:self.view.bounds];
		[self.parentViewController.view addSubview:absv];
		[absv showWhiteBoard];
	} else if (indexPath.row == TIME_IN_ADVANCE_SETTING_ROW) {
		JHAlarmTimeAdvanceSettingView *atasv = [[JHAlarmTimeAdvanceSettingView alloc] initWithFrame:self.view.bounds];
		[self.parentViewController.view addSubview:atasv];
		[atasv showWhiteBoard];
	}
}

#pragma mark - UITableView DataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"AlarmSettingCell";
	UITableViewCell *cell = [self.alarmSettingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	switch (indexPath.row) {
		case TIME_IN_ADVANCE_SETTING_ROW:
		{
			cell.textLabel.text = @"Time in Advance";
			//cell.detailTextLabel.text = @"time for lamp to lightup in davance";
			break;
		}
		case COLOR_SETTING_ROW:
		{
			cell.textLabel.text = @"Color";
			//cell.detailTextLabel.text = @"The color the lamp lights up";
			break;
		}
		case REPEAT_SETTING_ROW:
		{
			cell.textLabel.text = @"Repeat";
			break;
		}
		case BRIGHTNESS_SETTING_ROW:
		{
			cell.textLabel.text = @"Brightness";
			break;
		}
			
		default:
			break;
			
	}
	return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

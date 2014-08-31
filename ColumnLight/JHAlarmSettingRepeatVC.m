//
//  JHAlarmSettingRepeatVC.m
//  ColumnLight
//
//  Created by Alan on 8/23/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHAlarmSettingRepeatVC.h"

@interface JHAlarmSettingRepeatVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *weekTableView;

@end

@implementation JHAlarmSettingRepeatVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weekTableView.dataSource = self;
	self.weekTableView.delegate = self;
	self.weekTableView.allowsMultipleSelection = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.weekTableView dequeueReusableCellWithIdentifier:@"WeekCell"];
	
	if (self.repeat & (0b1 << indexPath.row)) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	switch (indexPath.row) {
		case 0:
		{
			cell.textLabel.text = @"Sunday";
			break;
		}
		case 1:
		{
			cell.textLabel.text = @"Monday";
			break;
		}
		case 2:
		{
			cell.textLabel.text = @"Tuesday";
			break;
		}
		case 3:
		{
			cell.textLabel.text = @"Wednesday";
			break;
		}
		case 4:
		{
			cell.textLabel.text = @"Thursday";
			break;
		}
		case 5:
		{
			cell.textLabel.text = @"Friday";
			break;
		}
		case 6:
		{
			cell.textLabel.text = @"Saturday";
			break;
		}
		default:
			break;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.repeat & (0b1 << indexPath.row)) {
		self.repeat &= ~(0b1 << indexPath.row);
		
	} else {
		self.repeat |= (0b1 << indexPath.row);
	}
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (self.repeat & (0b1 << indexPath.row)) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	[self.delegate repeatDidChangeValue:self.repeat];
}



@end

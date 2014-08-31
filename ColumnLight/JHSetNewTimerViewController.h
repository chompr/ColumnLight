//
//  JHAddNewTimerViewController.h
//  ColumnLight
//
//  Created by Alan on 8/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHTimerPicker.h"
#import "JHAlarmSetting.h"


@interface JHSetNewTimerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) JHAlarmSetting *alarmSetting;

@end

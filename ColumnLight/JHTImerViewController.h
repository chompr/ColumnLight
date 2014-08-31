//
//  JHTImerViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "JHSegmentedControl.h"
#import "JHAlarmSetting.h"

//#import "JHTimerWheel.h"

@protocol JHTimerViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;

@required
- (void)didPushTheSwitchButton;

@end

@interface JHTimerViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) id<JHTimerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, assign) BOOL debug;

@property (nonatomic, strong) JHAlarmSetting *sleepAlarmSetting;
@property (nonatomic, strong) JHAlarmSetting *wakeAlarmSetting;
@property (nonatomic, strong) JHSegmentedControl *alarmTypeSC;

@end

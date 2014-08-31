//
//  JHAlarmSettingRepeatVC.h
//  ColumnLight
//
//  Created by Alan on 8/23/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHAlarmSettingRepeatDelegate <NSObject>

@required
- (void)repeatDidChangeValue:(char)value;

@end

@interface JHAlarmSettingRepeatVC : UIViewController

@property (nonatomic, assign) unsigned char repeat;
@property (nonatomic, assign) id<JHAlarmSettingRepeatDelegate> delegate;

@end

//
//  JHAlarmSetting.h
//  ColumnLight
//
//  Created by Alan on 8/18/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAlarmSetting : NSObject


@property (nonatomic, assign) BOOL meridian;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) NSUInteger startPercent;
@property (nonatomic, assign) NSUInteger endPercent;
@property (nonatomic, assign) NSUInteger timeAdvance;

@property (nonatomic, assign) unsigned char repeat;
@property (nonatomic, assign) BOOL alarmType;
@property (nonatomic, assign) BOOL alarmStatus;
@property (nonatomic, strong) UIColor *alarmColor;

@end

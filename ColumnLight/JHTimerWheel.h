//
//  JHTimerWheel.h
//  ColumnLight
//
//  Created by Alan on 6/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTimerWheel : UIControl


@property (nonatomic, strong) UIColor *unfilledHourColor;
@property (nonatomic, strong) UIColor *unfilledMinColor;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger min;

@property (nonatomic, assign) BOOL isAM;
@property (nonatomic, assign) BOOL isSettingMin;
@property (nonatomic, assign) BOOL isSettingHour;

@property (nonatomic, assign) float currentAngleInHour;
@property (nonatomic, assign) float currentAngleInMin;

@property (nonatomic, assign) float percInMin;
@property (nonatomic, assign) float	percInHour;

@property (nonatomic, strong) NSMutableArray *sectors;

//@property CGAffineTransform startTransform;
@property (nonatomic, strong) UIView *hourLabel; // hour ball
@property (nonatomic, strong) UIView *minLabel; // min ball

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *amLabel;
@end

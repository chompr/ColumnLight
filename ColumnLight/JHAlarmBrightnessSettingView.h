//
//  JHAlarmBrightnessSettingView.h
//  ColumnLight
//
//  Created by Alan on 8/20/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHAlarmBrightnessSettingView : UIView

- (void)showWhiteBoard;
@end




@interface JHAlarmBrightnessSlider : UIControl

@property (nonatomic, assign) float currentMinValue;
@property (nonatomic, assign) float currentMaxValue;

@property (nonatomic, assign) double barOffset;

@property (nonatomic, strong) UIColor *unfilledColor;
@property (nonatomic, strong) UIColor *filledColor;

- (id)initWithFrame:(CGRect)frame andBrightness:(CGFloat)brightness;

@end



@interface JHPopupView : UIView

- (void)setTextColor:(UIColor *)color;
- (void)setString:(NSString *)string;
- (void)show;
- (void)hide;
@end
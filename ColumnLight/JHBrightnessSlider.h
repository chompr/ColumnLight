//
//  JHBrightnessSlider.h
//  ColumnLight
//
//  Created by Alan on 5/30/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHBrightnessSlidereDelegate <NSObject>

@required
- (void)sliderContinueChangingBrightness:(CGFloat)brightness;
- (void)sliderEndChangingBrightness:(CGFloat)brightness;

@end

@interface JHBrightnessSlider : UIControl

@property (nonatomic, assign) id<JHBrightnessSlidereDelegate> delegate;
@property (nonatomic, strong) UIColor *unfilledColor;
@property (nonatomic, strong) UIColor *filledColor;
@property (nonatomic, assign) float currentValue;
@property (nonatomic, assign) double barOffset;

- (id)initWithFrame:(CGRect)frame andBrightness:(CGFloat)brightness;

- (void)updateSliderCurrentValue:(float)currentValue;

@end

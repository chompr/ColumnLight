//
//  JHFlowWheel.h
//  ColumnLight
//
//  Created by Alan on 5/31/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBrightnessSlider.h"
#import "Color.h"

@protocol JHFlowWheelDelegate <NSObject>

@required
- (void)wheelDidChangeHUE:(CGFloat)hue andBrightness:(CGFloat)brightness;

@end


@interface JHFlowWheel : UIControl <JHBrightnessSlidereDelegate>

@property (nonatomic, assign) id<JHFlowWheelDelegate> delegate;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *sectors;


@property (nonatomic, assign) float brightness;
@property (nonatomic, assign) float currentAngleInHUE;
@property (nonatomic, assign) int numberOfSections;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate withSections:(int)numberOfSections andColor:(Color *)color;

- (void)switchOn;
- (void)switchOff;
@end



@interface JHFlowWheelSectorView : UIView

@property UIColor *sectorColor;

- (id)initWithFrame:(CGRect)frame;

@end
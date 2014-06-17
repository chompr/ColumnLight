//
//  JHColorWheel.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBrightnessSlider.h"
#import "White.h"


@protocol JHPickerWheelDelegate <NSObject>

@required
- (void)wheelDidChangeSectorNumber:(int)sectorNumber andBrightness:(CGFloat)brightness;

@end


@interface JHPickerWheel : UIControl <JHBrightnessSlidereDelegate>

@property (nonatomic, assign) id<JHPickerWheelDelegate> delegate;
@property (nonatomic, strong) UIView *container;


@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property (nonatomic, strong) NSArray *colors;

@property float brightness;
@property int currentSector;
@property int numberOfSections;


- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate withSections:(int)numberOfSections andWhite:(White *)white;
- (void)createColors;

- (void)switchOn;
- (void)switchOff;
@end


@interface JHPickerWheelSectorView : UIView

@property UIColor *sectorColor;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color;

@end

@class JHSector;

@interface JHSector : NSObject

@property float minValue;
@property float maxValue;
@property float midValue;
@property int sector;

@end

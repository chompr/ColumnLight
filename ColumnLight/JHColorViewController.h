//
//  JHColorViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFlowWheel.h"
#import "JHRoundButton.h"

@protocol JHColorViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;

@required
- (void)didPushTheSwitchButton;

@end

@interface JHColorViewController : UIViewController <JHFlowWheelDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, assign) id<JHColorViewControllerDelegate> delegate;

// UI Components
@property (nonatomic, strong) JHFlowWheel *wheel;
@property (nonatomic, strong) JHBrightnessSlider *slider;
@property (nonatomic, strong) JHRoundButton *switchButton;

@property (nonatomic, strong) UIColor *selectedColor; // for scene function
@property (nonatomic, assign) BOOL isSwitchOn;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) UILabel *sectorLabel;

- (void)updateSwitchBgImage;

@end

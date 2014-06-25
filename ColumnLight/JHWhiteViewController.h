//
//  JHWhiteViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWhitePickerWheel.h"

@protocol JHWhiteViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;

@required
- (void)didPushTheSwitchButton;

@end



@interface JHWhiteViewController : UIViewController <JHPickerWheelDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, assign) id<JHWhiteViewControllerDelegate> delegate;

@property (nonatomic, strong) JHWhitePickerWheel *wheel;
@property (nonatomic, strong) JHBrightnessSlider *slider;
@property (nonatomic, strong) UIButton *switchButton;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign) BOOL isSwitchOn;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) UILabel *sectorLabel;

- (void)updateSwitchBgImage;

@end

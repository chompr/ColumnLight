//
//  JHTImerViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTimerWheel.h"
@protocol JHTimerViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;

@required
- (void)didPushTheSwitchButton;

@end

@interface JHTImerViewController : UIViewController

@property (nonatomic, assign) id<JHTimerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

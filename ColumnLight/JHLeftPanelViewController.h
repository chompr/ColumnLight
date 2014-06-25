//
//  JHLeftPanelViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDiscovery.h"
@protocol JHLeftPanelViewDelegate <NSObject>

@required
- (void)movePanelToOriginalPosition;
- (void)leftPanelVCDidLaunchScanning;
- (void)leftPanelVCDidUpadteSelectedServices:(NSMutableArray *)selectedServices;


@optional
- (void)movePanelToOriginalPositionWithBounce;

@end

@interface JHLeftPanelViewController : UIViewController

@property (nonatomic, assign) BOOL isOnTheMainScreen;
@property (nonatomic, assign) id<JHLeftPanelViewDelegate> delegate;

//@property (nonatomic, assign) NSUInteger selectedSection;
//@property (nonatomic, assign) NSUInteger selectedRow;
@end

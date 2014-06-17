//
//  JHLoadingHUD.h
//  ColumnLight
//
//  Created by Alan on 6/17/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHLoadingHUD : UIView



//- (id)initWithFrame:(CGRect)frame;

+ (id)sharedInstance;

- (void)showLoadingHUDInView:(UIView *)view;

- (void)hideLoadingHUD;
@end

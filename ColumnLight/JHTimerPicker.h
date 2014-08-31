//
//  JHTimerPicker.h
//  ColumnLight
//
//  Created by Alan on 8/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHTimerPickerDelegate;


@interface JHPickerScrollView : UITableView

@property (nonatomic, assign) NSInteger tagLastSelected;

@end

@interface JHTimerPicker : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<JHTimerPickerDelegate> delegate;


@end



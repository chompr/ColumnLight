//
//  JHDeviceTableViewCell.h
//  ColumnLight
//
//  Created by Alan on 6/12/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;

- (void)updateCellStatus;
@end

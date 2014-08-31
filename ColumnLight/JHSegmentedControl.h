//
//  JHSegmentedControl.h
//  ColumnLight
//
//  Created by Alan on 8/15/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSegmentedControl : UIView

@property (nonatomic, strong) NSArray *buttonsArray;

@property (nonatomic, strong) NSArray *separatorsArray;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIImage *separatorImage;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end

//
//  JHSceneTableViewCell.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Scene.h"

@interface JHSceneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *container;


//@property (strong, nonatomic) Scene *scene;
- (void)setColorLabelwithScene:(Scene *)scene;

@end


@interface ColorLabel : UIView

@property (nonatomic, strong) UIColor *filledColor;
@property (nonatomic, strong) UIBezierPath *path;

@end
//
//  JHAddNewSceneViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scene.h"

@interface JHAddNewSceneViewController : UIViewController

@property NSManagedObjectContext *context;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) Scene *aNewScene;

@end

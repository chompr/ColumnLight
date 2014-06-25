//
//  JHRightPanelViewController.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JHRightPanelViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *FRC;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign) BOOL isOnTheMainScreen;
@property (nonatomic, assign) BOOL debug;
//@property (nonatomic, readonly) BOOL isInReOrderingMode;
- (void)callEditMode;

@end

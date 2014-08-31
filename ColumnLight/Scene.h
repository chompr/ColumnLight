//
//  Scene.h
//  ColumnLight
//
//  Created by Alan on 7/9/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scene : NSManagedObject

@property (nonatomic) float brightness;
@property (nonatomic) float blue;
@property (nonatomic) int16_t displayOrder;
@property (nonatomic) float green;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) float red;

@end

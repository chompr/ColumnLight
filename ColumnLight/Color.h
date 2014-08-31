//
//  Color.h
//  ColumnLight
//
//  Created by Alan on 7/9/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Color : NSManagedObject

@property (nonatomic) float brightness;
@property (nonatomic) float hue;

@end

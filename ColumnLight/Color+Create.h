//
//  Color+Create.h
//  ColumnLight
//
//  Created by Alan on 6/3/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "Color.h"

@interface Color (Create)

+ (Color *)createNewColorProfileInManagedObjectContext:(NSManagedObjectContext *)context;

@end

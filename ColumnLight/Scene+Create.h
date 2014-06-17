//
//  Scene+Create.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "Scene.h"

@interface Scene (Create)

+ (Scene *)sceneWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end

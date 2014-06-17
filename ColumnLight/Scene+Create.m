//
//  Scene+Create.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "Scene+Create.h"

@implementation Scene (Create)

+ (Scene *)sceneWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
	Scene *scene = nil;
	
	scene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene"
										   inManagedObjectContext:context];
	scene.name = name;
	
	return scene;
}

@end

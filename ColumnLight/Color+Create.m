//
//  Color+Create.m
//  ColumnLight
//
//  Created by Alan on 6/3/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "Color+Create.h"

@implementation Color (Create)

+ (Color *)createNewColorProfileInManagedObjectContext:(NSManagedObjectContext *)context
{
	Color *color = nil;
	color = [NSEntityDescription insertNewObjectForEntityForName:@"Color"
										   inManagedObjectContext:context];
	
	color.hue = 0.f;
	color.brightness = 0.8;
	
	return color;
}

@end

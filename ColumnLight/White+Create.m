//
//  White+Create.m
//  ColumnLight
//
//  Created by Alan on 6/2/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "White+Create.h"

@implementation White (Create)

+ (White *)createNewWhiteProfileInManagedObjectContext:(NSManagedObjectContext *)context
{
	White *white = nil;
	white = [NSEntityDescription insertNewObjectForEntityForName:@"White"
										  inManagedObjectContext:context];
	
	white.sectorNumber = 0;
	white.brightness = 0.8;
	
	return white;
}

@end

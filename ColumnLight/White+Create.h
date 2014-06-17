//
//  White+Create.h
//  ColumnLight
//
//  Created by Alan on 6/2/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "White.h"

@interface White (Create)


+ (White *)createNewWhiteProfileInManagedObjectContext:(NSManagedObjectContext *)context;

@end

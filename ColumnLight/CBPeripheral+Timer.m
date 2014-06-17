//
//  CBPeripheral+Timer.m
//  ColumnLight
//
//  Created by Alan on 6/15/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "CBPeripheral+Timer.h"
#import <objc/runtime.h>

static char const * const kJHConnectingTimerKey = "kJHConnectingTimerKey";

@implementation CBPeripheral (Timer)

- (void)setTimer:(NSTimer *)timer
{
	objc_setAssociatedObject(self, kJHConnectingTimerKey, timer, OBJC_ASSOCIATION_RETAIN);
}

- (NSTimer *)timer
{
	return objc_getAssociatedObject(self, kJHConnectingTimerKey);
}
@end

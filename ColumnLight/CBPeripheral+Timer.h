//
//  CBPeripheral+Timer.h
//  ColumnLight
//
//  Created by Alan on 6/15/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Timer)

@property (nonatomic, strong) NSTimer *timer;

@end

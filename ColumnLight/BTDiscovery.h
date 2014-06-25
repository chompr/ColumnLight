//
//  BTDiscovery.h
//  ColumnLight
//
//  Created by Alan on 6/9/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "CBPeripheral+Timer.h"
#import "JHLightService.h"

#define CONNECTING_TIME_INTERVAL 5

@protocol BTDiscoveryDelegate <NSObject>

- (void)discoveryDidRefresh;
- (void)discoveryDidConnectService:(JHLightService *)service;
- (void)discoveryStatePoweredOff;
- (void)discoveryStatePoweredOn;

@end


@interface BTDiscovery : NSObject

+ (id)sharedInstance;

@property (nonatomic, strong) NSArray *storedDevices;
@property (nonatomic, strong) NSMutableArray *foundPeripherals;
@property (nonatomic, strong) NSMutableArray *connectedServices;
@property (nonatomic, strong) NSMutableArray *selectedServices;

@property (nonatomic, assign) id<BTDiscoveryDelegate> discoveryDelegate;
@property (nonatomic, assign) id<JHLightServiceDelegate> peripheralDelegate;
@property (nonatomic, strong, readonly) CBCentralManager *centralManager;


- (void)startScanningForUUIDString:(NSString *)uuidString;
- (void)stopScanning;

- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;


- (void)updateSelectedServicesWithSection:(NSUInteger)section andRow:(NSUInteger)row;
@end

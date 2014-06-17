//
//  JHLightService.h
//  ColumnLight
//
//  Created by Alan on 6/10/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *kColorServiceUUIDString;

extern NSString *kRedCharacteristicUUIDString;
extern NSString *kGreenCharacteristicUUIDString;
extern NSString *kBlueCharacteristicUUIDString;
extern NSString *kWhiteCharacteristicUUIDString;
extern NSString *kPowerCharacteristicUUIDString;

extern NSString *kColorServiceEnteredBackgroundNotification;
extern NSString *kColorServiceEnteredForegroundNotification;

@class JHLightService;

@protocol JHLightServiceDelegate <NSObject>

- (void)lightServiceDidChangeStatus:(JHLightService *)service;

@end




@interface JHLightService : NSObject

@property (nonatomic, readonly) CBPeripheral *CLPeripheral;

- (id)initWithPeripheral:(CBPeripheral *)peripheral andDelegate:(id<JHLightServiceDelegate>)delegate;
- (void)start;
- (void)reset;


- (void)writeRedValue:(int)red;
- (void)writeGreenValue:(int)green;
- (void)writeBlueValue:(int)blue;
- (void)writeWhiteValue:(int)white;
- (void)writePowerValue:(BOOL)power;


@end

//
//  JHLightService.h
//  ColumnLight
//
//  Created by Alan on 6/10/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define COLOR_SERVICE_UUID [CBUUID UUIDWithString:@"fff0"]

#define RED_CHAR_UUID      [CBUUID UUIDWithString:@"fff1"]
#define GREEN_CHAR_UUID    [CBUUID UUIDWithString:@"fff2"]
#define BLUE_CHAR_UUID     [CBUUID UUIDWithString:@"fff3"]
#define WHITE_CHAR_UUID    [CBUUID UUIDWithString:@"fff4"]
#define POWER_CHAR_UUID    [CBUUID UUIDWithString:@"fff5"]

/*
extern NSString *kColorServiceUUIDString;

extern NSString *kRedCharacteristicUUIDString;
extern NSString *kGreenCharacteristicUUIDString;
extern NSString *kBlueCharacteristicUUIDString;
extern NSString *kWhiteCharacteristicUUIDString;
extern NSString *kPowerCharacteristicUUIDString;
*/
//extern NSString *kColorServiceEnteredBackgroundNotification;
//extern NSString *kColorServiceEnteredForegroundNotification;

#define kColorServiceEnteredBackgroundNotification @"kColorServiceEnteredBackgroundNotification"
#define kColorServiceEnteredForegroundNotification @"kColorServiceEnteredForegroundNotification"

//static NSString *kColorServiceEnteredBackgroundNotification = @"kColorServiceEnteredBackgroundNotification";
//static NSString *kColorServiceEnteredForegroundNotification = @"kColorServiceEnteredForegroundNotification";

@class JHLightService;

@protocol JHLightServiceDelegate <NSObject>

- (void)lightServiceDidChangeStatus:(JHLightService *)service;

- (void)lightServiceDidSwitchOnPower:(JHLightService *)service;
- (void)lightServiceDidSwitchOffPower:(JHLightService *)service;

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

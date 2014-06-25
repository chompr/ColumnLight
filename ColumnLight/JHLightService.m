//
//  JHLightService.m
//  ColumnLight
//
//  Created by Alan on 6/10/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHLightService.h"

/*
NSString *kColorServiceUUIDString = @"fff0";

NSString *kRedCharacteristicUUIDString = @"fff1";
NSString *kGreenCharacteristicUUIDString = @"fff2";
NSString *kBlueCharacteristicUUIDString = @"fff3";
NSString *kWhiteCharacteristicUUIDString = @"fff4";
NSString *kPowerCharacteristicUUIDString = @"fff5";
*/

//NSString *kColorServiceEnteredBackgroundNotification = @"kColorServiceEnteredBackgroundNotification";
//NSString *kColorServiceEnteredForegroundNotification = @"kColorServiceEnteredForegroundNotification";

@interface JHLightService () <CBPeripheralDelegate>

@property (nonatomic ,assign) id<JHLightServiceDelegate> delegate;

@property (nonatomic, strong) CBPeripheral *CLPeripheral;

@property (nonatomic, strong) CBService *colorService;

@property (nonatomic, strong) CBCharacteristic *redCharacteristic;
@property (nonatomic, strong) CBCharacteristic *greenCharacteristic;
@property (nonatomic, strong) CBCharacteristic *blueCharacteristic;
@property (nonatomic, strong) CBCharacteristic *whiteCharacteristic;
@property (nonatomic, strong) CBCharacteristic *powerCharacteristic;
@property (nonatomic, strong) CBCharacteristic *ambLightCharacteristic;

/*
@property (nonatomic, strong) CBUUID *redUUID;
@property (nonatomic, strong) CBUUID *greenUUID;
@property (nonatomic, strong) CBUUID *blueUUID;
@property (nonatomic, strong) CBUUID *whiteUUID;
@property (nonatomic, strong) CBUUID *powerUUID;
*/

@property (nonatomic, assign) BOOL isSwitchOn;
@end

@implementation JHLightService


- (id)initWithPeripheral:(CBPeripheral *)peripheral andDelegate:(id<JHLightServiceDelegate>)delegate
{
	self = [super init];
	if (self) {
		self.CLPeripheral = peripheral;
		self.CLPeripheral.delegate = self;
		self.delegate = delegate;
		
/*
		self.redUUID = [CBUUID UUIDWithString:kRedCharacteristicUUIDString];
		self.greenUUID = [CBUUID UUIDWithString:kGreenCharacteristicUUIDString];
		self.blueUUID = [CBUUID UUIDWithString:kBlueCharacteristicUUIDString];
		self.whiteUUID = [CBUUID UUIDWithString:kWhiteCharacteristicUUIDString];
		self.powerUUID = [CBUUID UUIDWithString:
            kPowerCharacteristicUUIDString];
 */
        
	}
	return self;
}

- (void)reset
{
	if (self.CLPeripheral) {
		self.CLPeripheral = nil;
	}
}

#pragma mark - Service Interaction -

- (void)start
{
/*
	CBUUID *serviceUUID = [CBUUID UUIDWithString:kColorServiceUUIDString];
	NSArray *serviceArray = [NSArray arrayWithObjects:serviceUUID, nil];
*/
    
    NSArray *serviceArray = [NSArray arrayWithObjects:COLOR_SERVICE_UUID, nil];

	[self.CLPeripheral discoverServices:serviceArray];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSArray *services = nil;
	NSArray *uuids = [NSArray arrayWithObjects:RED_CHAR_UUID,
					  GREEN_CHAR_UUID,
					  BLUE_CHAR_UUID,
					  WHITE_CHAR_UUID,
					  POWER_CHAR_UUID,nil];
	
	if (peripheral != self.CLPeripheral) {
		NSLog(@"Wrong peripheral.\n");
		return;
	}
	
	if (error) {
		NSLog(@"Error %@\n", [error localizedDescription]);
		return;
	}
	
	services = [peripheral services];
	if (!services || ![services count]) {
		NSLog(@"No services available");
		return;
	}
	
	for (CBService *service in services) {
		if ([service.UUID isEqual:COLOR_SERVICE_UUID]) {
			self.colorService = service;
			break;
		}
	}
	
	if (self.colorService) {
		[self.CLPeripheral discoverCharacteristics:uuids forService:self.colorService];
	}
	
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSArray *characteristics = [service characteristics];
	
	if (peripheral != self.CLPeripheral) {
		NSLog(@"Wrong peripheral.\n");
		return;
	}
	
	if (service != self.colorService) {
		NSLog(@"Wrong service.\n");
		return;
	}
	
	if (error) {
		NSLog(@"Error: %@\n", [error localizedDescription]);
		return;
	}
	
	for (CBCharacteristic *characteristic in characteristics) {
				
		if ([characteristic.UUID isEqual:RED_CHAR_UUID]) {
			NSLog(@"Discovered red characteristic %@",[characteristic UUID]);
			self.redCharacteristic = characteristic;
		}
		
		if ([characteristic.UUID isEqual:GREEN_CHAR_UUID]) {
			NSLog(@"Discovered green characteristic %@",[characteristic UUID]);
			self.greenCharacteristic = characteristic;
		}
		
		if ([characteristic.UUID isEqual:BLUE_CHAR_UUID]) {
			NSLog(@"Discovered blue characteristic %@",[characteristic UUID]);
			self.blueCharacteristic = characteristic;
		}
		
		if ([characteristic.UUID isEqual:WHITE_CHAR_UUID]) {
			NSLog(@"Discovered white characteristic %@",[characteristic UUID]);
			self.whiteCharacteristic = characteristic;
		}
		
		if ([characteristic.UUID isEqual:POWER_CHAR_UUID]) {
			NSLog(@"Discovered power characteristic %@",[characteristic UUID]);
			self.powerCharacteristic = characteristic;
			[self.CLPeripheral readValueForCharacteristic:self.powerCharacteristic];
			[self.CLPeripheral setNotifyValue:YES forCharacteristic:self.powerCharacteristic];
		}
	}
	
}

#pragma mark - Characteristic Interaction

- (void)writeRedValue:(int)red
{
	NSData *data = nil;
	uint8_t value = (uint8_t)red;
	
	if (!self.CLPeripheral) {
		NSLog(@"Not connected to a peripheral");
		return;
	}
	
	if (!self.redCharacteristic) {
		NSLog(@"No valid RED characteristic");
		return;
	}
	
	data = [NSData dataWithBytes:&value length:sizeof(value)];
	[self.CLPeripheral writeValue:data forCharacteristic:self.redCharacteristic type:CBCharacteristicWriteWithResponse];
	
}

- (void)writeGreenValue:(int)green
{
	NSData *data = nil;
	uint8_t value = (uint8_t)green;
	
	if (!self.CLPeripheral) {
		NSLog(@"Not connected to a peripheral");
		return;
	}
	
	if (!self.greenCharacteristic) {
		NSLog(@"No valid GREEN characteristic");
		return;
	}
	
	data = [NSData dataWithBytes:&value length:sizeof(value)];
	[self.CLPeripheral writeValue:data forCharacteristic:self.greenCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writeBlueValue:(int)blue
{
	NSData *data = nil;
	uint8_t value = (uint8_t)blue;
	
	if (!self.CLPeripheral) {
		NSLog(@"Not connected to a peripheral");
		return;
	}
	
	if (!self.blueCharacteristic) {
		NSLog(@"No valid BLUE characteristic");
		return;
	}
	
	data = [NSData dataWithBytes:&value length:sizeof(value)];
	[self.CLPeripheral writeValue:data forCharacteristic:self.blueCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writeWhiteValue:(int)white
{
	NSData *data = nil;
	uint8_t value = (uint8_t)white;
	
	if (!self.CLPeripheral) {
		NSLog(@"Not connected to a peripheral");
		return;
	}
	
	if (!self.whiteCharacteristic) {
		NSLog(@"No valid WHITE characteristic");
		return;
	}
	
	data = [NSData dataWithBytes:&value length:sizeof(value)];
	[self.CLPeripheral writeValue:data forCharacteristic:self.whiteCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writePowerValue:(BOOL)power
{
	NSData *data = nil;
	uint8_t value = (uint8_t)power;
	
	if (!self.CLPeripheral) {
		NSLog(@"Not connected to a peripheral");
		return;
	}
	
	if (!self.powerCharacteristic) {
		NSLog(@"No valid power characteristic");
		return;
	}
	
	data = [NSData dataWithBytes:&value length:sizeof(value)];
	[self.CLPeripheral writeValue:data forCharacteristic:self.powerCharacteristic type:CBCharacteristicWriteWithResponse];
}


//invoked when characteristic changed its value
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	uint8_t value = 0;
	
	if (peripheral != self.CLPeripheral) {
		NSLog(@"Wrong peripheral.");
		return;
	}
	
	if (error) {
		NSLog(@"ERROR: %@", [error localizedDescription]);
		return;
	}
	
	if ([characteristic.UUID isEqual:POWER_CHAR_UUID]) {
		[[self.powerCharacteristic value] getBytes:&value length:sizeof(value)];
		NSLog(@"Power state: 0x%x", value);
		if (value & 0x01) {
			NSLog(@"Switch is on");
			self.isSwitchOn = YES;
			[self.delegate lightServiceDidChangeStatus:self];
		} else {
			NSLog(@"Switch is off");
			self.isSwitchOn = NO;
			[self.delegate lightServiceDidChangeStatus:self];
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	/* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];
}

@end



















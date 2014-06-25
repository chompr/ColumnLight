//
//  BTDiscovery.m
//  ColumnLight
//
//  Created by Alan on 6/9/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "BTDiscovery.h"
#import "JHNotificationName.h"


@interface BTDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
//@property (nonatomic, assign) BOOL pendingInit;


@end

@implementation BTDiscovery

+ (id)sharedInstance
{
	static BTDiscovery *this = nil;
	if (!this)
		this = [[BTDiscovery alloc] init];
	
	return this;
}

- (id)init
{
	self = [super init];
	if (self) {
		//self.pendingInit = YES;
		self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
		
		self.foundPeripherals = [[NSMutableArray alloc] init];
		self.connectedServices = [[NSMutableArray alloc] init];
		
	}
	
	return self;
}

#pragma mark - Settings -

- (void)updateSelectedServicesWithSection:(NSUInteger)section andRow:(NSUInteger)row
{
	if (section == 0) {
		if (self.connectedServices && [self.connectedServices count] > 0) {
			self.selectedServices = self.connectedServices;
		}
	} else if (section == 1) {
		// for group selection
	} else if (section == 2) {
		if (self.connectedServices) {
			self.selectedServices = [NSMutableArray arrayWithObject:[self.connectedServices objectAtIndex:row]];
		} else {
			NSLog(@"[BTDiscovery] No services connected yet.");
		}
	}
}
- (void)loadSavedDevices
{
	NSArray *storedDevicesString = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	
	if (![storedDevicesString isKindOfClass:[NSArray class]]) {
		NSLog(@"No stored array to load");
		return;
	}
	
	for (id deviceUUIDString in storedDevicesString) {
		if (![deviceUUIDString isKindOfClass:[NSString class]]) {
			continue;
		}
		

		NSUUID *uuid = [[NSUUID UUID] initWithUUIDString:deviceUUIDString];
		
		if (!uuid)
			continue;
		
		self.storedDevices = [NSMutableArray arrayWithArray:[self.centralManager retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:uuid]]];
		
		for (CBPeripheral *peripheral in self.storedDevices) {
			if (peripheral.state == CBPeripheralStateDisconnected) {
				
				peripheral.timer = [NSTimer scheduledTimerWithTimeInterval:CONNECTING_TIME_INTERVAL
																	target:self
																  selector:@selector(failToConnectStoredDevice:)
																  userInfo:peripheral
																   repeats:NO];
				
				
				[self connectPeripheral:peripheral];
			} else {
				NSLog(@"this stored device is in connecting state");
			}
		}
	}
}

- (void)failToConnectStoredDevice:(NSTimer *)timer
{
	if ([timer isValid]) {
		CBPeripheral *peripheral = [timer userInfo];
		NSLog(@"Unable to connect the device %@ from stored list",[peripheral name]);
		[self removeSavedDevice:peripheral.identifier];
		[self disconnectPeripheral:peripheral];
		[timer invalidate];
	} else {
		NSLog(@"timer is invalid");
	}
}
- (void)failToConnectFoundPeripherals:(NSTimer *)timer
{
	if ([timer isValid]) {
		CBPeripheral *peripheral = [timer userInfo];
		NSLog(@"Unable to connect the device %@ from found peripherals", [peripheral name]);
		[self disconnectPeripheral:peripheral];
		NSLog(@"timer in fail method: %p",peripheral.timer);
		[timer invalidate];
	} else {
		NSLog(@"timer is invalid");
	}
}

- (void)addSavedDevice:(NSUUID *)uuid
{
	NSArray *storedDevicesString = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	
	if (![storedDevicesString isKindOfClass:[NSArray class]]) {
		NSLog(@"Cannot find an array, goint to create one");
		storedDevicesString = [NSArray new];
	}
	
	NSMutableArray *newDevicesString = [NSMutableArray arrayWithArray:storedDevicesString];
	
	NSString *uuidString = [uuid UUIDString];
	
	if (uuidString && ![storedDevicesString containsObject:uuidString])
		[newDevicesString addObject:(NSString *)uuidString];
	else
		NSLog(@"Device is already in stored list.");
	
	[[NSUserDefaults standardUserDefaults] setObject:newDevicesString forKey:@"StoredDevices"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void)removeSavedDevice:(NSUUID *)uuid
{
	NSArray *storedDevicesString = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	
	if ([storedDevicesString isKindOfClass:[NSArray class]]) {
		NSMutableArray *newDevicesString = [NSMutableArray arrayWithArray:storedDevicesString];
		NSString *uuidString = [uuid UUIDString];
		
		if (uuidString && [storedDevicesString containsObject:uuidString]) {
			[newDevicesString removeObject:uuidString];
			[[NSUserDefaults standardUserDefaults] setObject:newDevicesString forKey:@"StoredDevices"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

#pragma mark - Discovery -

- (void)startScanningForUUIDString:(NSString *)uuidString
{
	NSLog(@"Scanning Started");
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	
	[self.centralManager scanForPeripheralsWithServices:uuidArray options:option];
}

- (void)stopScanning
{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HUDSearchingDevicesNotification object:nil]];
	[self.centralManager stopScan];
	NSLog(@"Scanning Stopped");
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSLog(@"Did discover peripheral. peripheral: %@ rssi: %@, NSUUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData);
	
	if (![self.foundPeripherals containsObject:peripheral]) {
		[self.foundPeripherals addObject:peripheral];
		//[self connectPeripheral:peripheral];
		
		//[self.discoveryDelegate discoveryDidRefresh];
	} else {
		NSLog(@"Peripheral is already in the list");
		//[self connectPeripheral:[self.foundPeripherals objectAtIndex:[self.foundPeripherals indexOfObject:peripheral]]];
	}

	if (peripheral.state == CBPeripheralStateDisconnected)
	{
		peripheral.timer = [NSTimer scheduledTimerWithTimeInterval:CONNECTING_TIME_INTERVAL
															target:self
														  selector:@selector(failToConnectFoundPeripherals:)
														  userInfo:peripheral
														   repeats:NO];
		[self connectPeripheral:peripheral];
	} else {
		NSLog(@"This peripheral is in connecting state");
	}
}

#pragma mark - Connection/Disconnection -

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"Connecting peripheral %@", [peripheral name]);
	
	if (peripheral.state == CBPeripheralStateDisconnected) {
		[self.centralManager connectPeripheral:peripheral options:nil];
	}
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"Disconnecting peripheral %@", [peripheral name]);
	
	[self.centralManager cancelPeripheralConnection:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HUDSearchingDevicesNotification object:nil]];

	NSLog(@"Did connect peripheral %@", [peripheral name]);
	if ([peripheral.timer isValid]) {
		NSLog(@"timer is valid? %i", [peripheral.timer isValid]);
		NSLog(@"Timer cancelled");
		[peripheral.timer invalidate];
		NSLog(@"timer in didconnect method:%p",peripheral.timer);
	}
	
	JHLightService *service = [[JHLightService alloc] initWithPeripheral:peripheral andDelegate:self.peripheralDelegate];
	[service start];
	
	if (!self.selectedServices) {
		self.selectedServices = [NSMutableArray arrayWithObject:service];
	} else {
		NSLog(@"[BTDiscovery] selectedServices is not nil anymore");
	}
	
	if (![self.connectedServices containsObject:service]) {
		[self.connectedServices addObject:service];
	}
	if ([self.foundPeripherals containsObject:peripheral]) {
		[self.foundPeripherals removeObject:peripheral];
	}
	[self addSavedDevice:peripheral.identifier];
	
	[self.discoveryDelegate discoveryDidRefresh];
	//[self.discoveryDelegate discoveryDidConnectService:service];
	// service did change states
	
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);

	[self.discoveryDelegate discoveryDidRefresh];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"Did disconnect peripheral: %@", [peripheral name]);
	for (JHLightService *service in self.connectedServices)	{
		NSLog(@"Updated connect/peripheral list");
		if (service.CLPeripheral == peripheral) {
			[self.connectedServices removeObject:service];
			[self.foundPeripherals addObject:peripheral];
			[self removeSavedDevice:peripheral.identifier];
			//service did change states
			break;
		}
	}
	
	[self.discoveryDelegate discoveryDidRefresh];
}

- (void)clearDevice
{
	[self.foundPeripherals removeAllObjects];
	
	for (JHLightService *service in self.connectedServices) {
		[service reset];
	}
		
	[self.connectedServices removeAllObjects];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	static CBCentralManagerState previousState = -1;
	
	switch ([self.centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
			NSLog(@"BLE hardware state power off");
			[self clearDevice];
			[self.discoveryDelegate discoveryDidRefresh];
			
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
			if (previousState != -1) {
				[self.discoveryDelegate discoveryStatePoweredOff];
			}
			break;
		}
		case CBCentralManagerStatePoweredOn:
		{
			NSLog(@"BLE state power on");
			[self loadSavedDevices];
			[self.discoveryDelegate discoveryStatePoweredOn];
			break;
		}
		case CBCentralManagerStateResetting:
		{
			NSLog(@"BLE state resetting");
			[self.discoveryDelegate discoveryDidRefresh];
			break;
		}
		case CBCentralManagerStateUnauthorized:
		{
			NSLog(@"BLE state unauthorized");
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HUDSearchingDevicesNotification object:nil]];
			break;
		}
		case CBCentralManagerStateUnknown:
		{
			NSLog(@"BLE state unknow");
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HUDSearchingDevicesNotification object:nil]];
			break;
		}
		case CBCentralManagerStateUnsupported:
		{
			NSLog(@"BLE state unsupported");
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:HUDSearchingDevicesNotification object:nil]];
			break;
		}
	}
	previousState = [self.centralManager state];
}


@end

















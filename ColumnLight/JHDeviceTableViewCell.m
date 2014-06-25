//
//  JHDeviceTableViewCell.m
//  ColumnLight
//
//  Created by Alan on 6/12/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHDeviceTableViewCell.h"
#import "BTDiscovery.h"

@interface JHDeviceTableViewCell ()

//@property (nonatomic, strong) NSTimer *connectingTimer;
//@property (nonatomic, strong) NSTimer *scanningTimer;

@end

@implementation JHDeviceTableViewCell


- (IBAction)tapCheckBox:(id)sender
{
	NSLog(@"checkbox is tapped");
	
	if (self.section == 3) {
		CBPeripheral *peripheral = [[[BTDiscovery sharedInstance] foundPeripherals] objectAtIndex:self.row];
		
		if (peripheral.state == CBPeripheralStateDisconnected) {
			
			peripheral.timer = [NSTimer scheduledTimerWithTimeInterval:CONNECTING_TIME_INTERVAL
																target:self
															  selector:@selector(failToConnectFoundPeripherals:)
															  userInfo:peripheral repeats:NO];
			
			[[BTDiscovery sharedInstance] connectPeripheral:peripheral];
			[self showAnimatingAI];
			NSLog(@"Start connecting peripheral:%@", peripheral.name);
		}
		
	} else if (self.section == 2) {
		CBPeripheral *peripheral = [[[[BTDiscovery sharedInstance] connectedServices] objectAtIndex:self.row] CLPeripheral];
		if (peripheral.state == CBPeripheralStateConnected) {
			[[BTDiscovery sharedInstance] disconnectPeripheral:peripheral];
			[self showAnimatingAI];

			NSLog(@"Start disconnecting peripheral:%@", peripheral.name);
		}
	}
}
- (void)failToConnectFoundPeripherals:(NSTimer *)timer
{
	if ([timer isValid]) {
		CBPeripheral *peripheral = [timer userInfo];
		NSLog(@"Unable to connect the device %@ from found peripherals", [peripheral name]);
		[[BTDiscovery sharedInstance] disconnectPeripheral:peripheral];
		[timer invalidate];
		
		NSString *title = @"Unable to establish a connection";
		NSString *msg = @"Unable to establish a connection to the device. The device maybe powered off.";
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		
	} else {
		NSLog(@"timer is invalid");
	}
}

- (IBAction)tapSwitchButton:(id)sender
{
	NSLog(@"switch button is touched");
	// If the button tapped is in connected services section
	if (self.section == 0) {
		// The switch state in each device should be same, so take the first one as the typical
		JHLightService *firstService = [[[BTDiscovery sharedInstance] connectedServices] objectAtIndex:0];
		if (firstService.isSwitchOn) {
			for (JHLightService *service in [[BTDiscovery sharedInstance] connectedServices]) {
				[service writePowerValue:NO];
				NSLog(@"[JHDeviceTVCell] did write switch off");
			}
		} else {
			for (JHLightService *service in [[BTDiscovery sharedInstance] connectedServices]) {
				[service writePowerValue:YES];
				NSLog(@"[JHDeviceTVCell] did write switch on");
			}
		}

	}
	if (self.section == 2) {
		JHLightService *service = [[[BTDiscovery sharedInstance] connectedServices] objectAtIndex:self.row];
		if (service.isSwitchOn) {
			[service writePowerValue:NO];
		} else {
			[service writePowerValue:YES];
		}
		
	}if (self.section == 3) {
		NSLog(@"[JHDeviceTVCell] WARNING! the switch button in foundPeripherals section should be disabled!");
	}
	
}


- (void)showAnimatingAI
{
	[[self.checkBox subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.activityIndicator startAnimating];
}

- (void)hideAnimatingAI
{
	[self.activityIndicator stopAnimating];
	//[self.connectingTimer invalidate];
}



- (void)updateCellStatus
{
	if (self.section == 0) {
		self.checkBox.enabled = NO;
		self.checkBox.hidden = YES;
		NSArray *services = [[BTDiscovery sharedInstance] connectedServices];
		if (!services || [services count] == 0) {
			self.switchButton.enabled = NO;
			[self turnOffSwitch];
		} else {
			self.switchButton.enabled = YES;
			// Pick the first service as the typical one;
			JHLightService *service = [services objectAtIndex:0];
			if (service.isSwitchOn) {
				[self turnOnSwitch];
			} else {
				[self turnOffSwitch];
			}
		}
		
	}
	
	if (self.section == 3) {
		CBPeripheral *peripheral = [[[BTDiscovery sharedInstance] foundPeripherals] objectAtIndex:self.row];
		if (peripheral.state == CBPeripheralStateDisconnected) {
			self.checkBox.enabled = YES;
			self.checkBox.hidden = NO;
			self.switchButton.enabled = NO;
			[self hideAnimatingAI];
			[self uncheckCheckBox];
			// if device is in found peripheral list, the switch button should be disabled
			[self turnOffSwitch];
			
		} else if (peripheral.state == CBPeripheralStateConnected) {
			//impossible to reach here though;
			self.checkBox.enabled = YES;
			self.checkBox.hidden = NO;
			self.switchButton.enabled = YES;
			[self hideAnimatingAI];
			[self checkCheckBox];
			// if device is in found peripheral list, the switch button should be disabled
			[self turnOffSwitch];
			
		} else if (peripheral.state == CBPeripheralStateConnecting) {
			self.checkBox.enabled = NO;
			self.checkBox.hidden = YES;
			self.switchButton.enabled = NO;
			[self showAnimatingAI];
			[self uncheckCheckBox];
			// if device is in found peripheral list, the switch button should be disabled
			[self turnOffSwitch];
		}
		
	} else if (self.section == 2) {
		JHLightService *service = [[[BTDiscovery sharedInstance] connectedServices] objectAtIndex:self.row];
		CBPeripheral *peripheral = [service CLPeripheral];
		
		if (peripheral.state == CBPeripheralStateConnected) {
			self.checkBox.enabled = YES;
			self.checkBox.hidden = NO;
			self.switchButton.enabled = YES;
			[self hideAnimatingAI];
			[self checkCheckBox];
			
			if (service.isSwitchOn) {
				[self turnOnSwitch];
			} else {
				[self turnOffSwitch];
			}
			
		} else if (peripheral.state == CBPeripheralStateDisconnected) {
			// This case is also impossible to reach.
			self.checkBox.enabled = YES;
			self.checkBox.hidden = NO;
			self.switchButton.enabled = NO;
			[self hideAnimatingAI];
			[self uncheckCheckBox];
			[self turnOffSwitch];
		}
	}
}
- (void)checkCheckBox
{
	[[self.checkBox subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	im.image = [UIImage imageNamed:@"checkBoxOn.png"];
	im.center = CGPointMake(self.checkBox.frame.size.width/2, self.checkBox.frame.size.height/2);
	[self.checkBox addSubview:im];
}

- (void)uncheckCheckBox
{
	[[self.checkBox subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	im.image = [UIImage imageNamed:@"checkBoxOff.png"];
	im.center = CGPointMake(self.checkBox.frame.size.width/2, self.checkBox.frame.size.height/2);
	[self.checkBox addSubview:im];
}

- (void)turnOnSwitch
{
	[[self.switchButton subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	im.image = [UIImage imageNamed:@"cellSwitchOn.png"];
	im.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
	[self.switchButton addSubview:im];
}

- (void)turnOffSwitch
{
	[[self.switchButton subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	im.image = [UIImage imageNamed:@"cellSwitchOff.png"];
	im.center = CGPointMake(self.switchButton.frame.size.width/2, self.switchButton.frame.size.height/2);
	[self.switchButton addSubview:im];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

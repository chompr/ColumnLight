//
//  JHLeftPanelViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHLeftPanelViewController.h"
#import "JHDeviceTableViewCell.h"
#import "BTDiscovery.h"
#import "JHLightService.h"

@interface JHLeftPanelViewController () <UITableViewDataSource, UITableViewDelegate, BTDiscoveryDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;


@end

@implementation JHLeftPanelViewController


- (void)viewDidLoad
{
	//self.connectedServices = [NSMutableArray arrayWithObjects:@"device1", @"device2", nil];
	//self.foundPeripherals = [NSMutableArray arrayWithObjects:@"found1", @"found2", nil];
	
    [super viewDidLoad];
	
	self.deviceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.deviceTableView setDelegate:self];
	[self.deviceTableView setDataSource:self];
	[self.deviceTableView reloadData];
	self.deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self initBTDiscovery];

	

}

- (void)initBTDiscovery
{
	[[BTDiscovery sharedInstance] setDiscoveryDelegate:self];
	//[[BTDiscovery sharedInstance] setPeripheralDelegate:self];
	//[self launchScanning];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterBackgroundNotification:)
												 name:kColorServiceEnteredBackgroundNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterForegroundNotification:) name:kColorServiceEnteredForegroundNotification
											   object:nil];
	
	
}
- (void)launchScanning
{
	[[BTDiscovery sharedInstance] startScanningForUUIDString:@"fff0"];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopScaning) userInfo:nil repeats:NO];
}

- (void)stopScaning
{
	[[BTDiscovery sharedInstance] stopScanning];
	self.refreshButton.enabled = YES;
	
}

- (void)didEnterBackgroundNotification:(NSNotification *)notification
{
	
}

- (void)didEnterForegroundNotification:(NSNotification *)notification
{
	
}

#pragma mark - LightService Delegate -

- (void)lightServiceDidChangeStatus:(JHLightService *)service
{
	
}

#pragma mark - BTDiscovery Delegate -

- (void)discoveryStatePoweredOn
{
	[self launchScanning];
}
- (void)discoveryDidRefresh
{
	[self.deviceTableView reloadData];
}

- (void)discoveryStatePoweredOff
{
	NSString *title = @"Bluetooth is  powered off";
	NSString *msg = @"You must turn on Bluetooth in Setting in order to establish a connection";
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alertView show];
}

#pragma mark - TableView Delegate & Datasource -

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	
	if (section == 0) {
		rows = 1;
	} else if (section == 1) {
		rows = 0;
	} else if (section == 2) {
		rows = [[[BTDiscovery sharedInstance] connectedServices] count];
	} else if (section == 3) {
		rows = [[[BTDiscovery sharedInstance] foundPeripherals] count];
	}
	
	return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"JHDeviceCell";
	
	UINib *nib = [UINib nibWithNibName:@"JHDeviceTableViewCell" bundle:nil];
	[tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
	
	JHDeviceTableViewCell *cell = [self.deviceTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell.nameLabel.enabled = NO;
	cell.section = indexPath.section;
	cell.row = indexPath.row;
	
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor clearColor];
	//[cell setBackgroundView:bgColorView];
	[cell setSelectedBackgroundView:bgColorView];
	
	if (indexPath.section == 0) {
		cell.nameLabel.text = @"All Lights";
		[cell updateCellStatus];
	}
	
	if (indexPath.section == 2) {
		NSArray *devices = [[BTDiscovery sharedInstance] connectedServices];
		CBPeripheral *peripheral = [[devices objectAtIndex:indexPath.row] CLPeripheral];
		
		cell.nameLabel.text = [peripheral name];
		[cell updateCellStatus];
		
	} else if (indexPath.section == 3) {
		NSArray *devices = [[BTDiscovery sharedInstance] foundPeripherals];
		CBPeripheral *peripheral = [devices objectAtIndex:indexPath.row];
		
		cell.nameLabel.text = [peripheral name];
		[cell updateCellStatus];
	}
	//NSLog(@"index path: %li|%li",(long)indexPath.section, (long)indexPath.row);
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedSection = indexPath.section;
	self.selectedRow = indexPath .row;
	[self.delegate movePanelToOriginalPositionWithBounce];
	
	NSLog(@"table view did selected row at indexpath");
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	if (section == 1)
		return @"group";
	else if (section == 2)
		return @"connected peripherals";
	else if (section == 3)
		return @"found peripherals";
	
	return nil;
}
#pragma mark - IBActions -
- (IBAction)refreshDeviceList:(id)sender
{
	if ([[[BTDiscovery sharedInstance] centralManager] state] == CBCentralManagerStatePoweredOn) {
		[self launchScanning];
		self.refreshButton.enabled = NO;
		
	} else if ([[[BTDiscovery sharedInstance] centralManager] state] == CBCentralManagerStatePoweredOff) {
		[self discoveryStatePoweredOff];
	}
}





#pragma mark - System Default Code -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

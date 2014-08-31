//
//  JHRightPanelViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHRightPanelViewController.h"
#import "JHSceneTableViewCell.h"
#import "Scene.h"
#import "JHAddNewSceneViewController.h"
#import "BTDiscovery.h"

@interface JHRightPanelViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UITableView *sceneTableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property BOOL isInReOrderingMode;

@end

@implementation JHRightPanelViewController

- (void)viewDidLoad
{
	self.debug = YES;
	self.isInReOrderingMode = NO;
	NSLog(@"is in reordering mode? %i", self.isInReOrderingMode);
	[super viewDidLoad];
	self.sceneTableView.delegate = self;
	self.sceneTableView.dataSource = self;
	self.sceneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self noSceneInfoDisplay];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	NSLog(@"Right view is closing...");
	if (self.isInReOrderingMode == YES) {
		[self callEditMode];
	}
}
#pragma mark - IBActions -
- (IBAction)editSceneTableView:(id)sender
{
	[self callEditMode];
}
- (void)callEditMode
{
	if (self.editButton.tag == 0) {
		NSLog(@"Enter the eidt mode");
		self.editButton.tag = 1; // 1 means edit mode is on;
		self.isInReOrderingMode = YES;
		NSLog(@"is in reordering mode? %i", self.isInReOrderingMode);
		[self.editButton setTitle:@"Done" forState:UIControlStateNormal];
		[self.sceneTableView setEditing:YES animated:YES];
		[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onLoadTable) userInfo:nil repeats:NO];
		
		
	} else {
		NSLog(@"Exit the edit mode");
		self.editButton.tag = 0; // 0 means edit mode is off;
		self.isInReOrderingMode = NO;
		NSLog(@"is in reordering mode? %i", self.isInReOrderingMode);
		[self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
		[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onLoadTable) userInfo:nil repeats:NO];
		[self.sceneTableView setEditing:NO animated:YES];
	}
}

- (void)onLoadTable
{
    [self.sceneTableView reloadData];
}

- (void)noSceneInfoDisplay
{
	[self.infoLabel1 setText:@"You don't have any scenes yet."];
	self.infoLabel1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
	
	self.infoLabel2.text = @"You can add a new scene to save your current light so you can use it next time with simply just one tap.";
	self.infoLabel2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
	
}
#pragma mark - ManagedObjectContext - 

- (void)setContext:(NSManagedObjectContext *)context
{
	_context = context;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scene"];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayOrder"
															  ascending:YES
															   selector:nil]];
	self.FRC = [[NSFetchedResultsController alloc] initWithFetchRequest:request
												   managedObjectContext:_context
													 sectionNameKeyPath:nil
															  cacheName:nil];
								
}

- (void)setFRC:(NSFetchedResultsController *)newFRC
{
	NSFetchedResultsController *oldFRC = _FRC;
	if (newFRC != oldFRC) {
		_FRC = newFRC;
		newFRC.delegate = self;
		if (newFRC) {
			[self performFetch];
		} else {
			[self.sceneTableView reloadData];
		}
	}
}
- (void)performFetch
{
    if (self.FRC) {
        if (self.FRC.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.FRC.fetchRequest.entityName, self.FRC.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.FRC.fetchRequest.entityName);
        }
        NSError *error;
        BOOL success = [self.FRC performFetch:&error];
        if (!success) NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.sceneTableView reloadData];
}


#pragma mark - UITableViewDelegate -

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.sceneTableView.isEditing) {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Scene *scene = [self.FRC objectAtIndexPath:indexPath];
	uint8_t red = scene.red * 255;
	uint8_t	green = scene.green * 255;
	uint8_t blue = scene.blue * 255;
	uint8_t white = scene.brightness * 255;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	for (JHLightService *service in [[BTDiscovery sharedInstance] connectedServices]) {
		[service writeColorValueWithRed:red green:green blue:blue white:white];
	}
}

#pragma mark - UITableViewDataSource -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = [[self.FRC sections] count];
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if ([[self.FRC sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.FRC sections] objectAtIndex:section];
		rows = [sectionInfo numberOfObjects];
	}
	
	if (!rows) {
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(noSceneInfoDisplay) userInfo:nil repeats:NO];
	} else {
		self.infoLabel1.text = nil;
		self.infoLabel2.text = nil;
	}
	return rows; // here should return the number of scenes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"JHSceneCell";
    
	UINib *nib = [UINib nibWithNibName:@"JHSceneTableViewCell" bundle:nil];
	[tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
	
	JHSceneTableViewCell *cell = [self.sceneTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	//cell.backgroundColor = [UIColor colorWithRed:42/255.f green:43/255.f blue:48/255.f alpha:1];
	//cell.nameLabel.textColor = [UIColor whiteColor];
	
	Scene *scene = [self.FRC objectAtIndexPath:indexPath];
	
	[cell setColorLabelwithScene:scene];
	cell.nameLabel.delegate = self;
	
	/*
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor blueColor];
	[cell setBackgroundView:bgColorView];
	[cell setSelectedBackgroundView:bgColorView];
	 */
	
	if (cell.nameLabel.tag == 1) {
		scene.name = cell.nameLabel.text;
		cell.nameLabel.tag = 0;
	} else {
		cell.nameLabel.text = scene.name;
		
	}
	NSLog(@"cell index %ld", (long)indexPath.row);
	if (!self.sceneTableView.isEditing) // not in edit mode
	{
		cell.nameLabel.text = scene.name;
		cell.nameLabel.enabled = NO;
		cell.container.hidden = NO;
		//cell.switchButton.hidden = NO;
		/*
		if (cell.scene.isSelected) {
			//[cell.switchIndicator setBackgroundColor:[UIColor orangeColor]];
			//cell.scene.isDisplayed = YES;
		} else if (!cell.scene.isSelected) {
			//NSLog(@"cell background color: %@", cell.switchIndicator.backgroundColor.CGColor);
			
			//[cell.switchIndicator setBackgroundColor:[UIColor darkGrayColor]];
			//[cell.switchIndicator setBackgroundColor:[UIColor grayColor]];
		}*/
	} else { // in edit mode
		
		cell.nameLabel.enabled = YES;
		cell.container.hidden = YES;
		//cell.switchButton.hidden = YES;
		
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.FRC managedObjectContext];
		
		
		NSArray *array = self.FRC.fetchedObjects;
		for (Scene *scene in array) {
			if (scene.displayOrder > indexPath.row) {
				scene.displayOrder--;
				//NSLog(@"%ldl with %ul", (long)indexPath.row + 1, scene.displayOrder);
			}
		}
        [context deleteObject:[self.FRC objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	NSInteger fromIndex = sourceIndexPath.row;
	NSInteger toIndex = destinationIndexPath.row;
	
	if (fromIndex == toIndex) {
		return;
	}
	Scene *affectedScene = [self.FRC objectAtIndexPath:sourceIndexPath];
	affectedScene.displayOrder = toIndex;
	
	NSUInteger start, end;
	int delta;
	
	if (fromIndex < toIndex) {
		// move was down, shift up
		delta = -1;
		start = fromIndex + 1;
		end = toIndex;
	} else {
		// move was up, shift down
		delta = 1;
		start = toIndex;
		end = fromIndex - 1;
	}
	for (NSUInteger i = start; i <= end; i++) {
		Scene *otherScene = [self.FRC.fetchedObjects objectAtIndex:i];
		
		otherScene.displayOrder += delta;
	}
	//[self performFetch];
	 
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	textField.tag = 1;
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.sceneTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.sceneTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.sceneTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	switch(type)
	{
		case NSFetchedResultsChangeInsert:
			if (!self.isInReOrderingMode) {
				[self.sceneTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.sceneTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			if (!self.isInReOrderingMode) {
				[self.sceneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			break;
			
		case NSFetchedResultsChangeMove:
			if (!self.isInReOrderingMode) {
				[self.sceneTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				[self.sceneTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	
    [self.sceneTableView endUpdates];
}

#pragma mark - Navigation

- (IBAction)doneAddingScene:(UIStoryboardSegue *)segue
{
	if ([segue.sourceViewController isKindOfClass:[JHAddNewSceneViewController class]]) {
		JHAddNewSceneViewController *ansvc = (JHAddNewSceneViewController *)segue.sourceViewController;
		Scene *scene = ansvc.aNewScene;
		NSLog(@"done adding scene: %p", scene);
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//prepare for some input info, for example color and dimness
	if ([segue.destinationViewController isKindOfClass:[JHAddNewSceneViewController class]]) {
		JHAddNewSceneViewController *ansvc = (JHAddNewSceneViewController *)segue.destinationViewController;
		ansvc.context = self.context;
		ansvc.selectedColor = self.selectedColor;
	}
}





#pragma mark - System Default Code

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


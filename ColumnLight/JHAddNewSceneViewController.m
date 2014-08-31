//
//  JHAddNewSceneViewController.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHAddNewSceneViewController.h"
#import "Scene+Create.h"
@interface JHAddNewSceneViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sceneNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@end

@implementation JHAddNewSceneViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	self.colorLabel.backgroundColor = self.selectedColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)cancel:(id)sender
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation -

#define UNWIND_SEGUE_IDENTIFIER @"Do Add Scene"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
		if (self.context) {
			NSString *name = self.sceneNameTextField.text;
			self.aNewScene = [Scene sceneWithName:name inManagedObjectContext:self.context];
			//self.aNewScene.isSelected = NO;
			
			CGFloat red, green, blue, alpha;
			[self.selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
			self.aNewScene.red = red;
			self.aNewScene.green = green;
			self.aNewScene.blue = blue;
			self.aNewScene.brightness = alpha;
			

			
			NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Scene"];
			NSError *error;
			NSArray *array = [self.context executeFetchRequest:request error:&error];
			self.aNewScene.displayOrder = [array count] - 1;
			NSLog(@"order: %ul", self.aNewScene.displayOrder);
		}
	}
}

@end

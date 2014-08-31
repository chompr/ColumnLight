//
//  JHAlarmTimeAdvanceSettingView.m
//  ColumnLight
//
//  Created by Alan on 8/22/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHAlarmTimeAdvanceSettingView.h"


#define TITLE_LABEL_Y 0
#define TIMER_PICKER_Y 40
#define MIN_LABEL_Y 200
#define BUTTON_Y self.whiteBoard.frame.size.height - 50

#define WHITEBOARD_WIDTH self.bounds.size.width - 20
#define WHITEBOARD_ANIMATION_DURATION 0.5


@interface JHAlarmTimeAdvanceSettingView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *whiteBoard;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) NSArray *timePickerDataSourceArray;
@end

@implementation JHAlarmTimeAdvanceSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupComponents];
    }
    return self;
}

- (void)setupComponents
{
	NSMutableArray *tempArr = [NSMutableArray array];
	for (int i = 0; i < 12; i++) {
		int j = (i+1) * 5;
		NSString *min = [NSString stringWithFormat:@"%i",j];
		[tempArr addObject:min];
	}
	self.timePickerDataSourceArray = [NSArray arrayWithArray:tempArr];
	
	self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	self.whiteBoard = [[UIView alloc] initWithFrame:CGRectMake(10, 250, WHITEBOARD_WIDTH, 310)];
	self.whiteBoard.backgroundColor = [UIColor whiteColor];
	self.whiteBoard.layer.cornerRadius = 3;
	self.whiteBoard.layer.masksToBounds = YES;
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancelButton.frame = CGRectMake(0, BUTTON_Y, 150, 50);
	cancelButton.backgroundColor = [UIColor redColor];
	[cancelButton setTitle:@"NO" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	yesButton.frame = CGRectMake(150, BUTTON_Y, 150, 50);
	yesButton.backgroundColor = [UIColor blackColor];
	[yesButton setTitle:@"YES" forState:UIControlStateNormal];
	[yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[yesButton addTarget:self action:@selector(yesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, TIMER_PICKER_Y, WHITEBOARD_WIDTH, 50)];
	self.timePicker.showsSelectionIndicator = YES;
	self.timePicker.delegate = self;
	self.timePicker.dataSource = self;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_LABEL_Y, WHITEBOARD_WIDTH, 50)];
	titleLabel.text = @"Time Advance Setting";
	titleLabel.textAlignment = NSTextAlignmentCenter;
	
	UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MIN_LABEL_Y, WHITEBOARD_WIDTH, 50)];
	minLabel.text = @"Minutes";
	minLabel.textAlignment = NSTextAlignmentCenter;
	
	[self addSubview:self.whiteBoard];
	
	[self.whiteBoard addSubview:titleLabel];
	[self.whiteBoard addSubview:minLabel];
	[self.whiteBoard addSubview:yesButton];
	[self.whiteBoard addSubview:cancelButton];
	[self.whiteBoard addSubview:self.timePicker];
}

- (void)showWhiteBoard
{
	self.alpha = 0;
	[self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:1.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 1;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 10 - self.whiteBoard.bounds.size.height/2)];
					 }
					 completion:NULL];
	
}

- (void)cancelButtonClicked
{
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:1.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 0;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 
							 [self removeFromSuperview];
						 }
					 }];
}

- (void)yesButtonClicked
{
	[UIView animateWithDuration:WHITEBOARD_ANIMATION_DURATION
						  delay:0
		 usingSpringWithDamping:1.0
		  initialSpringVelocity:1.0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.alpha = 0;
						 [self.whiteBoard setCenter:CGPointMake(self.bounds.size.width/2 ,self.bounds.size.height/2*3)];
					 }
					 completion:^(BOOL finished) {
						 if (finished) {
							 
							 [self removeFromSuperview];
						 }
					 }];
}

#pragma mark - UIPickerView DataSource


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *min = [self.timePickerDataSourceArray objectAtIndex:row];
	return min;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 12;
}

@end






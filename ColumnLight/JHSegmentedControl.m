//
//  JHSegmentedControl.m
//  ColumnLight
//
//  Created by Alan on 8/15/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHSegmentedControl.h"

@interface JHSegmentedControl ()


@property (nonatomic, strong) UIImageView *backgroundImageView;


- (void)segmentButtonPressed:(id)sender;

@end




@implementation JHSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.selectedIndex = 0;
		[self setupComponents];
		self.separatorsArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupComponents
{
	self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	
	[self setBackgroundImage:backgroundImage];
//	[self setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
	
//	[self setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
	
	UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-left.png"]
												 resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 0.0, 4.0) resizingMode:UIImageResizingModeStretch];
	UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-right.png"]
												  resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 0.0, 4.0) resizingMode:UIImageResizingModeStretch];
	
	
	//buttons
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *leftButtonImage = [UIImage imageNamed:@"social-icon.png"];
	leftButton.frame = CGRectMake(0, 0, 150, 34);
	leftButton.center = CGPointMake(75, 18.75);
	[leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
	[leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
	[leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
	[leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateSelected | UIControlStateHighlighted)];
	[leftButton setImage:leftButtonImage forState:UIControlStateNormal];
	[leftButton setImage:leftButtonImage forState:UIControlStateSelected];
	[leftButton setImage:leftButtonImage forState:UIControlStateHighlighted];
	[leftButton setImage:leftButtonImage forState:(UIControlStateHighlighted | UIControlStateSelected)];
	
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *rightButtonImage = [UIImage imageNamed:@"star-icon.png"];
	rightButton.frame = CGRectMake(0.0, 150.0, 150, 34);
	rightButton.center = CGPointMake(225, 18.75);
	[rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
	[rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
	[rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateSelected | UIControlStateHighlighted)];
	[rightButton setImage:rightButtonImage forState:UIControlStateNormal];
	[rightButton setImage:rightButtonImage forState:UIControlStateSelected];
	[rightButton setImage:rightButtonImage forState:UIControlStateHighlighted];
	[rightButton setImage:rightButtonImage forState:(UIControlStateHighlighted | UIControlStateSelected)];
	
	[self addSubview:self.backgroundImageView];
	[self setButtonsArray:@[leftButton, rightButton]];
	
	
}


- (void)segmentButtonPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
	
	if (!button || ![button isKindOfClass:[UIButton class]]) {
		NSLog(@"[JHSegmentedControl] invalid object");
		return;
	}
	
	NSUInteger selectedIndex = button.tag;
	[self setSelectedIndex:selectedIndex];
	

}

#pragma mark - Setters -

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	_backgroundImage = backgroundImage;
	[_backgroundImageView setImage:_backgroundImage];
}

- (void)setButtonsArray:(NSArray *)buttonsArray
{
//	[_buttonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[(UIButton *)obj removeFromSuperview];
//	}];
	
	
	_buttonsArray = buttonsArray;
	
	[_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self addSubview:(UIButton *)obj];
		[(UIButton *)obj addTarget:self action:@selector(segmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[(UIButton *)obj setTag:idx];
		
		if (idx == _selectedIndex) {
			[(UIButton *)obj setSelected:YES];
		}
	}];
	
	
}
- (void)setSeparatorImage:(UIImage *)separatorImage
{
	_separatorImage = separatorImage;
	
	NSUInteger separatorsNumber = [_buttonsArray count] - 1;
	
	[_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (idx <= separatorsNumber) {
			UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:_separatorImage];
			[self addSubview:separatorImageView];
			
		}
	}];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
	if (selectedIndex != _selectedIndex) {
		
		if ([_buttonsArray count] == 0) return;
		UIButton *currentSelectedButton = (UIButton *)_buttonsArray[_selectedIndex];
		UIButton *selectedButton = (UIButton *)_buttonsArray[selectedIndex];
		
		[currentSelectedButton setSelected:!currentSelectedButton.isSelected];
		[selectedButton setSelected:!selectedButton.isSelected];
		
		_selectedIndex = selectedIndex;
		
	}
}


@end
			
			
			
			
			
			
			
			
			
			
			
			

//
//  JHTimerPicker.m
//  ColumnLight
//
//  Created by Alan on 8/5/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHTimerPicker.h"

//Editable constants
static const float VALUE_HEIGHT = 50.0;

static const float SV_MERIDIANS_WIDTH = 100;
static const float SV_HOURS_WIDTH = 60;


//Editable macros
#define BAR_SEL_COLOR [UIColor redColor]
#define LINE_COLOR [UIColor colorWithWhite:0.8 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]

//Editable values
float PICKER_HEIGHT = 200.0;
NSString *FONT_NAME = @"HelveticaNeue";



#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0 - VALUE_HEIGHT/2.0

@interface JHPickerScrollView ()

@property (nonatomic, strong) NSArray *arrayValues;
@property (nonatomic, strong) UIFont *cellFont;


@end

@implementation JHPickerScrollView

- (id)initWithFrame:(CGRect)frame andValue:(NSArray *)arrayValues withTextAlign:(NSTextAlignment)align andTextSize:(float)textSize
{
	if (self = [super initWithFrame:frame]) {
		[self setScrollEnabled:YES];
		[self setShowsVerticalScrollIndicator:NO];
		[self setUserInteractionEnabled:YES];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[self setContentInset:UIEdgeInsetsMake(BAR_SEL_ORIGIN_Y, 0.0, BAR_SEL_ORIGIN_Y, 0.0)];
		
		self.cellFont = [UIFont fontWithName:FONT_NAME size:textSize];
		
		if (arrayValues)
			self.arrayValues = [arrayValues copy];
	}
	return self;
}

- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow
{
	[self setTagLastSelected:indexPathRow];
	NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.tagLastSelected inSection:0], nil];
	[self beginUpdates];
	[self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	[self endUpdates];
	
}

- (void)dehighlightLastCell
{
	NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.tagLastSelected inSection:0], nil];
	[self setTagLastSelected:-1];
	[self beginUpdates];
	[self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	[self endUpdates];
}


@end


//Custom Data Picker

@interface JHTimerPicker ()

@property (nonatomic, strong) NSArray *arrayHours;
@property (nonatomic, strong) NSArray *arrayMinutes;
@property (nonatomic, strong) NSArray *arrayMeridians;

@property (nonatomic, strong) JHPickerScrollView *hoursSV;
@property (nonatomic, strong) JHPickerScrollView *minsSV;
@property (nonatomic, strong) JHPickerScrollView *meridiansSV;


@end
@implementation JHTimerPicker

- (void)drawRect:(CGRect)rect
{
	[self initialize];
	[self buildControl];
}
- (void)initialize
{
	self.arrayMeridians = @[@"AM",@"PM"];
	NSMutableArray *arrayHours = [[NSMutableArray alloc] initWithCapacity:12];
	for (int i = 1; i <= 12; i++) {
		[arrayHours addObject:[NSString stringWithFormat:@"%@%d", (i<10) ? @"0" : @"", i]];
	}
	self.arrayHours = [NSArray arrayWithArray:arrayHours];
	
	NSMutableArray *arrayMinutes = [[NSMutableArray alloc] initWithCapacity:60];
	for (int i = 1; i < 60; i++) {
		[arrayMinutes addObject:[NSString stringWithFormat:@"%@%d", (i<10) ? @"0" : @"", i]];
	}
	self.arrayMinutes = [NSArray arrayWithArray:arrayMinutes];
}

- (void)buildControl
{
	//Create a view as base of the picker;
	UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, PICKER_HEIGHT)];
	[pickerView setBackgroundColor:self.backgroundColor];
	
	//Create a bar selector
	UIView *barSel = [[UIView alloc] initWithFrame:CGRectMake(0, BAR_SEL_ORIGIN_Y, self.frame.size.width, VALUE_HEIGHT)];
	[barSel setBackgroundColor:BAR_SEL_COLOR];
	
	//Create the first column (meridians) of the picker
	self.meridiansSV = [[JHPickerScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SV_MERIDIANS_WIDTH, PICKER_HEIGHT)
														andValue:self.arrayMeridians
												   withTextAlign:NSTextAlignmentRight
													 andTextSize:14.0];
	self.meridiansSV.tag = 0;
	[self.meridiansSV setDelegate:self];
	[self.meridiansSV setDataSource:self];
	
	//Create the second column (hours) of the picker
	
	self.hoursSV = [[JHPickerScrollView alloc] initWithFrame:CGRectMake(SV_MERIDIANS_WIDTH, 0.0, self.frame.size.width, PICKER_HEIGHT)
													andValue:self.arrayHours
											   withTextAlign:NSTextAlignmentRight
												 andTextSize:25.0];
	self.hoursSV.tag = 1;
	[self.hoursSV setDelegate:self];
	[self.hoursSV setDataSource:self];
	
	self.minsSV = [[JHPickerScrollView alloc] initWithFrame:CGRectMake(self.hoursSV.frame.origin.x + SV_HOURS_WIDTH, 0.0, self.frame.size.width, PICKER_HEIGHT)
												   andValue:self.arrayMinutes
											  withTextAlign:NSTextAlignmentRight
												andTextSize:25.0];
	self.minsSV.tag = 2;
	[self.minsSV setDelegate:self];
	[self.minsSV setDataSource:self];
	
	//Create separators lines
	UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(SV_MERIDIANS_WIDTH - 1.0, 0.0, 2.0, PICKER_HEIGHT)];
	[line1 setBackgroundColor:LINE_COLOR];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.hoursSV.frame.origin.x + SV_HOURS_WIDTH - 1.0, 0.0,2.0, PICKER_HEIGHT)];
	[line2 setBackgroundColor:LINE_COLOR];
	
	
	//Layer gradient
	CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
	gradientLayerTop.frame = CGRectMake(0.0, 0.0, pickerView.frame.size.width, PICKER_HEIGHT/2);
	gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)self.backgroundColor.CGColor, nil];
	gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
	gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
	
	CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
	gradientLayerBottom.frame = CGRectMake(0.0, PICKER_HEIGHT/2.0, pickerView.frame.size.width, PICKER_HEIGHT/2);
	gradientLayerBottom.colors = gradientLayerTop.colors;
	gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
	gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
	
	[pickerView addSubview:line1];
	[pickerView addSubview:line2];
	
	[pickerView addSubview:barSel];
	
	[pickerView addSubview:self.meridiansSV];
	[pickerView addSubview:self.hoursSV];
	[pickerView addSubview:self.minsSV];

	
	[pickerView.layer addSublayer:gradientLayerTop];
	[pickerView.layer addSublayer:gradientLayerBottom];
	
	[self addSubview:pickerView];
}


- (void)centerValueForScrollView:(JHPickerScrollView *)scrollView
{
	//Takes the actual offset
	float offset = scrollView.contentOffset.y;
	
	//Remove the contentInset and calculates the precise value to center the nearest cell
	offset += scrollView.contentInset.top;
	int modulo = (int)offset % (int)VALUE_HEIGHT;
	float newValue = (modulo >= VALUE_HEIGHT/2.0) ? offset + (VALUE_HEIGHT - modulo) : offset - modulo;
	
	//Calculate the indexPath of the cell and set it in the object as property
	NSInteger indexPathRow = (int)(newValue/VALUE_HEIGHT);
	
	[self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
	NSLog(@"indexPathRow is: %li", (long)indexPathRow);
	
}

- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(JHPickerScrollView *)scrollView
{
	if (indexPathRow >= [scrollView.arrayValues count]) {
		indexPathRow = [scrollView.arrayValues count] - 1;
	}
	
	float newOffset = indexPathRow * VALUE_HEIGHT;
	
	//Re-add the contentInset and set the new offset
	newOffset -= BAR_SEL_ORIGIN_Y;
	[scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
	
	//Hightlight the cell
	[scrollView highlightCellWithIndexPathRow:indexPathRow];
	
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (![scrollView isDragging]) {
		[self centerValueForScrollView:(JHPickerScrollView *)scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self centerValueForScrollView:(JHPickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	JHPickerScrollView *sv = (JHPickerScrollView *)scrollView;
	[sv dehighlightLastCell];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	JHPickerScrollView *sv = (JHPickerScrollView *)tableView;
	return [sv.arrayValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"reusableCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	JHPickerScrollView *sv = (JHPickerScrollView *)tableView;
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		[cell setBackgroundColor:[UIColor clearColor]];
		[cell.textLabel setFont:sv.cellFont];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	[cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
	[cell.textLabel setText:sv.arrayValues[indexPath.row]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return VALUE_HEIGHT;
}
@end



















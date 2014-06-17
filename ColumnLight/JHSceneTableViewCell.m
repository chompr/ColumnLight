//
//  JHSceneTableViewCell.m
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHSceneTableViewCell.h"
#import "Scene.h"

@implementation JHSceneTableViewCell

/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		
	}
	return self;
}
*/

- (void)setColorLabelwithScene:(Scene *)scene
{
	[[self.container subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	UIColor *color = [UIColor colorWithRed:scene.red green:scene.green blue:scene.blue alpha:scene.alpha];
	ColorLabel *colorLabel = [[ColorLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	colorLabel.filledColor = color;
	[self.container addSubview:colorLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

@end



@implementation ColorLabel

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	
	self.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
														radius:8
													startAngle:0.f
													  endAngle:360.f
													 clockwise:YES];
	 
	//UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 60)];
	/*
	self.layer.shadowPath = self.path.CGPath;
	self.layer.shadowColor = self.filledColor.CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowRadius = 3.f;
	self.layer.shadowOpacity = 0.2;
	 */
	[self.path closePath];
	[self.filledColor setFill];
	[self.path fill];

	
}



@end
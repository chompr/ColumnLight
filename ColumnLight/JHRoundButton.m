//
//  JHRoundButton.m
//  ColumnLight
//
//  Created by Alan on 7/8/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import "JHRoundButton.h"

@implementation JHRoundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGFloat radius = self.bounds.size.height / 2;
    //
    CGFloat x = radius - point.x;
    CGFloat y = radius - point.y;
    //
    if (x*x + y*y < radius*radius)
        return [super pointInside:point withEvent:event];
    else
        return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

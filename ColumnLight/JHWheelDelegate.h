//
//  JHWhiteWheelDelegate.h
//  ColumnLight
//
//  Created by Alan on 5/28/14.
//  Copyright (c) 2014 Alan Jiong Huang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JHWheelDelegate <NSObject>

- (void)wheelDidChangeSectorNumber:(int)sectorNumber andDimness:(CGFloat)dimness;

@end
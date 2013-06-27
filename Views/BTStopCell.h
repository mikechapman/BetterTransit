//
//  BTStopCell.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastScrollingCell.h"
#import "BTStop.h"

@interface BTStopCell : FastScrollingCell
{
	BTStop *stop;
	UIImage *iconImage;
}

@property (nonatomic, strong) BTStop *stop;
@property (nonatomic, strong) UIImage *iconImage;

- (void)drawCellView:(CGRect)rect;

@end

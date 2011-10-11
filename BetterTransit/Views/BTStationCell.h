//
//  BTStopCell.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastScrollingCell.h"
#import "BTStop.h"

@interface BTStopCell : FastScrollingCell
{
	BTStop *station;
	UIImage *iconImage;
}

@property (nonatomic, retain) BTStop *station;
@property (nonatomic, retain) UIImage *iconImage;

- (void)drawCellView:(CGRect)rect;

@end

//
//  BTRouteCell.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastScrollingCell.h"
#import "BTRoute.h"

@interface BTRouteCell : FastScrollingCell
{
	BTRoute *route;
	UIImage *iconImage;
}

@property (nonatomic, strong) BTRoute *route;
@property (nonatomic, strong) UIImage *iconImage;

- (void)drawCellView:(CGRect)rect;

@end

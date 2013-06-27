//
//  BTPredictionCell.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTPredictionCell : UITableViewCell
{
	UIImageView *imageView;
	UILabel *routeLabel;
	UILabel *destinationLabel;
	UILabel *estimateLabel;
	UILabel *idLabel; // show route ID when route icons are not available
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *routeLabel;
@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *estimateLabel;
@property (nonatomic, strong) IBOutlet UILabel *idLabel;

@end

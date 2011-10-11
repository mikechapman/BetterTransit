//
//  BTRailViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTStopCell.h"
#import "BTPredictionViewController.h"
#import "BTUIViewController.h"

@interface BTRailViewController : BTUIViewController
<UITableViewDelegate, UITableViewDataSource> 
{
	BTTransit *transit;
	BTRoute *route;
	NSArray *stopLists;
	
	NSArray *stops;
	UITableView *mainTableView;
	UISegmentedControl *segmentedControl;
	UIImageView *titleImageView;
	
	UIView *routeDestView;
	UILabel *destLabel;
	UIImageView *destImageView;
	UILabel *destIdLabel; // show route ID when route icon is not available
}

@property (nonatomic, retain) BTRoute *route;
@property (nonatomic, retain) NSArray *stopLists;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIImageView *titleImageView;
@property (nonatomic, retain) IBOutlet UIView *routeDestView;
@property (nonatomic, retain) IBOutlet UILabel *destLabel;
@property (nonatomic, retain) IBOutlet UIImageView *destImageView;
@property (nonatomic, retain) IBOutlet UILabel *destIdLabel;

- (void)segmentAction:(id)sender;

@end

//
//  BTTripViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTStopCell.h"
#import "BTPredictionViewController.h"

@interface BTTripViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource> 
{
	BTTransit *transit;
	BTRoute *route;
	NSArray *trips;
	NSArray *stops;
    
	UITableView *mainTableView;
	UISegmentedControl *segmentedControl;
	UIImageView *titleImageView;
	
	UIView *routeDestView;
	UILabel *destLabel;
	UIImageView *destImageView;
	UILabel *destIdLabel; // show route ID when route icon is not available
}

@property (nonatomic, strong) BTRoute *route;
@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) IBOutlet UIView *routeDestView;
@property (nonatomic, strong) IBOutlet UILabel *destLabel;
@property (nonatomic, strong) IBOutlet UIImageView *destImageView;
@property (nonatomic, strong) IBOutlet UILabel *destIdLabel;

- (void)segmentAction:(id)sender;

@end

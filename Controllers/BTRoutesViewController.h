//
//  BTRoutesViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"

@interface BTRoutesViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
	BTTransit *transit;
	NSDictionary *routesToDisplay;
	NSArray *sectionNames;
	UITableView *mainTableView;
}

@property (nonatomic, strong) NSDictionary *routesToDisplay;
@property (nonatomic, strong) NSArray *sectionNames;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;

@end

//
//  SettingsViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/17/11.
//  Copyright (c) 2011 Happen Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "HAListViewController.h"

@interface SettingsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, HAListViewControllerDelegate>
{
    BTTransit *transit;
    UITableView * mainTableView;
}

@property (nonatomic, retain) IBOutlet UITableView * mainTableView;
@property (nonatomic, retain) NSArray *startupScreenOptions;
@property (nonatomic, retain) NSArray *maxNumNearbyStopsOptions;

@end

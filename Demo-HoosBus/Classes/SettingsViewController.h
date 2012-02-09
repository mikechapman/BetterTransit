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

@property (nonatomic, strong) IBOutlet UITableView * mainTableView;
@property (nonatomic, strong) NSArray *startupScreenOptions;
@property (nonatomic, strong) NSArray *maxNumNearbyStopsOptions;

@end

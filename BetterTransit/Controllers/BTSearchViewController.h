//
//  BTSearchViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 11/10/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTStopCell.h"
#import "BTPredictionViewController.h"

@interface BTSearchViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
	BTTransit *transit;
	NSArray *stops;
	
	UISearchBar *searchBar;
	UITableView *mainTableView;
    UIImageView * backdrop;
	
	UIButton *bigCancelButton;
	BOOL bigCancelButtonIsShown;
	
	UILabel *noResultsLabel;
	BOOL noResultsLabelIsShown;
}

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *stops;

- (void)handleSearchForTerm:(NSString *)term;
- (void)registerForKeyboardNotifications;
- (void)keyboardDidShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;
- (void)cancel:(id)sender;

@end

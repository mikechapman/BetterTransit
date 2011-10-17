//
//  HAListViewController.h
//  Showtime
//
//  Created by Yaogang Lian on 1/16/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAListViewControllerDelegate <NSObject>
- (void)setSelectedIndex:(NSUInteger)index inList:(NSInteger)tag;
@end


@interface HAListViewController : UIViewController
<UITableViewDelegate, UITableViewDelegate>
{
	UITableView *mainTableView;
	NSArray *list;
	NSInteger tag; // identifier for a list view
	NSUInteger selectedIndex;
	id<HAListViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<HAListViewControllerDelegate> delegate;

@end

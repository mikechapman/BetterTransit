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
	id<HAListViewControllerDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, unsafe_unretained) id<HAListViewControllerDelegate> delegate;

@end

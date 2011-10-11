//
//  BTFeedLoader.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "BTStop.h"
#import	"BTPredictionEntry.h"

@protocol BTFeedLoaderDelegate <NSObject>

- (void)updatePrediction:(id)info;

@end

@interface BTFeedLoader : NSObject
{
	NSMutableArray *prediction; // includes prediction for all available routes
	NSObject<BTFeedLoaderDelegate> *delegate;
	BTStop *currentStation;
	
	ASINetworkQueue *networkQueue;
}

@property (nonatomic, retain) NSMutableArray *prediction;
@property (assign) id<BTFeedLoaderDelegate> delegate;
@property (nonatomic, retain) BTStop *currentStation;

- (NSString *)dataSourceForStation:(BTStop *)station;
- (void)getPredictionForStation:(BTStop *)station;
- (void)getFeedForEntry:(BTPredictionEntry *)entry;

@end

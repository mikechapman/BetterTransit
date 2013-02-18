//
//  BTFeedLoader.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTStop.h"
#import	"BTPredictionEntry.h"
#import "AFNetworking.h"

@protocol BTFeedLoaderDelegate <NSObject>

- (void)updatePrediction:(id)info;

@end

@interface BTFeedLoader : NSObject
{
	NSMutableArray * prediction; // includes prediction for all available routes
	NSObject<BTFeedLoaderDelegate> * __weak delegate;
	BTStop * currentStop;
    AFHTTPClient * httpClient;
}

@property (nonatomic, strong) IBOutlet BTTransit * transit;
@property (nonatomic, strong) NSMutableArray * prediction;
@property (weak) id<BTFeedLoaderDelegate> delegate;
@property (nonatomic, strong) BTStop * currentStop;

- (NSString *)dataSourceForStop:(BTStop *)stop;
- (void)getPredictionForStop:(BTStop *)stop;
- (void)getFeedForEntry:(BTPredictionEntry *)entry;
- (void)cancelAllDownloads;

@end

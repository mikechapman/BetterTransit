//
//  BTFeedLoader.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTFeedLoader.h"
#import "Reachability.h"
#import "BTTransitDelegate.h"
#import "AFNetworking.h"

@implementation BTFeedLoader

@synthesize transit, prediction, delegate, currentStop;


#pragma mark -
#pragma mark Initialization

- (id)init
{
	if (self = [super init]) {
		prediction = [[NSMutableArray alloc] init];
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
	}
	return self;
}

// Subclasses should overwrite this
- (NSString *)dataSourceForStop:(BTStop *)stop
{
	return @"";
}

// Subclasses should overwrite this
- (void)getPredictionForStop:(BTStop *)stop
{
    /*
	// Check Internet connection
	if (![[Reachability reachabilityForInternetConnection] isReachable]) {
		[delegate updatePrediction:@"No Internet connection"];
		return;
	}
     */
    
    // Cancel previous requests
    [httpClient.operationQueue cancelAllOperations];
	
	self.currentStop = stop;
	
    [httpClient getPath:[self dataSourceForStop:stop] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate updatePrediction:self.prediction];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"request did fail with error: %@", error);
        [delegate updatePrediction:nil];
    }];
}

- (void)getFeedForEntry:(BTPredictionEntry *)entry
{
	// subclass should overwrite this method
}

- (void)cancelAllDownloads
{
    // Cancel previous requests
	[httpClient.operationQueue cancelAllOperations];
}

- (void)dealloc
{
	delegate = nil;
}

@end

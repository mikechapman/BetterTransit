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
        networkQueue = [[NSOperationQueue alloc] init];
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
	[networkQueue cancelAllOperations];
	
	self.currentStop = stop;
	
	NSURL * url = [NSURL URLWithString:[self dataSourceForStop:stop]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate updatePrediction:self.prediction];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"request did fail with error: %@", error);
        [delegate updatePrediction:nil];
    }];
    [networkQueue addOperation:operation];
}

- (void)getFeedForEntry:(BTPredictionEntry *)entry
{
	// subclass should overwrite this method
}

- (void)cancelAllDownloads
{
    // Cancel previous requests
	[networkQueue cancelAllOperations];
}

- (void)dealloc
{
    [networkQueue cancelAllOperations];
	delegate = nil;
}

@end

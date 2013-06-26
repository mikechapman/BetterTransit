//
//  BTFeedLoader.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTFeedLoader.h"
#import "BTTransitDelegate.h"

@implementation BTFeedLoader

@synthesize transit, prediction, delegate, currentStop;


#pragma mark - Initialization

- (id)init
{
	if (self = [super init]) {
		prediction = [[NSMutableArray alloc] init];
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.google.com"]];
        [httpClient setDefaultHeader:@"User-Agent" value:@"Mozilla/5.0"];
	}
	return self;
}

// Subclasses should overwrite this
- (void)getPredictionForStop:(BTStop *)stop
{
    // Cancel previous requests
    [httpClient.operationQueue cancelAllOperations];
	
	self.currentStop = stop;
    
    NSString * path = @"http://www.happentransit.com/api/v1/prediction";
    NSDictionary * params = @{@"stop": stop.stopCode};
	
    [httpClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

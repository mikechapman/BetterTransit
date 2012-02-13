//
//  HBFeedLoader.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/1/09.
//  Copyright 2009 Yaogang Lian. All rights reserved.
//

#import "HBFeedLoader.h"
#import "BTPredictionEntry.h"
#import "NSString+Trim.h"
#import "PaPa.h"

@implementation HBFeedLoader


- (id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString *)dataSourceForStop:(BTStop *)stop
{
	return [NSString stringWithFormat:@"http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%@&Referrer=uvamobile", stop.stopCode];
}


#pragma mark -
#pragma mark ASIHTTPRequest delegate methods

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
	int requestType = [[[request userInfo] objectForKey:@"request_type"] intValue];
	if (requestType == REQUEST_TYPE_GET_FEED) {
		DDLogVerbose(@"%@", [request responseString]);
        
        PaPaDoc * doc = [PaPaDoc docWithHTMLData:[request responseData]];
        NSArray * rows = [doc findAll:@"//tbody/tr"];
		
        // Reset self.prediction
        [self.prediction removeAllObjects];
        
        for (PaPaTag * row in rows) {
            NSArray * tdTags = [row findAll:@"td"];
            if ([tdTags count] == 3) {
                NSString * routeShortName = [[[tdTags objectAtIndex:0] content] trim];
                NSString * destination = [[[tdTags objectAtIndex:1] content] trim];
                NSString * eta = [[[tdTags objectAtIndex:2] content] trim];
                
                // Check if the route id is valid
                if ([routeShortName isEqualToString:@""]) continue;
                
                // Check if this route already exists in time table
                BOOL routeAlreadyExists = NO;
                
                for (BTPredictionEntry * pe in self.prediction) {
                    if ([routeShortName isEqualToString:pe.route.shortName] &&
                        [destination isEqualToString:pe.destination]) {
                        routeAlreadyExists = YES;
                        NSString * newETA = [NSString stringWithFormat:@"%@, %@", pe.eta, eta];
                        pe.eta = newETA;
                        break;
                    }
                }
                
                if (!routeAlreadyExists) {
                    BTPredictionEntry * entry = [[BTPredictionEntry alloc] init];
                    entry.route = [self.transit routeWithShortName:routeShortName];
                    entry.destination = destination;
                    entry.eta = eta;
                    [self.prediction addObject:entry];
                }
                
            }
        }

done_download:
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self.delegate updatePrediction:self.prediction];
	}
}

@end

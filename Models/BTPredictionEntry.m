//
//  BTPredictionEntry.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import "BTPredictionEntry.h"


@implementation BTPredictionEntry

@synthesize route, stop, destination, eta;
@synthesize shouldDownloadData, isUpdating;
@synthesize info, retryCount;

- (id)init
{
    self = [super init];
	if (self) {
		shouldDownloadData = NO;
		isUpdating = NO;
        retryCount = 0;
	}
	return self;
}

- (NSComparisonResult)sortByRouteIdNumerically:(BTPredictionEntry *)other
{
	NSCharacterSet *nonNumeric = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	
	BOOL firstCharacterIsLetter = [nonNumeric characterIsMember:[self.route.routeId characterAtIndex:0]];
	BOOL otherFirstCharacterIsLetter = [nonNumeric characterIsMember:[other.route.routeId characterAtIndex:0]];
	
	if (firstCharacterIsLetter && otherFirstCharacterIsLetter) {
		return [self.route.routeId compare:other.route.routeId];
	} else if (!firstCharacterIsLetter && otherFirstCharacterIsLetter) {
		return NSOrderedAscending;
	} else if (firstCharacterIsLetter && !otherFirstCharacterIsLetter) {
		return NSOrderedDescending;
	} else {
		int value = [[self.route.routeId stringByTrimmingCharactersInSet:nonNumeric] intValue];
		int otherValue = [[other.route.routeId stringByTrimmingCharactersInSet:nonNumeric] intValue];
		if (value == otherValue) return NSOrderedSame;
		return ((value < otherValue) ? NSOrderedAscending : NSOrderedDescending);
	}
}

@end

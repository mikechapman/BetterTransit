//
//  BTStopList.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTRoute;

@interface BTStopList : NSObject {
}

@property (nonatomic, retain) BTRoute * route;
@property (nonatomic, retain) NSMutableArray * stops;

@property (nonatomic, retain) NSString * listId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * detail;

@end

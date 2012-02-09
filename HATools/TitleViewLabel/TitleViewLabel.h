//
//  TitleViewLabel.h
//  bettertransit
//
//  Created by Yaogang Lian on 6/18/11.
//  Copyright 2011 Happen Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TitleViewLabel : UIView
{
    NSString *text;
}

@property (nonatomic, strong) NSString *text;

- (id)initWithText:(NSString *)s;

@end

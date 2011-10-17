//
//  TitleViewLabel.m
//  bettertransit
//
//  Created by Yaogang Lian on 6/18/11.
//  Copyright 2011 Happen Apps. All rights reserved.
//

#import "TitleViewLabel.h"

#define MAX_WIDTH 180.0f

@implementation TitleViewLabel

@synthesize text;

- (id)initWithText:(NSString *)s
{
    self = [super initWithFrame:CGRectMake(0, 0, MAX_WIDTH, 36)];
    if (self) {
        self.text = s;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    
    UIFont *normalTextFont = [UIFont boldSystemFontOfSize:19.0f];
    UIFont *smallTextFont = [UIFont boldSystemFontOfSize:14.0f];
    
    // Show the totle with subtle shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *shadowColor = [UIColor darkGrayColor];
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, -1.0f), 0.5f, shadowColor.CGColor);
    
    CGSize size = [self.text sizeWithFont:smallTextFont];
    if (size.width > MAX_WIDTH) {
        [self.text drawInRect:CGRectMake(0, 0, MAX_WIDTH, 36)
                     withFont:smallTextFont
                lineBreakMode:UILineBreakModeWordWrap
                    alignment:UITextAlignmentCenter];
    } else {
        CGFloat actualFontSize;
        CGSize actualSize = [self.text sizeWithFont:normalTextFont
                                        minFontSize:14.0f
                                     actualFontSize:&actualFontSize
                                           forWidth:MAX_WIDTH
                                      lineBreakMode:UILineBreakModeWordWrap];
        
        // UINavigationBar automatically adjusts the position of the titleView, depending on
        // the leftBarButtonItem, rightBarButtonItem, and the titleView's width.
        // This is why the titleView can appear off center. To compensate this, we move
        // the internal text label back by the same offset, but not beyond the titleView's frame.
        CGFloat offset = self.center.x - self.superview.center.x;
        CGFloat xstart = (MAX_WIDTH-actualSize.width)/2.0 - offset;
        if (xstart < 0) xstart = 0.0f;
        
        [self.text drawInRect:CGRectMake(xstart, 6, actualSize.width, 24)
                     withFont:[UIFont boldSystemFontOfSize:actualFontSize]
                lineBreakMode:UILineBreakModeWordWrap
                    alignment:UITextAlignmentCenter];
    }
}

@end

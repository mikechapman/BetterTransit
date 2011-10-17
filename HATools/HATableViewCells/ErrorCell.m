//
//  ErrorCell.m
//  HoosBus
//
//  Created by Yaogang Lian on 10/14/11.
//  Copyright (c) 2011 Happen Apps, Inc. All rights reserved.
//

#import "ErrorCell.h"

#define MAIN_FONT_SIZE 16
#define MAX_TEXT_WIDTH 250
#define Y_PADDING 16

@implementation ErrorCell

@synthesize label, image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		cellView.backgroundColor = [UIColor clearColor];
		self.label = nil;
		self.image = nil;
    }
    return self;
}

- (void)drawCellView:(CGRect)rect
{
	// Color and font for the label
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
	} else {
		mainTextColor = [UIColor blackColor];
	}
	
	// Set the color for the main text items.
	[mainTextColor set];
	
	// Show label
	CGSize size = [label sizeWithFont:mainFont constrainedToSize:CGSizeMake(MAX_TEXT_WIDTH, CGFLOAT_MAX)
						lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat rowHeight = size.height + Y_PADDING;
	if (rowHeight < 72.0f) rowHeight = 72.0f;
	
	CGRect r = CGRectMake(44, (rowHeight-size.height)/2.0, MAX_TEXT_WIDTH, size.height);
	[self.label drawInRect:r
				  withFont:mainFont
			 lineBreakMode:UILineBreakModeWordWrap
				 alignment:UITextAlignmentLeft];
	
	// Draw image
	[image drawInRect:CGRectMake(10, (rowHeight-24)/2.0, 24, 24)];
}	

- (void)dealloc
{
	[label release], label = nil;
	[image release], image = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Misc.

+ (CGFloat)rowHeightForText:(NSString *)s
{
	CGFloat rowHeight;
	if (s == nil) {
		rowHeight = 44.0f;
	} else {
		UIFont *mainFont = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
		CGSize size = [s sizeWithFont:mainFont constrainedToSize:CGSizeMake(MAX_TEXT_WIDTH, CGFLOAT_MAX)
						lineBreakMode:UILineBreakModeWordWrap];
		rowHeight = size.height + Y_PADDING;
		if (rowHeight < 44.0f) rowHeight = 44.0f;
	}
	return rowHeight;
}


#pragma mark -
#pragma mark Accessibility

- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@", label];
}

@end

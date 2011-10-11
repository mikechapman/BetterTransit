//
//  BTStopCell.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTStopCell.h"
#import "Utility.h"

#define MAIN_FONT_SIZE 14
#define SECONDARY_FONT_SIZE 14

@implementation BTStopCell

@synthesize stop, iconImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		cellView.backgroundColor = [UIColor clearColor];
		self.stop = nil;
		self.iconImage = nil;
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the separator line
	
	if (self.showingDeleteConfirmation) {
		b.origin.x -= 24.0f;
	} else {
		b.origin.x += (editing) ? 4.0f : 0.0f;
	}
	
	[cellView setNeedsDisplay];
	
	[UIView beginAnimations:nil context:nil];
	cellView.frame = b;
	[UIView commitAnimations];
}

- (void)drawCellView:(CGRect)rect
{
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
	
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	} else {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
	}
	
	// Set the color for the main text items.
	[mainTextColor set];
	
	[stop.stopName drawInRect:CGRectMake(36, 10, 256, 20)
                     withFont:mainFont
                lineBreakMode:UILineBreakModeTailTruncation
                    alignment:UITextAlignmentLeft];
	
	// Set the color for the secondary text items.
	[secondaryTextColor set];
	
	NSString *s = [NSString stringWithFormat:@"Bus stop #%@", stop.stopCode];
	[s drawInRect:CGRectMake(36, 38, 150, 18)
		 withFont:secondaryFont
	lineBreakMode:UILineBreakModeTailTruncation
		alignment:UITextAlignmentLeft];
	
	if (self.editing) return;
	
	if (stop.distance > -1.0) {
		s = [Utility formattedStringForDistance:stop.distance];
		[s drawInRect:CGRectMake(192, 38, 100, 18) 
			 withFont:secondaryFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentRight];
	}
	
	// Draw the icon image
	CGSize imageSize = iconImage.size;
	[iconImage drawInRect:CGRectMake(6, (60-imageSize.height)/2.0, imageSize.width, imageSize.height)];
}

- (void)dealloc
{
	[stop release], stop = nil;
	[iconImage release], iconImage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Accessibility

- (NSString *)accessibilityLabel
{
	NSString *distance = [Utility formattedStringForDistance:stop.distance];
	return [NSString stringWithFormat:@"%@, Bus stop #%@, %@", stop.stopName, stop.stopCode, distance];
}

@end

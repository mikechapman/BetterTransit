//
//  FastScrollingCell.m
//  Showtime
//
//  Created by Yaogang Lian on 2/6/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "FastScrollingCell.h"

////////////////////////////////////////////////////////////

@interface FastScrollingCellView : UIView
@end

@implementation FastScrollingCellView

- (void)drawRect:(CGRect)rect
{
	[(FastScrollingCell *)[[self superview] superview] drawCellView:rect];
}

@end


////////////////////////////////////////////////////////////

@implementation FastScrollingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
		self.opaque = YES;
        cellView = [[FastScrollingCellView alloc] initWithFrame:self.contentView.bounds];
		cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		cellView.opaque = NO;
		cellView.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:cellView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)lit animated:(BOOL)animated
{
	if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
		[super setHighlighted:lit animated:animated];
		[cellView setNeedsDisplay];
	}
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[cellView setNeedsDisplay];
}

- (void)dealloc
{
	[cellView release], cellView = nil;
    [super dealloc];
}

- (void)drawCellView:(CGRect)rect
{
	// subclasses should implement this
}


#pragma mark -
#pragma mark Accessibility

- (BOOL)isAccessibilityElement
{
	return YES;
}

- (NSString *)accessibilityLabel
{
	// Subclass should overwrite this
	return @"";
}

- (UIAccessibilityTraits)accessibilityTraits
{
	return UIAccessibilityTraitStaticText;
}

@end

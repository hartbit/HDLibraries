//
//  HDPlaceholderTextView.m
//  HDLibraries
//
//  Created by Hart David on 09.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDPlaceholderTextView.h"
#import "UIView+HDAdditions.h"


@interface HDPlaceholderTextView ()

@property (nonatomic, retain) UILabel* placeholderLabel;

- (void)initialize;
- (void)textDidChange:(NSNotification*)notification;

@end


@implementation HDPlaceholderTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderLabel = _placeholderLabel;

#pragma mark - Lifecycle

- (id)init
{
	if ((self = [super init]))
	{
		[self initialize];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self initialize];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		[self initialize];
	}
	
	return self;
}

- (void)initialize
{
	[self setPlaceholder:@""];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (UILabel*)placeholderLabel
{
	CGFloat const kMargin = 8;
	
	if (_placeholderLabel == nil)
	{
		CGRect frame = CGRectMake(kMargin, kMargin, [self boundsWidth] - 2 * kMargin, 0);
		UILabel* placeholderLabel = [[UILabel alloc] initWithFrame:frame];
		[placeholderLabel setLineBreakMode:UILineBreakModeWordWrap];
		[placeholderLabel setNumberOfLines:0];
		[placeholderLabel setFont:[self font]];
		[placeholderLabel setBackgroundColor:[UIColor clearColor]];
		[placeholderLabel setTextColor:[UIColor lightGrayColor]];

		[self addSubview:placeholderLabel];
		[self setPlaceholderLabel:placeholderLabel];
	}
	
	return _placeholderLabel;
}

#pragma mark - Private Methods

- (void)textDidChange:(NSNotification*)notification
{
	if ([[self placeholder] length] == 0)
    {
		return;
	}

	BOOL isTextViewEmpty = [[self text] length] == 0;
	[[self placeholderLabel] setHidden:!isTextViewEmpty];
}

@end

//
//  HDPlaceholderTextView.m
//  HDLibraries
//
//  Created by Hart David on 09.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDPlaceholderTextView.h"
#import "UIView+HDAdditions.h"


CGFloat const kPlaceholderLabelMargin = 8;


@interface HDPlaceholderTextView ()

@property (nonatomic, retain) UILabel* placeholderLabel;

@end


@implementation HDPlaceholderTextView

#pragma mark - Lifecycle

- (id)init
{
	if (self = [super init]) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	if (self = [super initWithCoder:coder]) {
		[self initialize];
	}
	
	return self;
}

- (void)initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceholderLabel) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (NSString*)placeholder
{
	return [[self placeholderLabel] text];
}

- (void)setPlaceholder:(NSString*)placeholder
{	
	[[self placeholderLabel] setText:placeholder];
	
	CGFloat contrainedWidth = [self boundsWidth] - 2 * kPlaceholderLabelMargin;
	CGFloat contrainedHeight = [self boundsHeight] - 2 * kPlaceholderLabelMargin;
	CGSize contrainedSize = CGSizeMake(contrainedWidth, contrainedHeight);
	CGSize placeholderSize = [placeholder sizeWithFont:[self font] constrainedToSize:contrainedSize];
	[[self placeholderLabel] setFrameSize:placeholderSize];
}

- (UILabel*)placeholderLabel
{	
	if (!_placeholderLabel) {
		CGRect frame = CGRectMake(kPlaceholderLabelMargin, kPlaceholderLabelMargin, 0, 0);
		UILabel* placeholderLabel = [[UILabel alloc] initWithFrame:frame];
		[placeholderLabel setLineBreakMode:UILineBreakModeWordWrap];
		[placeholderLabel setNumberOfLines:0];
		[placeholderLabel setFont:[self font]];
		[placeholderLabel setBackgroundColor:[UIColor clearColor]];
		[placeholderLabel setTextColor:[UIColor lightGrayColor]];

		[self addSubview:placeholderLabel];
		[self setPlaceholderLabel:placeholderLabel];
		
		[self updatePlaceholderLabel];
	}
	
	return _placeholderLabel;
}

#pragma mark - Private Methods

- (void)updatePlaceholderLabel
{
	BOOL isTextViewEmpty = [[self text] length] == 0;
	[[self placeholderLabel] setHidden:!isTextViewEmpty];
}

@end

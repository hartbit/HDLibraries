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
	return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString*)placeholder
{	
	self.placeholderLabel.text = placeholder;
	
	CGFloat contrainedWidth = self.boundsWidth - 2 * kPlaceholderLabelMargin;
	CGFloat contrainedHeight = self.boundsHeight - 2 * kPlaceholderLabelMargin;
	CGSize contrainedSize = CGSizeMake(contrainedWidth, contrainedHeight);
	CGSize placeholderSize = [placeholder sizeWithFont:self.font constrainedToSize:contrainedSize];
	self.placeholderLabel.frameSize = placeholderSize;
}

- (UILabel*)placeholderLabel
{	
	if (_placeholderLabel == nil) {
		CGRect frame = CGRectMake(kPlaceholderLabelMargin, kPlaceholderLabelMargin, 0, 0);
		UILabel* placeholderLabel = [[UILabel alloc] initWithFrame:frame];
		placeholderLabel.lineBreakMode = UILineBreakModeWordWrap;
		placeholderLabel.numberOfLines = 0;
		placeholderLabel.font = self.font;
		placeholderLabel.backgroundColor = [UIColor clearColor];
		placeholderLabel.textColor = [UIColor lightGrayColor];

		[self addSubview:placeholderLabel];
		self.placeholderLabel = placeholderLabel;
		
		[self updatePlaceholderLabel];
	}
	
	return _placeholderLabel;
}

#pragma mark - Private Methods

- (void)updatePlaceholderLabel
{
	self.placeholderLabel.hidden = [self.text length] != 0;
}

@end

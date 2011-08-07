//
//  HDMatrixControl.m
//  HDLibraries
//
//  Created by David Hart on 05.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDMatrixControl.h"
#import "UIView+HDAdditions.h"


@interface HDMatrixControl ()

@property (nonatomic, strong) NSMutableArray* buttons;

- (void)initialize;
- (void)updateButtons;
- (void)updateButtonCount;
- (void)updateButtonProperties;
- (UIButton*)buttonAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)selectButton:(UIButton*)selectedButton;
- (void)touchDownAction:(UIButton*)button;
- (void)touchUpInsideAction:(UIButton*)button;
- (void)otherTouchesAction:(UIButton*)button;

@end


@implementation HDMatrixControl

@synthesize numberOfColumns = _numberOfColumns;
@synthesize numberOfRows = _numberOfRows;
@synthesize buttons = _buttons;

#pragma mark - Lifecycle

- (id)init
{
	if ((self = [super init]))
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

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self initialize];
	}

	return self;
}

- (void)initialize
{
	[self setButtons:[NSMutableArray arrayWithCapacity:4]];
	[self setNumberOfColumns:2];
	[self setNumberOfRows:2];
}

#pragma mark - Properties

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns
{
	if (numberOfColumns != _numberOfColumns)
	{
		_numberOfColumns = numberOfColumns;
		[self updateButtons];
	}
}

- (void)setNumberOfRows:(NSUInteger)numberOfRows
{
	if (numberOfRows != _numberOfRows)
	{
		_numberOfRows = numberOfRows;
		[self updateButtons];
	}
}

#pragma mark - Public Methods

- (void)setTitle:(NSString*)title forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	[[self buttonAtColumn:column row:row] setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	[[self buttonAtColumn:column row:row] setImage:image forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (void)updateButtons
{
	[self updateButtonCount];
	[self updateButtonProperties];
}

- (void)updateButtonCount
{
	NSUInteger buttonCount = [self numberOfColumns] * [self numberOfRows];
	
	if (buttonCount < [[self buttons] count])
	{
		NSUInteger numberToRemove = [[self buttons] count] - buttonCount;
		
		for (NSUInteger index = 0; index < numberToRemove; index++)
		{
			UIButton* lastButton = [[self buttons] lastObject];
			[lastButton removeFromSuperview];
			[[self buttons] removeLastObject];
		}
	}
	else if (buttonCount > [[self buttons] count])
	{
		NSUInteger numberToAdd = buttonCount - [[self buttons] count];
		
		for (NSUInteger index = 0; index < numberToAdd; index++)
		{
			UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[button setAdjustsImageWhenHighlighted:YES];
			[button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
			[button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
		
			[[self buttons] addObject:button];
			[self addSubview:button];
		}
	}
}

- (void)updateButtonProperties
{
	CGFloat buttonWidth = [self boundsWidth] / [self numberOfColumns];
	CGFloat buttonHeight = [self boundsHeight] / [self numberOfRows];
	
	for (NSUInteger index = 0; index < [[self buttons] count]; index++)
	{
		NSUInteger column = index % [self numberOfColumns];
		NSUInteger row = index / [self numberOfRows];
		CGFloat buttonX = column * buttonWidth;
		CGFloat buttonY = row * buttonHeight;
		CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
		
		UIButton* button = [[self buttons] objectAtIndex:index];
		[button setFrame:buttonFrame];
	}
	
	if ([[self buttons] count] > 0)
	{
		[self selectButton:[[self buttons] objectAtIndex:0]];
	}
}

- (id)buttonAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	NSUInteger index = row * [self numberOfColumns] + column;
	return [[self buttons] objectAtIndex:index];
}

- (void)selectButton:(UIButton*)selectedButton
{
	for (UIButton* button in [self buttons])
	{
		[button setSelected:NO];
		[button setHighlighted:NO];
	}
	
	[selectedButton setSelected:YES];
	[selectedButton setHighlighted:YES];
}

- (void)touchDownAction:(UIButton*)button
{
	[self selectButton:button];
}

- (void)touchUpInsideAction:(UIButton*)button
{
	[self selectButton:button];
}

- (void)otherTouchesAction:(UIButton*)button
{
	[self selectButton:button];
}

@end

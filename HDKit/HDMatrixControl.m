//
//  HDMatrixControl.m
//  HDLibraries
//
//  Created by David Hart on 05.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDMatrixControl.h"
#import "UIView+HDAdditions.h"
#import "HDAssert.h"


@interface HDMatrixControl ()

@property (nonatomic, strong) NSMutableArray* buttons;
@property (nonatomic, strong) NSMutableArray* dividers;
@property (nonatomic, strong) UIImage* normalBackgroundImage;
@property (nonatomic, strong) UIImage* highlightedBackgroundImage;
@property (nonatomic, strong) UIImage* disabledBackgroundImage;
@property (nonatomic, strong) UIImage* selectedBackgroundImage;
@property (nonatomic, assign, readonly) CGSize buttonSize;

- (void)initialize;
- (void)updateButtonCount;
- (void)updateButtonFrames;
- (void)updateButtonBackgroundImages;
- (void)updateDividerCount;
- (void)updateVerticalDividers;
- (void)updateHorizontalDividers;
- (UIButton*)buttonAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (UIImage*)backgroundImageFromImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)selectButton:(UIButton*)selectedButton;
- (void)touchDownAction:(UIButton*)button;
- (void)touchUpInsideAction:(UIButton*)button;
- (void)otherTouchesAction:(UIButton*)button;

@end


@implementation HDMatrixControl

@synthesize numberOfColumns = _numberOfColumns;
@synthesize numberOfRows = _numberOfRows;
@synthesize verticalDividerImage = _verticalDividerImage;
@synthesize horizontalDividerImage = _horizontalDividerImage;
@synthesize buttons = _buttons;
@synthesize dividers = _dividers;
@synthesize normalBackgroundImage = _normalBackgroundImage;
@synthesize highlightedBackgroundImage = _highlightedBackgroundImage;
@synthesize disabledBackgroundImage = _disabledBackgroundImage;
@synthesize selectedBackgroundImage = _selectedBackgroundImage;

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
	[self setDividers:[NSMutableArray arrayWithCapacity:2]];
	[self setNumberOfColumns:2];
	[self setNumberOfRows:2];
}

#pragma mark - Properties

- (void)setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	[self updateButtonFrames];
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns
{
	if (numberOfColumns != _numberOfColumns)
	{
		_numberOfColumns = numberOfColumns;
		[self updateButtonCount];
		[self updateDividerCount];
	}
}

- (void)setNumberOfRows:(NSUInteger)numberOfRows
{
	if (numberOfRows != _numberOfRows)
	{
		_numberOfRows = numberOfRows;
		[self updateButtonCount];
		[self updateDividerCount];
	}
}

- (void)setVerticalDividerImage:(UIImage*)verticalDividerImage
{
	if (verticalDividerImage != _verticalDividerImage)
	{
		_verticalDividerImage = verticalDividerImage;
		[self updateVerticalDividers];
	}
}

- (void)setHorizontalDividerImage:(UIImage*)horizontalDividerImage
{
	if (horizontalDividerImage != _horizontalDividerImage)
	{
		_horizontalDividerImage = horizontalDividerImage;
		[self updateHorizontalDividers];
	}
}

- (CGSize)buttonSize
{
	return CGSizeMake([self boundsWidth] / [self numberOfColumns], [self boundsHeight] / [self numberOfRows]);
}

#pragma mark - Public Methods

- (NSString*)titleForSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	return [[self buttonAtColumn:column row:row] titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString*)title forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	[[self buttonAtColumn:column row:row] setTitle:title forState:UIControlStateNormal];
}

- (UIImage*)imageForSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	return [[self buttonAtColumn:column row:row] imageForState:UIControlStateNormal];
}

- (void)setImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	[[self buttonAtColumn:column row:row] setImage:image forState:UIControlStateNormal];
}

- (UIImage*)backgroundImageForState:(UIControlState)state
{
	switch (state)
	{
		case UIControlStateNormal: return [self normalBackgroundImage];
		case UIControlStateHighlighted: return [self highlightedBackgroundImage];
		case UIControlStateDisabled: return [self disabledBackgroundImage];
		case UIControlStateSelected: return [self selectedBackgroundImage];
		default: HDFail(@"Invalid control state.", HDFailureLevelError); return nil;
	}
}

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state
{
	switch (state)
	{
		case UIControlStateNormal: [self setNormalBackgroundImage:image]; break;
		case UIControlStateHighlighted: [self setHighlightedBackgroundImage:image]; break;
		case UIControlStateDisabled: [self setDisabledBackgroundImage:image]; break;
		case UIControlStateSelected: [self setSelectedBackgroundImage:image]; break;
		default: HDFail(@"Invalid control state.", HDFailureLevelError); return;
	}
	
	[self updateButtonBackgroundImages];
}

#pragma mark - Private Methods

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
			UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setAdjustsImageWhenHighlighted:NO];
			[button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
			[button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
			[button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
		
			[[self buttons] addObject:button];
			[self addSubview:button];
		}
	}
	
	if ([[self buttons] count] > 0)
	{
		[self selectButton:[[self buttons] objectAtIndex:0]];
	}
	
	[self updateButtonFrames];
	[self updateButtonBackgroundImages];
}

- (void)updateButtonFrames
{
	CGSize buttonSize = [self buttonSize];
	
	for (NSUInteger row = 0; row < [self numberOfRows]; row++)
	{
		for (NSUInteger column = 0; column < [self numberOfColumns]; column++)
		{
			CGFloat buttonX = column * buttonSize.width;
			CGFloat buttonY = row * buttonSize.height;
			CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonSize.width, buttonSize.height);
		
			UIButton* button = [self buttonAtColumn:column row:row];
			[button setFrame:buttonFrame];
		}
	}
}

- (void)updateButtonBackgroundImages
{
	for (NSUInteger row = 0; row < [self numberOfRows]; row++)
	{
		for (NSUInteger column = 0; column < [self numberOfColumns]; column++)
		{
			UIButton* button = [self buttonAtColumn:column row:row];
			
			UIImage* normalImage = [self backgroundImageFromImage:[self normalBackgroundImage] forSegmentAtColumn:column row:row];
			[button setBackgroundImage:normalImage forState:UIControlStateNormal];
			
			UIImage* highlightedImage = [self backgroundImageFromImage:[self highlightedBackgroundImage] forSegmentAtColumn:column row:row];
			[button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
			
			UIImage* disabledImage = [self backgroundImageFromImage:[self disabledBackgroundImage] forSegmentAtColumn:column row:row];
			[button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
			
			UIImage* selectedImage = [self backgroundImageFromImage:[self selectedBackgroundImage] forSegmentAtColumn:column row:row];
			[button setBackgroundImage:selectedImage forState:UIControlStateSelected];
		}
	}
}

- (void)updateDividerCount
{
	NSUInteger dividerCount = ([self numberOfColumns] - 1) + ([self numberOfRows] - 1);
	
	if (([self numberOfColumns] == 0) || ([self numberOfRows] == 0))
	{
		dividerCount = 0;
	}
	
	if (dividerCount < [[self dividers] count])
	{
		NSUInteger numberToRemove = [[self dividers] count] - dividerCount;
		
		for (NSUInteger index = 0; index < numberToRemove; index++)
		{
			UIImageView* lastDivider = [[self dividers] lastObject];
			[lastDivider removeFromSuperview];
			[[self dividers] removeLastObject];
		}
	}
	else if (dividerCount > [[self dividers] count])
	{
		NSUInteger numberToAdd = dividerCount - [[self dividers] count];
		
		for (NSUInteger index = 0; index < numberToAdd; index++)
		{
			UIImageView* divider = [[UIImageView alloc] initWithFrame:CGRectZero];
			[[self dividers] addObject:divider];
			[self addSubview:divider];
		}
	}
	
	[self updateVerticalDividers];
	[self updateHorizontalDividers];
}

- (void)updateVerticalDividers
{
	if ([[self dividers] count] == 0)
	{
		return;
	}
	
	CGFloat dividerWidth = [[self verticalDividerImage] size].width;
	NSUInteger dividerOriginX = -dividerWidth / 2;
	CGRect dividerFrame = CGRectMake(dividerOriginX, 0, dividerWidth, [self boundsHeight]);
	
	for (NSUInteger column = 0; column < [self numberOfColumns] - 1; column++)
	{
		UIImageView* verticalDivider = [[self dividers] objectAtIndex:column];
		dividerFrame.origin.x += [self buttonSize].width;

		[verticalDivider setFrame:dividerFrame];
		[verticalDivider setImage:[self verticalDividerImage]];
		[self bringSubviewToFront:verticalDivider];
	}
}
		 
- (void)updateHorizontalDividers
{
	if ([[self dividers] count] == 0)
	{
		return;
	}
	
	CGFloat dividerHeight = [[self verticalDividerImage] size].width;
	NSUInteger dividerOriginY = -dividerHeight / 2;
	CGRect dividerFrame = CGRectMake(0, dividerOriginY, [self boundsWidth], dividerHeight);
	
	for (NSUInteger row = 0; row < [self numberOfRows] - 1; row++)
	{
		NSUInteger dividerIndex = [self numberOfColumns] - 1 + row;
		UIImageView* horizontalDivider = [[self dividers] objectAtIndex:dividerIndex];
		dividerFrame.origin.y += [self buttonSize].height;
		
		[horizontalDivider setFrame:dividerFrame];
		[horizontalDivider setImage:[self horizontalDividerImage]];
		[self bringSubviewToFront:horizontalDivider];
	}
}

- (id)buttonAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	NSUInteger index = row * [self numberOfColumns] + column;
	return [[self buttons] objectAtIndex:index];
}

- (UIImage*)backgroundImageFromImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row
{
	CGSize buttonSize = [self buttonSize];
	UIGraphicsBeginImageContextWithOptions(buttonSize, NO, 0.0);
	
	UIEdgeInsets capInsets = [image capInsets];
	CGFloat leftWithLeftCap = 0;
	CGFloat leftWithoutLeftCap = -capInsets.left;
	CGFloat topWithTopCap = 0;
	CGFloat topWithoutTopCap = -capInsets.top;
	CGFloat rightWithRightCap = buttonSize.width;
	CGFloat rightWithoutRightCap = buttonSize.width + capInsets.right;
	CGFloat bottomWithBottomCap = buttonSize.height;
	CGFloat bottomWithoutBottomCap = buttonSize.height + capInsets.bottom;
	
	NSUInteger maxColumn = [self numberOfColumns] - 1;
	NSUInteger maxRow = [self numberOfRows] - 1;
	CGRect drawRect = CGRectZero;
	
	if ((column == 0) && (row == 0)) // Top Left
	{
		drawRect = CGRectMakeWithEdges(leftWithLeftCap, topWithTopCap, rightWithoutRightCap, bottomWithoutBottomCap);
	}
	else if ((column == maxColumn) && (row == 0)) // Top Right
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithTopCap, rightWithRightCap, bottomWithoutBottomCap);
	}
	else if ((column == 0) && (row == maxRow)) // Bottom Left
	{
		drawRect = CGRectMakeWithEdges(leftWithLeftCap, topWithoutTopCap, rightWithoutRightCap, bottomWithBottomCap);
	}
	else if ((column == maxColumn) && (row == maxRow)) // Bottom Right
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithoutTopCap, rightWithRightCap, bottomWithBottomCap);
	}
	else if (row == 0) // Middle Top
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithTopCap, rightWithoutRightCap, bottomWithoutBottomCap);
	}
	else if (row == maxRow) // Middle Bottom
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithoutTopCap, rightWithoutRightCap, bottomWithBottomCap);
	}
	else if (column == 0) // Middle Left
	{
		drawRect = CGRectMakeWithEdges(leftWithLeftCap, topWithoutTopCap, rightWithoutRightCap, bottomWithoutBottomCap);
	}
	else if (column == maxColumn) // Middle Right
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithoutTopCap, rightWithRightCap, bottomWithoutBottomCap);
	}
	else // Middle
	{
		drawRect = CGRectMakeWithEdges(leftWithoutLeftCap, topWithoutTopCap, rightWithoutRightCap, bottomWithoutBottomCap);
	}
	
	[image drawInRect:drawRect];
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

- (void)selectButton:(UIButton*)selectedButton
{
	for (UIButton* button in [self buttons])
	{
		[button setHighlighted:NO];
		[button setSelected:NO];
	}
	
	[selectedButton setSelected:YES];
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

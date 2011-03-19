//
//  HDDraggableButton.m
//  HDFoundation
//
//  Created by David Hart on 5/10/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDraggableButton.h"
#import "UIView+Geometry.h"
#import "HDFunctions.h"


@interface HDDraggableButton ()

@property (nonatomic, assign) CGPoint startOrigin;

- (void)initialize;

@end


@implementation HDDraggableButton

@synthesize delegate;
@synthesize targetView;
@synthesize dragEnabled;
@synthesize startOrigin;
@synthesize speed;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	self = [super initWithCoder:coder];
	if (!self) return nil;

	[self initialize];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;

	[self initialize];
	
	return self;
}

- (void)initialize
{
	[self setDragEnabled:YES];
	[self setStartOrigin:[self frameOrigin]];
	[self setSpeed:1000.0f];
}

#pragma mark - Public Methods

- (void)returnToStart
{	
	NSTimeInterval duration = CGPointDistance([self frameOrigin], [self startOrigin]) / [self speed];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:duration];
	
	[self setFrameOrigin:[self startOrigin]];
	
	[UIView commitAnimations];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
	[super touchesBegan:touches withEvent:event];

	if ([self dragEnabled] && [[self delegate] respondsToSelector:@selector(draggableButtonWillDrag:)])
	{
		[[self delegate] draggableButtonWillDrag:self];
	}
} 

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{
	[super touchesMoved:touches withEvent:event];
	
	if ([self dragEnabled])
	{
		UITouch* touch = [touches anyObject];
		CGPoint currentLocation = [touch locationInView:[self superview]];
		CGPoint previousLocation = [touch previousLocationInView:[self superview]];
		
		CGPoint deltaOrigin = CGPointSubstract(currentLocation, previousLocation);
		[self setFrameOrigin:CGPointAdd([self frameOrigin], deltaOrigin)];
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
	
	if ([self dragEnabled])
	{
		CGPoint centerInTarget = [[self superview] convertPoint:[self center] toView:[[self targetView] superview]];
		BOOL onTarget = [self targetView] && CGRectContainsPoint([[self targetView] frame], centerInTarget);
		
		if (!onTarget)
		{
			[self returnToStart];
		}
		
		if ([[self delegate] respondsToSelector:@selector(draggableButton:didDropOnTarget:)])
		{
			[[self delegate] draggableButton:self didDropOnTarget:onTarget];
		}
	}
}

@end

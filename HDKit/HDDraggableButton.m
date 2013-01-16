//
//  HDDraggableButton.m
//  HDLibraries
//
//  Created by David Hart on 5/10/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDraggableButton.h"
#import "UIView+HDAdditions.h"
#import "HDFoundation.h"
#import "HDKitFunctions.h"


@implementation HDDraggableButton

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	if (self = [super initWithCoder:coder]) {
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

- (void)initialize
{
	self.dragEnabled = YES;
	self.startOrigin = self.frameOrigin;
	self.speed = 1000.0f;
}

#pragma mark - Public Methods

- (void)returnToStart
{
	[self returnToStartAnimated:YES];
}

- (void)returnToStartAnimated:(BOOL)animated
{
	if (animated) {
		NSTimeInterval duration = CGPointDistance(self.frameOrigin, self.startOrigin) / self.speed;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didReturnToStart)];
	}
	
	self.frameOrigin = self.startOrigin;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)willDrag
{
	if (self.dragEnabled && [self.delegate respondsToSelector:@selector(draggableButtonWillDrag:)]) {
		[self.delegate draggableButtonWillDrag:self];
	}
}

- (void)didDropOnTarget:(UIView*)target
{
	if (target == nil) {
		[self returnToStart];
	} else {
		[self roundFrame];
	}
	
	if ([self.delegate respondsToSelector:@selector(draggableButton:didDropOnTarget:)]) {
		[self.delegate draggableButton:self didDropOnTarget:target];
	}
}

- (void)didReturnToStart
{
	if ([self.delegate respondsToSelector:@selector(draggableButtonDidReturnToStart:)]) {
		[self.delegate draggableButtonDidReturnToStart:self];
	}
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesBegan:touches withEvent:event];
	
	[self willDrag];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesMoved:touches withEvent:event];
	
	if (self.dragEnabled) {
		UITouch* touch = [touches anyObject];
		CGPoint currentLocation = [touch locationInView:self.superview];
		CGPoint previousLocation = [touch previousLocationInView:self.superview];
		
		CGPoint deltaOrigin = CGPointSubstract(currentLocation, previousLocation);
		self.frameOrigin = CGPointAdd(self.frameOrigin, deltaOrigin);
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
	
	if (self.dragEnabled) {
		for (UIView* target in self.targetViews) {
			CGPoint centerInTarget = [self.superview convertPoint:self.center toView:target.superview];
			BOOL onTarget = CGRectContainsPoint(target.frame, centerInTarget);
			
			if (onTarget) {
				[self didDropOnTarget:target];
				return;
			}
		}
		
		[self didDropOnTarget:nil];
	}
}

@end

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


@interface HDDraggableButton ()

@property (nonatomic, getter = isDragging) BOOL dragging;
@property (nonatomic) CGRect savedFrame;

@end


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
	[self saveFrame];
}

#pragma mark - Public Methods

- (void)saveFrame
{
	self.savedFrame = self.frame;
}

- (void)restoreSavedFrameAnimated:(BOOL)animated completion:(void (^)(void))completion
{
	NSTimeInterval duration = animated ? 0.25 : 0;
	[UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 self.frame = self.savedFrame;
					 } completion:^(BOOL finished) {
						 if (completion != NULL) {
							 completion();
						 }
					 }];
}

- (void)willDrag
{
	if ([self.delegate respondsToSelector:@selector(draggableButtonWillDrag:)]) {
		[self.delegate draggableButtonWillDrag:self];
	}
}

- (void)didDrop
{
	if ([self.delegate respondsToSelector:@selector(draggableButtonDidDrop:)]) {
		[self.delegate draggableButtonDidDrop:self];
	}
}

- (void)didCancelDrag
{
	if ([self.delegate respondsToSelector:@selector(draggableButtonDidCancelDrag:)]) {
		[self.delegate draggableButtonDidCancelDrag:self];
	}
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesBegan:touches withEvent:event];
	
	if (self.dragEnabled) {
		[self willDrag];
		self.dragging = YES;
	}
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesMoved:touches withEvent:event];
	
	if (self.dragEnabled) {
		UITouch* touch = [touches anyObject];
		CGPoint currentLocation = [touch locationInView:[self superview]];
		CGPoint previousLocation = [touch previousLocationInView:[self superview]];
		CGPoint deltaOrigin = CGPointSubstract(currentLocation, previousLocation);
		self.frameOrigin = CGPointAdd(self.frameOrigin, deltaOrigin);
	}
	
	self.dragging = self.dragEnabled;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
	
	self.dragging = NO;
	
	if (self.dragEnabled) {
		[self didDrop];
	}
}

@end

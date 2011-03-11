//
//  HDAnimatedImage.m
//  HDFoundation
//
//  Created by David Hart on 11/9/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAnimatedImage.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Loading.h"


@interface HDAnimatedImage ()

@property (nonatomic, assign) CADisplayLink* displayLink;
@property (nonatomic, assign) NSUInteger currentFrame;

- (UIImage*)imageWithIndex:(NSUInteger)index;
- (void)createImages;
- (void)createDisplayLink;
- (void)updateAnimation:(CADisplayLink*)sender;

@end


@implementation HDAnimatedImage

@synthesize animationName = _animationName;
@synthesize stopsOnLastFrame = _stopsOnLastFrame;
@synthesize delegate = _delegate;
@synthesize displayLink = _displayLink;
@synthesize currentFrame =_currentFrame;

#pragma mark - Properties

- (void)setAnimationName:(NSString*)animationName
{
	if ([animationName isEqualToString:_animationName]) return;
	
	[_animationName release];
	
	if (animationName == nil) return;
	
	_animationName = [animationName copy];
	
	[self setImage:[self imageWithIndex:0]];
}

#pragma mark - UIImageView Methods

- (void)startAnimating
{
	if ([self isAnimating]) return;
	
	[self setCurrentFrame:0];
	[self createImages];
	[self createDisplayLink];
}

- (void)stopAnimating
{
	if (![self isAnimating]) return;
	
	[_displayLink invalidate];
	
	[self setDisplayLink:nil];
	[self setAnimationImages:nil];
	
	if ([_delegate respondsToSelector:@selector(animatedImageDidFinishAnimating:)])
	{
		[_delegate animatedImageDidFinishAnimating:self];
	}
}

- (BOOL)isAnimating
{
	return _displayLink != nil;
}

#pragma mark - Private Methods

- (UIImage*)imageWithIndex:(NSUInteger)index
{
	NSString* imageName = [_animationName stringByAppendingFormat:@"%i", index];
	return [UIImage imageNamed:imageName cached:NO];
}

- (void)createImages
{
	if ([self animationImages]) return;
	
	NSAssert(_animationName, @"No animationImages and no animationName provided.");
	
	NSMutableArray* images = [[NSMutableArray alloc] init];
	
	NSUInteger index = 0;
	UIImage* image = [self imageWithIndex:index];
	
	while (image != nil)
	{
		[images addObject:image];
		
		index++;
		image = [self imageWithIndex:index];
	}
	
	[self setAnimationImages:images];
	[images release];
}

- (void)createDisplayLink
{
	CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimation:)];
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	[self setDisplayLink:displayLink];
}

- (void)updateAnimation:(CADisplayLink*)sender
{
	if (_currentFrame == 0)
	{
		NSTimeInterval animationPeriod = [self animationDuration] / [[self animationImages] count];
		[_displayLink setFrameInterval:(NSInteger)(animationPeriod / [_displayLink duration])];
	}
	else 
	{
		_currentFrame++;
		
		if (_currentFrame == [[self animationImages] count])
		{
			NSInteger animationRepeatCount = [self animationRepeatCount];
			
			if (animationRepeatCount == 1)
			{
				[self stopAnimating];
				return;
			}
			else
			{
				if (animationRepeatCount > 1)
				{
					[self setAnimationRepeatCount:animationRepeatCount - 1];
				}
				
				_currentFrame = 0;
			}
		}
		
		[self setImage:[[self animationImages] objectAtIndex:_currentFrame]];	
	}
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self stopAnimating];
	[self setAnimationName:nil];
	
	[super dealloc];
}

@end

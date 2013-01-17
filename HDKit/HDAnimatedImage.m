//
//  HDAnimatedImage.m
//  HDLibraries
//
//  Created by David Hart on 11/9/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAnimatedImage.h"
#import "UIImage+HDAdditions.h"
#import "NimbusCore.h"


@interface HDAnimatedImage ()

@property (nonatomic, strong) UIImage* staticImage;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, assign) NSUInteger nextIndex;

@end


@implementation HDAnimatedImage

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	if (self = [super initWithCoder:coder]) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithAnimationName:(NSString*)animationName
{
	NSString* imageName = [animationName stringByAppendingString:@"0"];
	UIImage* image = [UIImage imageWithName:imageName cached:NO];
	
	if (self = [super initWithImage:image]) {
		[self initialize];
		[self setAnimationName:animationName];
	}
	
	return self;
}

- (void)initialize
{
	[self setFramesPerSecond:12];
	[self setAnimationRepeatCount:1];
}

#pragma mark - Properties

- (void)setAnimationName:(NSString*)animationName
{
	if (![animationName isEqualToString:_animationName]) {
		_animationName = [animationName copy];
		[self setStaticImage:nil];
		[self setImage:nil];
		[self setImages:nil];
		
		if (animationName) {
			NSString* staticImageName = [self nameFromImageAtIndex:0];
			UIImage* staticImage = [UIImage imageWithName:staticImageName cached:NO];
			[self setStaticImage:staticImage];
			[self setImage:staticImage];
		}
	}
}

- (NSTimeInterval)animationDuration
{
	return (NSTimeInterval)[[self images] count] / [self framesPerSecond];
}

- (NSArray*)images
{
	if (!_images) {
		NSMutableArray* images = [NSMutableArray array];
		[self setImages:images];
		
		NSUInteger index = 1;
		
		while (YES) {
			NSString* imageName = [self nameFromImageAtIndex:index];
			UIImage* image = [UIImage imageWithName:imageName cached:NO];
			
			if (!image) {
				break;
			}
			
			[images addObject:image];
			index++;
		}
	}
	
	return _images;
}

- (BOOL)isPlaying
{
	return [self timer] != nil;
}

#pragma mark - Public Methods

- (void)play
{
	if ([self isPlaying]) {
		return;
	}
	
	NIDASSERT([self superview]);
	
	[self setNextIndex:0];
	
	NSTimeInterval timeInterval = 1.0f / [self framesPerSecond];
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
	[self setTimer:timer];
}

- (void)stop
{
	if (![self isPlaying]) {
		return;
	}
	
	[[self timer] invalidate];
	[self setTimer:nil];
	
	if ([self stopsOnLastFrame]) {
		[self setStaticImage:[[self images] lastObject]];
	}
	
	[self setImage:[self staticImage]];
	[self setImages:nil];
}

#pragma mark - UIView Methods

- (void)didMoveToSuperview
{
	if (![self superview]) {
		[self stop];
	}
}

#pragma mark - Private Methods

- (NSString*)nameFromImageAtIndex:(NSUInteger)index
{
	NIDASSERT([self animationName]);
	return [[self animationName] stringByAppendingFormat:@"%i", index];
}

- (void)changeFrame
{
	if ([self nextIndex] >= [[self images] count]) {
		[self setAnimationRepeatCount:[self animationRepeatCount] - 1];
		
		if ([self animationRepeatCount] == 0) {
			[self stop];
			[self setAnimationRepeatCount:1];
			
			if ([[self delegate] respondsToSelector:@selector(animatedImageDidFinishPlaying:)]) {
				[[self delegate] animatedImageDidFinishPlaying:self];
			}
			
			return;
		} else {
			[self setNextIndex:0];
		}
	}
	
	UIImage* nextImage = [[self images] objectAtIndex:[self nextIndex]];
	[self setImage:nextImage];
	[self setNextIndex:[self nextIndex] + 1];
}

#pragma mark - Memory Management

- (void)dealloc
{
	if ([self isPlaying]) {
		[self stop];
	}
	
	[self setDelegate:nil];
	[self setAnimationName:nil];
	
}

@end

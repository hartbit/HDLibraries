//
//  HDAnimatedImage.m
//  HDLibraries
//
//  Created by David Hart on 11/9/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAnimatedImage.h"
#import "UIImage+HDLoading.h"
#import "HDFoundation.h"


@interface HDAnimatedImage ()

@property (nonatomic, retain) UIImage* staticImage;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, retain) NSMutableArray* images;
@property (nonatomic, assign) NSUInteger nextIndex;

- (void)initialize;
- (NSString*)nameFromImageAtIndex:(NSUInteger)index;
- (void)createImages;
- (void)changeFrame;

@end


@implementation HDAnimatedImage

@synthesize animationName = _animationName;
@synthesize framesPerSecond = _framesPerSecond;
@synthesize stopsOnLastFrame = _stopsOnLastFrame;
@synthesize delegate = _delegate;
@synthesize staticImage = _staticImage;
@synthesize timer = _timer;
@synthesize images = _images;
@synthesize nextIndex = _nextIndex;

#pragma mark - Initialization

#pragma mark - Initialization

- (id) initWithCoder:(NSCoder*)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		[self initialize];
	}
	
	return self;
}

- (id)initWithAnimationName:(NSString*)animationName
{
	NSString* imageName = [animationName stringByAppendingString:@"0"];
	UIImage* image = [UIImage imageWithName:imageName cached:NO];
	
	if ((self = [super initWithImage:image]))
	{
		[self initialize];
		[self setAnimationName:animationName];
	}
	
	return self;
}

- (void)initialize
{
	[self setFramesPerSecond:12];
}

#pragma mark - Properties

- (void)setAnimationName:(NSString*)animationName
{
	if ([animationName isEqualToString:_animationName])
	{
		return;
	}
	
	[_animationName release];
		
	if (animationName == nil)
	{
		return;
	}
		
	_animationName = [animationName copy];
		
	NSString* staticImageName = [self nameFromImageAtIndex:0];
	UIImage* staticImage = [UIImage imageWithName:staticImageName cached:NO];
		
	[self setStaticImage:staticImage];
	[self setImage:staticImage];
}

- (BOOL)isPlaying
{
	return [self timer] != nil;
}

#pragma mark - Public Methods

- (void)play
{
	if ([self isPlaying])
	{
		return;
	}
	
	HDCheck(isObjectNotNil([self superview]), HDFailureLevelInfo, return);
	HDCheck(isObjectNotNil([self animationName]), HDFailureLevelInfo, return);
	
	[self createImages];
	[self setNextIndex:0];
	
	NSTimeInterval timeInterval = 1.0f / [self framesPerSecond];
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
	[self setTimer:timer];
}

- (void)stop
{
	if (![self isPlaying])
	{
		return;
	}
	
	[[self timer] invalidate];
	[self setTimer:nil];
	
	if ([self stopsOnLastFrame])
	{
		[self setStaticImage:[[self images] lastObject]];
	}
	
	[self setImage:[self staticImage]];
	[self setImages:nil];
}

#pragma mark - UIView Methods

- (void)didMoveToSuperview
{
	if ([self superview] == nil)
	{
		[self stop];
	}
}

#pragma mark - Private Methods

- (NSString*)nameFromImageAtIndex:(NSUInteger)index
{
	return [[self animationName] stringByAppendingFormat:@"%i", index];
}

- (void)createImages
{
	HDAssert(isObjectNil([self images]), HDFailureLevelWarning);
	
	NSMutableArray* images = [NSMutableArray array];
	NSUInteger index = 1;
	
	while (YES)
	{
		NSString* imageName = [self nameFromImageAtIndex:index];
		UIImage* image = [UIImage imageWithName:imageName cached:NO];
		
		if (!image)
		{
			break;
		}
		
		[images addObject:image];
		index++;
	}
	
	[self setImages:images];
}

- (void)changeFrame
{	
	if ([self nextIndex] < [[self images] count])
	{
		UIImage* nextImage = [[self images] objectAtIndex:[self nextIndex]];
		[self setImage:nextImage];
		[self setNextIndex:[self nextIndex] + 1];
	}
	else
	{
		[self stop];
		
		if ([[self delegate] respondsToSelector:@selector(animatedImageDidFinishPlaying:)])
		{
			[[self delegate] animatedImageDidFinishPlaying:self];
		}
	}
}

#pragma mark - Memory Management

- (void)dealloc
{	
	if ([self isPlaying])
	{
		[self stop];
	}
	
	[self setDelegate:nil];
	[self setStaticImage:nil];
	[self setAnimationName:nil];
	
	[super dealloc];
}

@end

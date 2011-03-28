//
//  HDAnimatedImage.m
//  HDLibraries
//
//  Created by David Hart on 11/9/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAnimatedImage.h"
#import "UIImage+Loading.h"


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
	self = [super initWithCoder:coder];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (id)initWithAnimationName:(NSString*)animationName
{
	NSString* imageName = [animationName stringByAppendingString:@"0"];
	UIImage* image = [UIImage imageNamed:imageName cached:NO];
	
	self = [super initWithImage:image];
	if (!self) return nil;
	
	[self initialize];
	[self setAnimationName:animationName];
	
	return self;
}

- (void)initialize
{
	[self setFramesPerSecond:12];
}

#pragma mark - Properties

- (void)setAnimationName:(NSString*)animationName
{
	if ([animationName isEqualToString:_animationName]) return;
	
	[_animationName release];
	
	if (animationName == nil) return;
	
	_animationName = [animationName copy];
	
	NSString* staticImageName = [self nameFromImageAtIndex:0];
	UIImage* staticImage = [UIImage imageNamed:staticImageName cached:NO];
	
	[self setStaticImage:staticImage];
	[self setImage:staticImage];
}

- (BOOL)isPlaying
{
	return _timer != nil;
}

#pragma mark - Public Methods

- (void)play
{
	if (!_animationName || [self isPlaying]) return;
	
	[self createImages];
	[self setNextIndex:0];
	
	NSTimeInterval timeInterval = 1.0f / _framesPerSecond;
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
	[self setTimer:timer];
}

- (void)stop
{
	if (![self isPlaying]) return;
	
	[_timer invalidate];
	[self setTimer:nil];
	
	if (_stopsOnLastFrame)
	{
		[self setStaticImage:[_images lastObject]];
	}
	
	[self setImage:_staticImage];
	[self setImages:nil];
	
	if ([_delegate respondsToSelector:@selector(animatedImageDidFinishPlaying:)])
	{
		[_delegate animatedImageDidFinishPlaying:self];
	}
}

#pragma mark - Private Methods

- (NSString*)nameFromImageAtIndex:(NSUInteger)index
{
	return [_animationName stringByAppendingFormat:@"%i", index];
}

- (void)createImages
{
	NSAssert(_images == nil, @"Images should not be hanging around by now.");
	
	NSMutableArray* images = [NSMutableArray array];
	NSUInteger index = 1;
	
	while (YES)
	{
		NSString* imageName = [self nameFromImageAtIndex:index];
		UIImage* image = [UIImage imageNamed:imageName cached:NO];
		
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
	if (_nextIndex < [_images count])
	{
		UIImage* nextImage = [_images objectAtIndex:_nextIndex];
		[self setImage:nextImage];
		[self setNextIndex:_nextIndex + 1];
	}
	else
	{
		[self stop];
	}
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self stop];
	
	[self setStaticImage:nil];
	[self setAnimationName:nil];
	
	[super dealloc];
}

@end

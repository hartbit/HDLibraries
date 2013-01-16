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
	self.framesPerSecond = 12;
	self.animationRepeatCount = 1;
}

#pragma mark - Properties

- (void)setAnimationName:(NSString*)animationName
{
	if (![animationName isEqualToString:_animationName]) {
		_animationName = [animationName copy];
		self.staticImage = nil;
		self.image = nil;
		self.images = nil;
		
		if (animationName != nil) {
			NSString* staticImageName = [self nameFromImageAtIndex:0];
			UIImage* staticImage = [UIImage imageWithName:staticImageName cached:NO];
			self.staticImage = staticImage;
			self.image = staticImage;
		}
	}
}

- (NSTimeInterval)animationDuration
{
	return (NSTimeInterval)[self.images count] / self.framesPerSecond;
}

- (NSArray*)images
{
	if (_images == nil) {
		NSMutableArray* images = [NSMutableArray array];
		self.images = images;
		
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
	return self.timer != nil;
}

#pragma mark - Public Methods

- (void)play
{
	if (self.playing) {
		return;
	}
	
	NIDASSERT(self.superview != nil);
	
	self.nextIndex = 0;
	
	NSTimeInterval timeInterval = 1.0f / self.framesPerSecond;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
}

- (void)stop
{
	if (!self.playing) {
		return;
	}
	
	[self.timer invalidate];
	self.timer = nil;
	
	if ([self stopsOnLastFrame]) {
		self.staticImage = [self.images lastObject];
	}
	
	self.image = self.staticImage;
	self.images = nil;
}

#pragma mark - UIView Methods

- (void)didMoveToSuperview
{
	if (self.superview == nil) {
		[self stop];
	}
}

#pragma mark - Private Methods

- (NSString*)nameFromImageAtIndex:(NSUInteger)index
{
	NIDASSERT(self.animationName != nil);
	return [self.animationName stringByAppendingFormat:@"%i", index];
}

- (void)changeFrame
{
	if (self.nextIndex >= [self.images count]) {
		self.animationRepeatCount--;
		
		if (self.animationRepeatCount == 0) {
			[self stop];
			self.animationRepeatCount = 1;
			
			if ([self.delegate respondsToSelector:@selector(animatedImageDidFinishPlaying:)]) {
				[self.delegate animatedImageDidFinishPlaying:self];
			}
			
			return;
		} else {
			self.nextIndex = 0;
		}
	}
	
	UIImage* nextImage = self.images[self.nextIndex];
	self.image = nextImage;
	self.nextIndex++;
}

#pragma mark - Memory Management

- (void)dealloc
{
	if (self.playing) {
		[self stop];
	}
}

@end

//
//  HDImageInfo.m
//  HDLibraries
//
//  Created by David Hart on 13/11/2012.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import "HDImageInfo.h"
#import "NimbusCore.h"
#import "UIImage+HDAdditions.h"


@interface HDImageInfo ()

@property (nonatomic, strong) NSData* imageData;

@end


@implementation HDImageInfo

#pragma mark - Initialization

- (id)initWithUIImage:(UIImage*)image
{
	if (self = [super init]) {
		self.image = image;
	}
	
	return self;
}

#pragma mark - Properties

- (void)setImage:(UIImage*)image
{
	if (image != _image) {
		_image = image;		
		self.imageData = image.imageData;
	}
}

#pragma mark - Public Methods

- (BOOL)pointInside:(CGPoint)point
{
	if ((self.image == nil) || (self.imageData == nil)) {
		return NO;
	}
	
	CGSize size = self.image.size;
	
	if ((point.x < 0) || (point.y < 0) || (point.x >= size.width) || (point.y >= size.height)) {
		return NO;
	}
	
	CGImageRef cgImage = self.image.CGImage;
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
	
	if ((alphaInfo == kCGImageAlphaNone) || (alphaInfo == kCGImageAlphaNoneSkipFirst) || (alphaInfo == kCGImageAlphaNoneSkipLast)) {
		return YES;
	}
	
	point.x = floorf(point.x);
	point.y = floorf(point.y);
	
	size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
	size_t bytesPerPixel = CGImageGetBitsPerPixel(cgImage) / 8;
	size_t alphaIndex = (point.y * self.image.scale * bytesPerRow) + (point.x * self.image.scale * bytesPerPixel);
	
	if ((alphaInfo == kCGImageAlphaLast) || (alphaInfo == kCGImageAlphaPremultipliedLast)) {
		size_t bytesPerComponent = CGImageGetBitsPerComponent(cgImage) / 8;
		alphaIndex += 3 * bytesPerComponent;
	}
	
	char alphaData = 0;
	[self.imageData getBytes:&alphaData range:NSMakeRange(alphaIndex, 1)];
	return alphaData != 0;
}

@end

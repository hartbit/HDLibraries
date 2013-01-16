//
//  HDDrawableView.m
//  HDLibraries
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDrawableView.h"
#import "HDFoundation.h"
#import "HDKitFunctions.h"
#import <QuartzCore/QuartzCore.h>


@interface HDDrawableView ()

@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, readonly) CGFloat brushSize;
@property (nonatomic, readonly) UIColor* brushColor;

@end


@implementation HDDrawableView

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
	self.clipsToBounds = YES;
	self.distanceThreshold = 10;
}

#pragma mark - Properties

- (CGFloat)brushSize
{
	if ([self.dataSource respondsToSelector:@selector(sizeOfBrushForDrawableView:)]) {
		return [self.dataSource sizeOfBrushForDrawableView:self];
	} else {
		return 20;
	}
}

- (UIColor*)brushColor
{
	if ([self.dataSource respondsToSelector:@selector(colorOfBrushForDrawableView:)]) {
		return [self.dataSource colorOfBrushForDrawableView:self];
	} else {
		return [UIColor blackColor];
	}
}

#pragma mark - Public Methods

- (void)clear
{
	for (CALayer* sublayer in [self.layer sublayers]) {
		[sublayer removeFromSuperlayer];
	}
	
	[self setNeedsDisplay];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	self.mouseSwiped = NO;
	[self updateLayersWithNewTouches:touches];
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	self.mouseSwiped = YES;
	[self updateLayersWithContinuedTouches:touches force:NO];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (!self.mouseSwiped) {
		[self updateLayersWithContinuedTouches:touches force:YES];
	}
	
	[self endDrawing];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self endDrawing];
}

#pragma mark - Private Methods

- (void)updateLayersWithNewTouches:(NSSet*)touches
{
	CGPoint point = [[touches anyObject] locationInView:self];
	
	CGMutablePathRef path = CGPathCreateMutableCopy(self.currentLayer.path);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	self.currentLayer.path = path;
	CGPathRelease(path);
}

- (void)updateLayersWithContinuedTouches:(NSSet*)touches force:(BOOL)force
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CGFloat deltaDistance = CGPointDistance(CGPathGetCurrentPoint(self.currentLayer.path), point);
	
	if (force || (deltaDistance > self.distanceThreshold)) {
		CGMutablePathRef path = CGPathCreateMutableCopy(self.currentLayer.path);
		CGPathAddLineToPoint(path, NULL, point.x, point.y);
		self.currentLayer.path = path;
		CGPathRelease(path);
	}
}

- (CAShapeLayer*)currentLayer
{
	CGFloat brushSize = self.brushSize;
	UIColor* brushColor = self.brushColor;
	CAShapeLayer* lastLayer = [self.layer.sublayers lastObject];
	
	if ((lastLayer == nil) || (lastLayer.lineWidth != brushSize) || !CGColorEqualToColor(lastLayer.strokeColor, brushColor.CGColor)) {
		lastLayer = [[CAShapeLayer alloc] init];
		lastLayer.lineCap = kCALineCapRound;
		lastLayer.lineJoin = kCALineJoinRound;
		lastLayer.lineWidth = brushSize;
		lastLayer.strokeColor = brushColor.CGColor;
		lastLayer.fillColor = [UIColor clearColor].CGColor;
		
		CGMutablePathRef path = CGPathCreateMutable();
		lastLayer.path = path;
		CGPathRelease(path);
		
		[self.layer addSublayer:lastLayer];
	}
	
	return lastLayer;
}

- (void)startDrawing
{
	if ([self.delegate respondsToSelector:@selector(drawableViewWillStartDrawing:)]) {
		[self.delegate drawableViewWillStartDrawing:self];
	}
}

- (void)endDrawing
{
	if ([self.delegate respondsToSelector:@selector(drawableViewDidEndDrawing:)]) {
		[self.delegate drawableViewDidEndDrawing:self];
	}
}

@end

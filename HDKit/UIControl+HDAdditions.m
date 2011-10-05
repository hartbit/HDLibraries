//
//  UIControl+HDAdditions.m
//  HDLibraries
//
//  Created by Hart David on 05.10.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "UIControl+HDAdditions.h"
#import <objc/runtime.h>


@interface HDBlockWrapper : NSObject

@property (nonatomic, copy) void (^block)(void);

- (void)invoke:(id)sender;

@end


@implementation HDBlockWrapper

@synthesize block = _block;

- (void)invoke:(id)sender
{
	[self block]();
}

@end


@interface UIControl ()

@property (nonatomic, readonly) NSMutableArray* blocks;

@end


@implementation UIControl (HDAdditions)

#pragma mark - Properties

- (NSMutableArray*)blocks
{
	static const char* UIControlHDBlocks = "UIControlHDBlocks";
	NSMutableArray* blocks = objc_getAssociatedObject(self, &UIControlHDBlocks);
	
	if (blocks == nil)
	{
		blocks = [NSMutableArray array];
		objc_setAssociatedObject(self, &UIControlHDBlocks, blocks, OBJC_ASSOCIATION_RETAIN);
	}
	
	return blocks;
}

#pragma mark - Public Methods

- (void)respondToControlEvents:(UIControlEvents)controlEvents usingBlock:(void(^)(void))block
{
	NSMutableArray* blocks = [self blocks];
	
	HDBlockWrapper* target = [HDBlockWrapper new];
	[target setBlock:block];
	[blocks addObject:target];
	
	[self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

@end
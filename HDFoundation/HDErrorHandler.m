//
//  HDErrorHandler.m
//  HDLibrairies
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDCodeLocation.h"
#import <UIKit/UIKit.h>


@interface HDErrorHandler ()

@property (nonatomic, assign) BOOL shouldTerminateApplication;

- (void)handleApplicationDidEnterBackground:(NSNotification*)notification;
- (NSString*)levelStringFromLevel:(HDFailureLevel)level;

@end


@implementation HDErrorHandler

@synthesize shouldTerminateApplication = _shouldTerminateApplication;

#pragma mark - Singleton Methods

+ (HDErrorHandler*)sharedHandler
{
	static HDErrorHandler* sharedHandler = nil;
	
	if (sharedHandler == nil)
	{
		sharedHandler = [[HDErrorHandler alloc] init];
	}
	
	return sharedHandler;
}

#pragma mark - Lifecycle

- (id)init
{
	if ((self = [super init]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleApplicationDidEnterBackground)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification
												  object:nil];
	
}

#pragma mark - Public Methods

- (void)handleFailureWithMessage:(NSString*)message level:(HDFailureLevel)level location:(HDCodeLocation*)location userInfo:(NSDictionary*)userInfo
{
	NSString* levelString = [[self levelStringFromLevel:level] uppercaseString];
	NSMutableString* description = [NSMutableString stringWithFormat:@"[%@] %@ in %@", levelString, message, location];
	
	if ([location object] != nil)
	{
		[description appendFormat:@"\n\tself: %@", [[location object] description]];
	}
	
	for (NSString* infoKey in [userInfo allKeys])
	{
		[description appendFormat:@"\n\t%@: %@", infoKey, [userInfo objectForKey:infoKey]];
	}
	
	NSLog(@"%@", description);
	
#ifdef DEBUG
	abort();
#else
	if (level == HDFailureLevelError)
	{
		[self setShouldTerminateApplication:YES];
	}
	else if (level > HDFailureLevelError)
	{
		abort();
	}
#endif
}

#pragma mark - Private Methods

- (void)handleApplicationDidEnterBackground:(NSNotification*)notification
{
	if ([self shouldTerminateApplication])
	{
		abort();
	}
}

- (NSString*)levelStringFromLevel:(HDFailureLevel)level
{
	static NSArray* kLevelStringTable = nil;
	
	if (kLevelStringTable == nil)
	{
		kLevelStringTable = [[NSArray alloc] initWithObjects:@"Info", @"Warning", @"Error", @"Fatal", nil];
	}
	
	return [kLevelStringTable objectAtIndex:level];
}

@end

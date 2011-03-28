//
//  HDErrorHandler.m
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"


@interface HDErrorHandler ()

@property (nonatomic, assign) BOOL shouldTerminateApplication;

- (void)handleFailureWithDescription:(NSString*)description level:(HDFailureLevel)level;
- (void)handleApplicationDidEnterBackground:(NSNotification*)notification;

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
	
	[super dealloc];
}

#pragma mark - Public Methods

- (void)handleFailureInFunction:(NSString*)function file:(NSString*)fileName lineNumber:(NSInteger)line description:(NSString*)description level:(HDFailureLevel)level
{
	[self handleFailureWithDescription:description level:level];
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString*)fileName lineNumber:(NSInteger)line description:(NSString*)description level:(HDFailureLevel)level
{
	[self handleFailureWithDescription:description level:level];	
}

#pragma mark - Private Methods

- (void)handleFailureWithDescription:(NSString*)description level:(HDFailureLevel)level
{
	if (level == HDFailureLevelError)
	{
		[self setShouldTerminateApplication:YES];
	}
	else
	{
		abort();
	}
}

- (void)handleApplicationDidEnterBackground:(NSNotification*)notification
{
	if ([self shouldTerminateApplication])
	{
		abort();
	}
}

@end

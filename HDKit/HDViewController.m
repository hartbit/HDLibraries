//
//  HDViewController.m
//  HDLibraries
//
//  Created by David Hart on 07/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDViewController.h"
#import "HDFoundation.h"
#import "HDTransitionController.h"


@interface HDViewController ()

@property (nonatomic, copy) NSString* controllerName;

- (void)releaseOutlets;

@end


@implementation HDViewController

@synthesize controllerName = _controllerName;
@synthesize transitionController = _transitionController;

#pragma mark - Memory Management

- (void)viewDidUnload
{
	[self releaseOutlets];
	
	[super viewDidUnload];
}

- (void)dealloc
{
	[self releaseOutlets];
	[self setControllerName:nil];
	[self setTransitionController:nil];
	
	[super dealloc];
}

#pragma mark - UIVIewController Methods

- (void)viewWillDisappear:(BOOL)animated
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[super viewWillDisappear:animated];
}

#pragma mark - Properties

- (NSString*)controllerName
{	
	if (!_controllerName)
	{
		NSString* className = NSStringFromClass([self class]);
		NSRange postfixRange = [className rangeOfString:@"ViewController"];
		BOOL postfixIsAtEnd = postfixRange.location + postfixRange.length == [className length];
		
//		HDAssert(postfixIsAtEnd, @"The view controller '%@' does not end in 'ViewController'.", className);
		
		if (postfixIsAtEnd)
		{
			[self setControllerName:[className substringToIndex:postfixRange.location]];
		}
	}

	return _controllerName;
}

#pragma mark - Public Methods

- (NSSet*)outlets
{
	return [NSSet set];
}

#pragma mark - Private Methods
		 
- (void)releaseOutlets
{
	for (NSString* outlet in [self outlets])
	{
		[self setValue:nil forKey:outlet];
	}
}

@end
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

@end


@implementation HDViewController

@synthesize controllerName = _controllerName;
@synthesize transitionController = _transitionController;

#pragma mark - Memory Management

- (void)viewDidUnload
{
	[self releaseViewObjects];
	
	[super viewDidUnload];
}

- (void)dealloc
{
	[self releaseViewObjects];
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
	static NSString* kEnding = @"ViewController";
	
	if (!_controllerName)
	{
		NSString* className = NSStringFromClass([self class]);
		
		HDCheck(doesStringEndWith(className, kEnding), HDFailureLevelError, return nil);
		
		NSRange postfixRange = [className rangeOfString:kEnding];
		[self setControllerName:[className substringToIndex:postfixRange.location]];
	}

	return _controllerName;
}

#pragma mark - Public Methods

- (void)releaseViewObjects
{
}

@end
//
//  HDTransitionController.m
//  HDLibraries
//
//  Created by David Hart on 3/22/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDTransitionController.h"
#import "HDViewController.h"


@interface HDTransitionController ()

@property (nonatomic, retain) UIView* contentView;

@end


@implementation HDTransitionController

@synthesize viewController = _viewController;
@synthesize contentView = _contentView;

#pragma mark - Properties

- (void)setViewController:(HDViewController*)viewController
{
	[self setViewController:viewController withTransition:UIViewAnimationTransitionNone];
}

#pragma mark - Properties

- (UIView*)contentView
{
	if (!_contentView)
	{
		UIView* contentView = [[UIView alloc] initWithFrame:[[self view] frame]];
		[contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[contentView setAutoresizesSubviews:YES];
		
		[self setContentView:contentView];
		[[self view] addSubview:contentView];
		
		[contentView release];
	}
	
	return _contentView;
}

#pragma mark - Public Methods

- (void)setViewController:(HDViewController*)viewController withTransition:(UIViewAnimationTransition)transition
{
	if (viewController == _viewController)
	{
		return;
	}
	
	BOOL animated = transition != UIViewAnimationTransitionNone;
	
	[viewController setTransitionController:self];
	[_viewController viewWillDisappear:animated];
	[viewController viewWillAppear:animated];
	
	UIView* newView = [viewController view];
	
	if (animated)
	{
		[newView setUserInteractionEnabled:NO];
		
		[UIView beginAnimations:nil context:[_viewController retain]];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:transition forView:[self contentView] cache:NO];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	}
	
	[[_viewController view] removeFromSuperview];
	[[self contentView] addSubview:newView];
	
	if (animated)
	{
		[UIView commitAnimations];
	}
	else
	{
		[_viewController viewDidDisappear:NO];
		[viewController viewDidAppear:NO];
	}
	
	[_viewController release];
	_viewController = [viewController retain];
}
	 
- (void)transitionDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
	[[[self viewController] view] setUserInteractionEnabled:YES];
	
	HDViewController* previousViewController = (HDViewController*)context;
	[previousViewController viewDidDisappear:YES];
	[[self viewController] viewDidAppear:YES];
	[previousViewController release];
}

#pragma mark - HDViewController Methods

- (NSSet*)outlets
{
	return [NSSet setWithObjects:@"contentView", nil];
}

#pragma mark - UIViewController Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	HDViewController* viewController = [self viewController];
	return viewController ? [viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation] : YES;
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self setViewController:nil];
	[super dealloc];
}

@end

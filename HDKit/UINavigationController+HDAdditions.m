//
//  UINavigationController+HDAdditions.m
//  Maternelles
//
//  Created by Hart David on 17.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "UINavigationController+HDAdditions.h"


const NSTimeInterval kNavigationTransitionDuration = 1;


@implementation UINavigationController (HDAdditions)

- (void)setViewControllers:(NSArray*)viewControllers withTransitionOption:(UIViewAnimationOptions)transition
{
	UIViewController* disappearingViewController = self.topViewController;
	UIViewController* appearingViewController = [viewControllers lastObject];
	
	[UIView transitionWithView:disappearingViewController.view.superview.superview
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^() {
						[disappearingViewController viewWillDisappear:YES];
						[appearingViewController viewWillAppear:YES];
						[self setViewControllers:viewControllers animated:NO];
					}
					completion:^(BOOL finished) {
						[disappearingViewController viewDidDisappear:YES];
						[appearingViewController viewDidAppear:YES];
					}];
}

- (void)pushViewController:(UIViewController*)viewController withTransitionOption:(UIViewAnimationOptions)transition
{
	UIViewController* disappearingViewController = self.topViewController;
	UIViewController* appearingViewController = viewController;
	
	[UIView transitionWithView:disappearingViewController.view.superview.superview
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^{
						[disappearingViewController viewWillDisappear:YES];
						[appearingViewController viewWillAppear:YES];
						[self pushViewController:viewController animated:NO];
					}
					completion:^(BOOL finished) {
						[disappearingViewController viewDidDisappear:YES];
						[appearingViewController viewDidAppear:YES];
					}];
}

- (void)popViewControllerWithTransitionOption:(UIViewAnimationOptions)transition
{
	UIViewController* disappearingViewController = self.topViewController;
	UIViewController* appearingViewController = self.viewControllers[[self.viewControllers count] - 2];
	
	[UIView transitionWithView:disappearingViewController.view.superview.superview
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^() {
						[disappearingViewController viewWillDisappear:YES];
						[appearingViewController viewWillAppear:YES];
						[self popViewControllerAnimated:NO];
					}
					completion:^(BOOL finished) {
						[disappearingViewController viewDidDisappear:YES];
						[appearingViewController viewDidAppear:YES];
					}];
}

- (void)popToRootViewControllerWithTransitionOption:(UIViewAnimationOptions)transition
{
	UIViewController* disappearingViewController = self.topViewController;
	UIViewController* appearingViewController = self.viewControllers[0];
	
	[UIView transitionWithView:disappearingViewController.view.superview.superview
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^() {
						[disappearingViewController viewWillDisappear:YES];
						[appearingViewController viewWillAppear:YES];
						[self popToRootViewControllerAnimated:NO];
					}
					completion:^(BOOL finished) {
						[disappearingViewController viewDidDisappear:YES];
						[appearingViewController viewDidAppear:YES];
					}];
}

- (void)popToViewController:(UIViewController*)viewController withTransitionOption:(UIViewAnimationOptions)transition
{
	UIViewController* disappearingViewController = self.topViewController;
	UIViewController* appearingViewController = viewController;
	
	[UIView transitionWithView:self.topViewController.view.superview.superview
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^() {
						[disappearingViewController viewWillDisappear:YES];
						[appearingViewController viewWillAppear:YES];
						[self popToViewController:viewController animated:NO];
					}
					completion:^(BOOL finished) {
						[disappearingViewController viewDidDisappear:YES];
						[appearingViewController viewDidAppear:YES];
					}];
}

@end

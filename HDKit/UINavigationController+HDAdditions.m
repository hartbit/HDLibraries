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

- (void)setViewControllers:(NSArray*)viewControllers withTransition:(UIViewAnimationOptions)transition
{
	[UIView transitionWithView:[[[[self topViewController] view] superview] superview]
					  duration:kNavigationTransitionDuration
					   options:transition
					 animations:^() { [self setViewControllers:viewControllers animated:NO]; }
					 completion:NULL];
}

- (void)pushViewController:(UIViewController*)viewController withTransition:(UIViewAnimationOptions)transition
{
	[UIView transitionWithView:[[[[self topViewController] view] superview] superview]
					  duration:kNavigationTransitionDuration
					   options:transition
					animations:^{ [self pushViewController:viewController animated:NO]; }
					completion:NULL];
}

- (void)popViewControllerWithTransition:(UIViewAnimationOptions)transition
{
	[UIView transitionWithView:[[[[self topViewController] view] superview] superview]
					  duration:kNavigationTransitionDuration
					   options:transition
					 animations:^() { [self popViewControllerAnimated:NO]; }
					 completion:NULL];
}

- (void)popToRootViewControllerWithTransition:(UIViewAnimationOptions)transition
{
	[UIView transitionWithView:[[[[self topViewController] view] superview] superview]
					  duration:kNavigationTransitionDuration
					   options:transition
					 animations:^() { [self popViewControllerAnimated:NO]; }
					 completion:NULL];
}

- (void)popToViewController:(UIViewController*)viewController withTransition:(UIViewAnimationOptions)transition
{
	[UIView transitionWithView:[[[[self topViewController] view] superview] superview]
					  duration:kNavigationTransitionDuration
					   options:transition
					 animations:^() { [self popToViewController:viewController animated:NO]; }
					 completion:NULL];
}

@end

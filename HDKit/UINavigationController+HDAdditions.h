//
//  UINavigationController+HDAdditions.h
//  Maternelles
//
//  Created by Hart David on 17.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (HDAdditions)

- (void)setViewControllers:(NSArray*)viewControllers withTransition:(UIViewAnimationOptions)transition;
- (void)pushViewController:(UIViewController*)viewController withTransition:(UIViewAnimationOptions)transition;
- (void)popViewControllerWithTransition:(UIViewAnimationOptions)transition;
- (void)popToRootViewControllerWithTransition:(UIViewAnimationOptions)transition;
- (void)popToViewController:(UIViewController*)viewController withTransition:(UIViewAnimationOptions)transition;

@end

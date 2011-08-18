//
//  UINavigationController+HDAdditions.h
//  Maternelles
//
//  Created by Hart David on 17.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (HDAdditions)

- (void)setViewControllers:(NSArray*)viewControllers withTransitionOption:(UIViewAnimationOptions)transition;
- (void)pushViewController:(UIViewController*)viewController withTransitionOption:(UIViewAnimationOptions)transition;
- (void)popViewControllerWithTransitionOption:(UIViewAnimationOptions)transition;
- (void)popToRootViewControllerWithTransitionOption:(UIViewAnimationOptions)transition;
- (void)popToViewController:(UIViewController*)viewController withTransitionOption:(UIViewAnimationOptions)transition;

@end

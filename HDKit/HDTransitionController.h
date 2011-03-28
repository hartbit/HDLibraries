//
//  HDViewController.h
//  HDLibraries
//
//  Created by David Hart on 3/22/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDViewController.h"


@interface HDTransitionController : HDViewController

@property (nonatomic, retain) IBOutlet HDViewController* viewController;

- (void)setViewController:(HDViewController*)viewController withTransition:(UIViewAnimationTransition)transition;

@end

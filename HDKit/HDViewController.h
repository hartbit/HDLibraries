//
//  HDViewController.h
//  HDLibraries
//
//  Created by David Hart on 07/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HDTransitionController;

@interface HDViewController : UIViewController

@property (nonatomic, copy, readonly) NSString* controllerName;
@property (nonatomic, retain) HDTransitionController* transitionController;

- (NSSet*)outlets;

@end

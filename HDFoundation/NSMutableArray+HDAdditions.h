//
//  NSArray+HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (HDAdditions)

- (void)enqueueObject:(id)object;
- (id)dequeueObject;

- (void)pushObject:(id)object;
- (id)popObject;
- (id)topObject;

@end

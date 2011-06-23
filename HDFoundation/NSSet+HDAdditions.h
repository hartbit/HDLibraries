//
//  NSSet+HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 6/23/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSSet (HDAdditions)

- (NSUInteger)numberOfObjectsPassingTest:(BOOL (^)(id obj, BOOL* stop))predicate;

@end

//
//  NSArray+Queue.h
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Queue)

- (void)enqueue:(id)object;
- (id)dequeue;

@end

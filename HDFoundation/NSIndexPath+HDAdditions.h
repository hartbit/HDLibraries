//
//  NSIndexPath+HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 21.07.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSIndexPath (HDAdditions)

+ (NSIndexPath*)indexPathWithIndexes:(NSArray*)indexes;
- (NSIndexPath*)initWithIndexes:(NSArray*)indexes;
- (NSArray*)allIndexes;
- (NSUInteger)lastIndex;

@end

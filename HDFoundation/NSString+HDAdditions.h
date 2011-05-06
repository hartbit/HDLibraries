//
//  NSString+HDAdditions.h
//  HDLibrairies
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (HDAdditions)

- (NSRange)fullRange;
- (BOOL)startsWithString:(NSString*)substring;
- (BOOL)endsWithString:(NSString*)substring;

@end

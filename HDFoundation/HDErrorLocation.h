//
//  HDErrorLocation.h
//  Imagidoux
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning TODO
#define HDCurrentErrorLocation []


@interface HDErrorLocation : NSObject

@property (nonatomic, assign) id object;
@property (nonatomic, copy) NSString* context;
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, assign) NSUInteger lineNumber;

+ (id)errorLocationInFunction:(NSString*)function fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber;
+ (id)errorLocationInObject:(id)object method:(SEL)selector fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber;

@end

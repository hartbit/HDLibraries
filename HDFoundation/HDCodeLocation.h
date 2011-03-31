//
//  HDCodeLocation.h
//  HDLibraries
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HDCurrentCodeLocation() [HDCodeLocation codeLocationInObject:self method:_cmd fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__]
#define HDCCurrentCodeLocation() [HDCodeLocation codeLocationInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__]


@interface HDCodeLocation : NSObject

@property (nonatomic, assign) id object;
@property (nonatomic, copy) NSString* context;
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, assign) NSUInteger lineNumber;

+ (id)codeLocationInFunction:(NSString*)function fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber;
+ (id)codeLocationInObject:(id)object method:(SEL)selector fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber;

@end

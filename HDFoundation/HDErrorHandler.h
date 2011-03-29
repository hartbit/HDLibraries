//
//  HDErrorHandler.h
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
	HDFailureLevelInfo = 0,
	HDFailureLevelWarning = 1,
	HDFailureLevelError = 2,
	HDFailureLevelFatal = 3
} HDFailureLevel;


@interface HDErrorHandler : NSObject

+ (HDErrorHandler*)sharedHandler;

- (void)handleFailureInFunction:(NSString*)function file:(NSString*)file lineNumber:(NSInteger)lineNumber message:(NSString*)message level:(HDFailureLevel)level;
- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString*)fileName lineNumber:(NSInteger)line message:(NSString*)message level:(HDFailureLevel)level;

@end

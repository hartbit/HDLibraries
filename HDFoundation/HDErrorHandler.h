//
//  HDErrorHandler.h
//  HDLibrairies
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


@class HDCodeLocation;

@interface HDErrorHandler : NSObject

+ (HDErrorHandler*)sharedHandler;

- (void)handleFailureWithMessage:(NSString*)message level:(HDFailureLevel)level location:(HDCodeLocation*)location userInfo:(NSDictionary*)userInfo;

@end

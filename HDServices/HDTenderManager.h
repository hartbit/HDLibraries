//
//  HDTenderManager.h
//  HDLibraries
//
//  Created by David Hart on 02.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import	<Foundation/Foundation.h>


@interface HDTenderManager : NSObject

+ (HDTenderManager*)sharedInstance;

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;

- (void)createDiscussionWithEmail:(NSString*)email title:(NSString*)title message:(NSString*)message isPublic:(BOOL)isPublic;

@end

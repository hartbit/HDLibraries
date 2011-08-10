//
//  HDTenderManager.h
//  HDLibraries
//
//  Created by David Hart on 02.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import	<Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface HDTenderManager : NSObject <RKRequestDelegate>

+ (HDTenderManager*)sharedInstance;

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* domain;
@property (nonatomic, assign, readonly) BOOL isNetworkAvailable;

- (void)createDiscussionInCategory:(NSUInteger)categoryId from:(NSString*)authorName withEmail:(NSString*)authorEmail title:(NSString*)title body:(NSString*)body isPublic:(BOOL)isPublic;

@end

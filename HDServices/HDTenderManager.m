//
//  HDTenderManager.m
//  HDLibraries
//
//  Created by David Hart on 02.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDTenderManager.h"
#import	"HDFoundation.h"
#import <RestKit/RestKit.h>


@interface HDTenderManager ()

@property (nonatomic, strong) RKClient* tenderClient;

@end


@implementation HDTenderManager

@synthesize username = _username;
@synthesize password = _password;
@synthesize tenderClient = _tenderClient;

SYNTHESIZE_SINGLETON(HDTenderManager);

#pragma mark - Properties

- (RKClient*)tenderClient
{
	if (_tenderClient == nil)
	{
		HDCheck(isObjectNotNil([self username]), HDFailureLevelError, return nil);
		HDCheck(isObjectNotNil([self password]), HDFailureLevelError, return nil);
		
		RKClient* tenderClient = [[RKClient alloc] init];
		[self setTenderClient:tenderClient];
	}
	
	return _tenderClient;
}

#pragma marl - Public Methods

- (void)createDiscussionWithEmail:(NSString*)email title:(NSString*)title message:(NSString*)message isPublic:(BOOL)isPublic
{
	
}

@end

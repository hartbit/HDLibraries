//
//  HDTenderManager.m
//  HDLibraries
//
//  Created by David Hart on 02.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDTenderManager.h"
#import	"HDFoundation.h"
#import <RestKit/Network/RKRequestSerialization.h>
#import <RestKit/Support/JSON/JSONKit/JSONKit.h>


NSString* const HDTenderAuthorNameParam = @"author_name";
NSString* const HDTenderAuthorEmailParam = @"author_email";
NSString* const HDTenderTitleParam = @"title";
NSString* const HDTenderBodyParam = @"body";
NSString* const HDTenderPublicParam = @"public";
NSString* const HDTenderSkipSpamParam = @"skip_spam";


@interface HDTenderManager ()

@property (nonatomic, strong) RKClient* tenderClient;

@end


@implementation HDTenderManager

@synthesize username = _username;
@synthesize password = _password;
@synthesize domain = _domain;
@synthesize tenderClient = _tenderClient;

SYNTHESIZE_SINGLETON(HDTenderManager);

#pragma mark - Properties

- (RKClient*)tenderClient
{
	if (_tenderClient == nil)
	{
		HDCheck(isObjectNotNil([self username]), HDFailureLevelError, return nil);
		HDCheck(isObjectNotNil([self password]), HDFailureLevelError, return nil);
		HDCheck(isObjectNotNil([self domain]), HDFailureLevelError, return nil);
		
		NSString* baseURL = [NSString stringWithFormat:@"http://api.tenderapp.com/%@", [self domain]];
		RKClient* tenderClient = [RKClient clientWithBaseURL:baseURL username:[self username] password:[self password]];
		[tenderClient setForceBasicAuthentication:YES];
		[tenderClient setValue:@"application/vnd.tender-v1+json" forHTTPHeaderField:@"Accept"];
		 
		[self setTenderClient:tenderClient];
	}
	
	return _tenderClient;
}

#pragma marl - Public Methods

- (void)createDiscussionInCategory:(NSUInteger)categoryId from:(NSString*)authorName withEmail:(NSString*)authorEmail title:(NSString*)title body:(NSString*)body isPublic:(BOOL)isPublic
{
	NSDictionary* paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									  authorName,							HDTenderAuthorNameParam,
									  authorEmail,							HDTenderAuthorEmailParam,
									  title,								HDTenderTitleParam,		
									  body,									HDTenderBodyParam,
									  [NSNumber numberWithBool:isPublic],	HDTenderPublicParam,
									  [NSNumber numberWithBool:YES],		HDTenderSkipSpamParam, nil];

	NSString* resourcePath = [NSString stringWithFormat:@"/categories/%i/discussions", categoryId];
	RKRequestSerialization* params = [RKRequestSerialization serializationWithData:[paramsDictionary JSONData] MIMEType:@"application/json"];
	[[self tenderClient] post:resourcePath params:params delegate:self];
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error
{
	HDFail([error localizedDescription], HDFailureLevelError);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
	NSLog(@"Status %i\n%@", [response statusCode], [response bodyAsString]);
}

@end

//
//  HDAdMob.m
//  HDLibraries
//
//  Created by Hart David on 23.01.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import "HDAdMob.h"
#import "HDFoundation.h"
#import "NimbusCore.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface HDAdMob ()

@property (nonatomic, assign, getter = isTracked) BOOL tracked;

+ (NSString*)trackedFilePath;
+ (NSString*)hashedISU;

- (void)trackDownloadAsynchronouslyWithAppleID:(NSString*)appleID;

@end


@implementation HDAdMob

@synthesize tracked = _tracked;

#pragma mark - Class Methods

+ (HDAdMob*)sharedInstance
{
	SYNTHESIZE_SINGLETON(^{
		return [HDAdMob new];
	});
}

+ (NSString*)trackedFilePath
{
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"AdMobTracked"];
}

+ (NSString*)hashedISU
{
	NSString* result = nil;
	NSString* isu = [[UIDevice currentDevice] uniqueIdentifier];
	
	if (isu != nil)
	{
		unsigned char digest[16];
		NSData* data = [isu dataUsingEncoding:NSASCIIStringEncoding];
		CC_MD5([data bytes], [data length], digest);
		
		result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7],
				  digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];
		result = [result uppercaseString];
	}
	
	return result;
}

#pragma mark - Properties

- (BOOL)isTracked
{
	return [[NSFileManager new] fileExistsAtPath:[[self class] trackedFilePath]];
}

- (void)setTracked:(BOOL)tracked
{
	if (tracked && ![self isTracked])
	{
		[[NSFileManager new] createFileAtPath:[[self class] trackedFilePath] contents:nil attributes:nil];
	}
	else if (!tracked && [self isTracked])
	{
		NSError* error = nil;
		[[NSFileManager new] removeItemAtPath:[[self class] trackedFilePath] error:&error];
		NIDASSERT(error == nil);
	}
}

#pragma mark - Public Methods

- (void)trackDownloadWithAppleID:(NSString*)appleID
{
	[self performSelectorInBackground:@selector(trackDownloadAsynchronouslyWithAppleID:) withObject:appleID];
}

#pragma mark - Private Methods

- (void)trackDownloadAsynchronouslyWithAppleID:(NSString*)appleID
{
	@autoreleasepool
	{
		if (![self isTracked])
		{
			NSString* trackingURLString = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@", [[self class] hashedISU], appleID];
			NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:trackingURLString]];
			
			NSURLResponse* response = nil;
			NSError* error = nil;
			NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
			
			if ((error == nil) && ([(NSHTTPURLResponse*)response statusCode] == 200) && ([data length] > 0))
			{
				[self setTracked:YES];
			}
		}
	}
}

@end

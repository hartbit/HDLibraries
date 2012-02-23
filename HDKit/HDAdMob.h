//
//  HDAdMob.h
//  HDLibraries
//
//  Created by Hart David on 23.01.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HDAdMob : NSObject

+ (HDAdMob*)sharedInstance;

- (void)trackDownloadWithAppleID:(NSString*)appleID;

@end

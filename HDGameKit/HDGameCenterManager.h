//
//  HDGameKit.h
//  GraviMaze
//
//  Created by Hart David on 15.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <GameKit/GameKit.h>


@interface HDGameCenterManager : NSObject <GKGameCenterControllerDelegate>

@property (nonatomic, readonly) BOOL isAuthenticated;

+ (BOOL)isAvailable;
+ (HDGameCenterManager*)sharedInstance;

- (void)authenticate;
- (void)updateScore:(int64_t)value onLeaderboard:(NSString*)category;
- (void)updateAchievement:(NSString*)identifier percentComplete:(double)percentComplete;
- (void)completeAllAchievements;
- (void)resetAllAchievements;

- (void)showGameCenterWithState:(GKGameCenterViewControllerState)state;

@end

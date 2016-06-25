//
//  GameKitHelper.h
//  CardFit
//
//  Created by Braden Gray on 5/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@protocol GameKitHelperDelegate

- (void)matchStarted;
- (void)matchEnded;
- (void)myMatch:(GKMatch *)match didRecieveData:(NSData *)data fromPlayer:(GKPlayer *)player;

@end

extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;

@interface GameKitHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKInviteEventListener>

@property (nonatomic, strong) NSMutableDictionary *playersDictionary;

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

@property (nonatomic, strong) GKMatch *match;
@property (nonatomic, strong) GKTurnBasedMatch *turnMatch;
@property (nonatomic, assign) id <GameKitHelperDelegate> delegate;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameKitHelperDelegate>)delegate;
@end

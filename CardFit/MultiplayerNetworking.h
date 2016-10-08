//
//  MultiplayerNetworking.h
//  CardFit
//
//  Created by Braden Gray on 5/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameKitHelper.h"

@protocol MultiplayerNetworkingProtocol <NSObject>

- (void)matchReady;
- (void)gameStarted;
- (void)isPlayerOne;
- (void)drawCardForPlayer:(NSString *)playerId;
- (void)progress:(float)currentProgress;
- (void)gameInfo:(id)GameInfo;
- (void)matchEnded;
- (void)matchCanceled;

@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>

@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;

- (void)gameLoaded;
- (void)sendGameInfo:(id)gameInfo;
- (void)sendGameInfo:(id)gameInfo toPlayer:(NSString *)playerid;
- (void)sendProgress:(float)currentProgress;
- (void)startGame;
- (void)gameEnded;
- (void)drawCard;
- (void)gameDismissed;

@end

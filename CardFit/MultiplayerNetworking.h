//
//  MultiplayerNetworking.h
//  CardFit
//
//  Created by Braden Gray on 5/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameKitHelper.h"

//#define DETAILS_1_KEY @"Details1"
//#define DETAILS_2_KEY @"Details2"

@protocol MultiplayerNetworkingProtocol <NSObject>

- (void)matchReady;
- (void)gameStarted;
- (void)isPlayerOne;
- (void)drawCard;
- (void)progress:(float)currentProgress;
- (void)gameInfo:(id)GameInfo;
//- (void)card:(NSDictionary *)dictionary;
- (void)matchEnded;
- (void)matchCanceled;

@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>

@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;

- (void)sendGameInfo:(id)gameInfo;
- (void)sendProgress:(float)currentProgress;
- (void)startGame;
- (void)gameEnded;
- (void)drawCard;

@end

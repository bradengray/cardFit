//
//  MultiplayerNetworking.m
//  CardFit
//
//  Created by Braden Gray on 5/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MultiplayerNetworking.h"

#define PLAYER_ID_KEY @"PlayerID"
#define RANDOM_NUMBER_KEY @"randomNumber"

#define DEFAULT_CONTAINER @"iCloud.com.graycode.cardfit"

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

typedef NS_ENUM(NSUInteger, MessageType) {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameReady,
    kMessageTypeGameStart,
    kMessageTypeSessionID,
    kMessageTypeDrawCard,
    kMessageProgressChanged,
    kMessageTypeCard,
    kMessageTypeGameOver
};

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameReady;

typedef struct {
    Message message;
} MessageGameStart;

typedef struct {
    Message message;
    const char *identifier;
} MessageSessionIdentifier;

typedef struct {
    Message message;
} MessageDrawCard;

typedef struct {
    Message message;
    float progress;
} MessageProgressChanged;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

@interface MultiplayerNetworking ()

@property (nonatomic) BOOL session;

@end

@implementation MultiplayerNetworking {
    uint32_t _ourRandomNumber;
    GameState _gameState;
    BOOL _isPlayer1, _receivedAllRandomNumbers;
    
    NSMutableArray *_orderOfPlayers;
}

- (id)init {
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _gameState = kGameStateWaitingForMatch;
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{PLAYER_ID_KEY : [GKLocalPlayer localPlayer].playerID, RANDOM_NUMBER_KEY : @(_ourRandomNumber)}];
    }
    return self;
}

- (void)tryStartGame {
    if (_isPlayer1 && _gameState == kGameStateWaitingForStart) {
        _gameState = kGameStateActive;
        NSLog(@"We are ready to play the game");
        [[NSNotificationCenter defaultCenter] postNotificationName:GKMatchMakerViewControllerDismissed object:nil];
    }
}

- (void)setDelegate:(id<MultiplayerNetworkingProtocol>)delegate {
    _delegate = delegate;
    if (_isPlayer1) {
        [_delegate isPlayerOne];
        [self sendGameReady];
    }
}

#pragma mark - SendData

- (void)sendData:(NSData *)data {
    [self sendData:data toPlayer:nil];
}

- (void)sendData:(NSData *)data toPlayer:(NSString *)player {
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    if (self.session) {
        if (!player) {
            [gameKitHelper.session sendData:data withTransportType:GKTransportTypeReliable completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error:%@", error.localizedDescription);
//                    [self sendData:data toPlayer:player];
                }
            }];
        }
    } else {
        BOOL success;

        if (!player) {
            success = [gameKitHelper.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
        } else {
            [gameKitHelper.match sendData:data toPlayers:@[player] dataMode:GKMatchSendDataReliable error:&error];
        }
        if (!success) {
            NSLog(@"Error sending data:%@", error.localizedDescription);
            [self matchEnded];
        }
    }
}

- (void)sendRandomNumber {
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = _ourRandomNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
    
}

- (void)sendGameReady {
    MessageGameReady message;
    message.message.messageType = kMessageTypeGameReady;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameReady)];
    [self sendData:data];
}

- (void)sendSessionID:(NSString *)identifer {
    MessageSessionIdentifier message;
    message.message.messageType = kMessageTypeSessionID;
    message.identifier = [identifer UTF8String];
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSessionIdentifier)];
    [self sendData:data];
}

- (void)drawCard {
    MessageDrawCard message;
    message.message.messageType = kMessageTypeDrawCard;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageDrawCard)];
    [self sendData:data];
}

- (void)sendProgress:(float)currentProgress {
    MessageProgressChanged message;
    message.message.messageType = kMessageProgressChanged;
    message.progress = currentProgress;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageProgressChanged)];
    [self sendData:data];
}

-(void)startGame {
    MessageGameStart message;
    message.message.messageType = kMessageTypeGameStart;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameStart)];
    [self sendData:data];
}

- (void)gameEnded {
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}

- (void)sendSessionIdentifier:(NSString *)identifier {
    NSData *data = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendGameInfo:(id)gameInfo toPlayer:(NSString *)playerid {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfo];
    if (!playerid) {
        [self sendData:data];
    } else {
        [self sendData:data];
    }
}

- (void)sendGameInfo:(id)gameInfo {
    [self sendGameInfo:gameInfo toPlayer:nil];
}

#pragma mark - Receive Data

- (void)processReceivedRandomNumber:(NSDictionary *)randomNumberDetails {
    //1
    if ([_orderOfPlayers containsObject:randomNumberDetails]) {
        [_orderOfPlayers removeObjectAtIndex:[_orderOfPlayers indexOfObject:randomNumberDetails]];
    }
    //2
    [_orderOfPlayers addObject:randomNumberDetails];
    
    //3
    NSSortDescriptor *sortByRandomNumber = [NSSortDescriptor sortDescriptorWithKey:RANDOM_NUMBER_KEY ascending:NO];
    NSArray *sortDescriptors = @[sortByRandomNumber];
    [_orderOfPlayers sortUsingDescriptors:sortDescriptors];
    
    //4
    if ([self allRandomNumbersAreReceived]) {
        _receivedAllRandomNumbers = YES;
    }
}

- (BOOL)allRandomNumbersAreReceived {
    NSMutableArray *receivedRandomNumbers = [NSMutableArray array];
    
    for (NSDictionary *dict in _orderOfPlayers) {
        [receivedRandomNumbers addObject:dict[RANDOM_NUMBER_KEY]];
    }
    
    NSArray *arrayOfUniqueRandomNumbers = [[NSSet setWithArray:receivedRandomNumbers] allObjects];
    
    if (arrayOfUniqueRandomNumbers.count == [GameKitHelper sharedGameKitHelper].match.players.count + 1) {
        return YES;
    }
    return NO;
}

- (void)isLocalPlayerPlayer1 {
    NSDictionary *dictionary = _orderOfPlayers[0];
    if ([dictionary[PLAYER_ID_KEY] isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        [GKGameSession createSessionInContainer:DEFAULT_CONTAINER
                                      withTitle:@"Game"
                            maxConnectedPlayers:2
                              completionHandler:^(GKGameSession * _Nullable session, NSError * _Nullable error) {
                                  if (error) {
                                      NSLog(@"Error: %@", error.localizedDescription);
                                  }
                                  [session getShareURLWithCompletionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
                                      NSLog(@"%@", url);
                                  }];
                                  NSLog(@"Session:%@", session.identifier);
                                  [GameKitHelper sharedGameKitHelper].session = session;
                                  [self loadSessionForIdentifier:session.identifier];
                                  NSLog(@"Sending session");
                                  [self sendSessionID:session.identifier];
                              }];
        NSLog(@"I'm player 1");
        _isPlayer1 = YES;
        [self.delegate isPlayerOne];
//        return YES;
    }
//    return NO;
}

- (void)loadSessionForIdentifier:(NSString *)identifier {
    [GKGameSession loadSessionWithIdentifier:identifier completionHandler:^(GKGameSession * _Nullable session, NSError * _Nullable error) {
        NSLog(@"We have a session:%@", session);
        __block GKGameSession *mySession = session;
        [session setConnectionState:GKConnectionStateConnected completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error connecting:%@", error.localizedDescription);
            } else {
                NSLog(@"I is now connected");
                NSArray *array = [mySession playersWithConnectionState:GKConnectionStateConnected];
                if (array) {
                    NSLog(@"yeah we did");
                    for (GKCloudPlayer *player in array) {
                        NSLog(@"Player:%@", player.playerID);
                    }
                }
            }
            self.session = YES;
        }];
        [GameKitHelper sharedGameKitHelper].session = session;
    }];
}

#pragma mark GameKitHelperDelegate

- (void)matchStarted {
    NSLog(@"Match has started successfully");
    if (_receivedAllRandomNumbers) {
        _gameState = kGameStateWaitingForStart;
    } else {
        _gameState = kGameStateWaitingForRandomNumber;
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

//- (void)sessionStarted {
//    NSLog(@"Session has started successfully");
//    [self sendSessionID:[GameKitHelper sharedGameKitHelper].session.identifier];
//}

- (void)matchEnded {
    NSLog(@"Match has ended");
    [_delegate matchEnded];
}

- (void)matchCanceled {
    [_delegate matchCanceled];
}

- (void)myMatch:(GKMatch *)match didRecieveData:(NSData *)data fromPlayer:(GKPlayer *)player {
    //1
    Message *message = (Message *)[data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        MessageRandomNumber *messageRandomNumber = (MessageRandomNumber *)[data bytes];
        
        NSLog(@"Received random number:%d", messageRandomNumber->randomNumber);
        
        BOOL tie = NO;
        if (messageRandomNumber->randomNumber == _ourRandomNumber) {
            //2
            NSLog(@"Tie");
            tie = YES;
            _ourRandomNumber = arc4random();
            [self sendRandomNumber];
        } else {
            //3
            NSDictionary *dictionary = @{PLAYER_ID_KEY : player.playerID, RANDOM_NUMBER_KEY : @(messageRandomNumber->randomNumber)};
            [self processReceivedRandomNumber:dictionary];
        }
        
        //4
        if (_receivedAllRandomNumbers) {
            [self isLocalPlayerPlayer1];
        }
        
        if (!tie && _receivedAllRandomNumbers) {
            //5
            if (_gameState == kGameStateWaitingForRandomNumber) {
                _gameState = kGameStateWaitingForStart;
            }
            [self tryStartGame];
        }
    } else if (message->messageType == kMessageTypeGameReady) {
        NSLog(@"Game ready message recieved");
        _gameState = kGameStateActive;
        [[NSNotificationCenter defaultCenter] postNotificationName:GKMatchMakerViewControllerDismissed object:nil];
        [self.delegate matchReady];
    } else if (message->messageType == kMessageTypeGameStart) {
        [self.delegate gameStarted];
    } else if (message->messageType == kMessageTypeDrawCard) {
        NSLog(@"Draw Card message received");
        [self.delegate drawCard];
    } else if (message->messageType == kMessageProgressChanged) {
        NSLog(@"Progress Changed");
        MessageProgressChanged *progressMessage = (MessageProgressChanged *)[data bytes];
        [self.delegate progress:progressMessage->progress];
    } else if (message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        [self.delegate matchEnded];
    } else if (message->messageType == kMessageTypeSessionID) {
        NSLog(@"Session ID message recieved");
        MessageSessionIdentifier *sessionID = (MessageSessionIdentifier *)[data bytes];
        NSString *ID = [NSString stringWithUTF8String:sessionID->identifier];
        [self loadSessionForIdentifier:ID];
    } else {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.delegate gameInfo:object];
    }
}

@end

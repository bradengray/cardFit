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

//#define DEFAULT_CONTAINER @"iCloud.com.graycode.cardfit"

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

typedef NS_ENUM(uint32_t, MessageType) {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameLoaded,
    kMessageTypeGameReady,
    kMessageTypeGameStart,
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
} MessageGameLoaded;

typedef struct {
    Message message;
} MessageGameReady;

typedef struct {
    Message message;
} MessageGameStart;

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

@implementation MultiplayerNetworking {
    uint32_t _ourRandomNumber;
    GameState _gameState;
    BOOL _isPlayer1, _receivedAllRandomNumbers;
    
    NSMutableArray *_orderOfPlayers;
    NSMutableArray *_playersReady;
}

- (id)init {
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _gameState = kGameStateWaitingForMatch;
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{PLAYER_ID_KEY : [GKLocalPlayer localPlayer].playerID, RANDOM_NUMBER_KEY : @(_ourRandomNumber)}];
        _playersReady = [NSMutableArray array];
    }
    return self;
}

- (void)tryStartGame {
    if (_gameState == kGameStateWaitingForStart) {
        _gameState = kGameStateActive;
        [[NSNotificationCenter defaultCenter] postNotificationName:GKMatchMakerViewControllerDismissed object:nil];
    }
}

#pragma mark - SendData

- (void)gameLoaded {
    if (!_isPlayer1 && _gameState == kGameStateActive) {
        [self sendGameLoaded];
    }
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GameKitHelper sharedGameKitHelper].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}

- (void)sendData:(NSData *)data toPlayer:(NSString *)playerId {
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    BOOL success;

    if (!playerId) {
        success = [gameKitHelper.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    } else {
        success = [gameKitHelper.match sendData:data toPlayers:@[[gameKitHelper.playersDictionary objectForKey:playerId]] dataMode:GKMatchSendDataReliable error:&error];
    }
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}

- (void)sendRandomNumber {
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = _ourRandomNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameLoaded {
    MessageGameLoaded message;
    message.message.messageType = kMessageTypeGameLoaded;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameLoaded)];
    [self sendData:data];
}

- (void)sendGameReady {
    MessageGameReady message;
    message.message.messageType = kMessageTypeGameReady;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameReady)];
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

- (void)gameDismissed {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper.match disconnect];
    gameKitHelper.match = nil;
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
        _isPlayer1 = YES;
    }
}

- (void)playerIsReady:(GKPlayer *)player {
    if (![_playersReady containsObject:player]) {
        [_playersReady addObject:player];
    }
    if ([_playersReady count] == [GameKitHelper sharedGameKitHelper].match.players.count && _isPlayer1) {
        [self.delegate isPlayerOne];
        [self sendGameReady];
    }
}

#pragma mark GameKitHelperDelegate

- (void)matchStarted {
    if (_receivedAllRandomNumbers) {
        _gameState = kGameStateWaitingForStart;
        [self tryStartGame];
    } else {
    _gameState = kGameStateWaitingForRandomNumber;
    }
    [self sendRandomNumber];
}

- (void)matchEnded {
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
        
        BOOL tie = NO;
        if (messageRandomNumber->randomNumber == _ourRandomNumber) {
            //2
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
    } else if (message->messageType == kMessageTypeGameLoaded) {
        [self playerIsReady:player];
    } else if (message->messageType == kMessageTypeGameReady) {
        [self.delegate matchReady];
    } else if (message->messageType == kMessageTypeGameStart) { //Called when game actually begins
        [self.delegate gameStarted];
    } else if (message->messageType == kMessageTypeDrawCard) {
        [self.delegate drawCardForPlayer:player.playerID];
    } else if (message->messageType == kMessageProgressChanged) {
        MessageProgressChanged *progressMessage = (MessageProgressChanged *)[data bytes];
        [self.delegate progress:progressMessage->progress];
    } else if (message->messageType == kMessageTypeGameOver) {
        [self.delegate matchEnded];
    } else {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.delegate gameInfo:object];
    }
}

@end

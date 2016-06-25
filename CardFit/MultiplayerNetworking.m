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
    kMessageTypeDrawCard,
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
} MessageDrawCard;

//typedef struct {
//    Message message;
//    int details1;
//    int details2;
//} MessageCard;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

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
        [self sendGameReady];
    }
}

#pragma mark - SendData

- (void)sendData:(NSData *)data {
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    
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

- (void)sendGameInfo:(id)gameInfo {
//    PlayingCardSettings *settings = (PlayingCardSettings *)gameInfo;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfo];
    [self sendData:data];
}

//- (void)sendGameDetail:(NSDictionary *)gameDetail {
//    MessageCard message;
//    message.message.messageType = kMessageTypeCard;
//    message.details1 = [[gameDetail objectForKey:DETAILS_1_KEY] intValue];
//    message.details2 = [[gameDetail objectForKey:DETAILS_2_KEY] intValue];
//    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageCard)];
//    [self sendData:data];
//}

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

- (BOOL)isLocalPlayerPlayer1 {
    NSDictionary *dictionary = _orderOfPlayers[0];
    if ([dictionary[PLAYER_ID_KEY] isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        NSLog(@"I'm player 1");
        [self.delegate isPlayerOne];
        return YES;
    }
    return NO;
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

- (void)matchEnded {
    NSLog(@"Match has ended");
    [_delegate matchEnded];
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
            _isPlayer1 = [self isLocalPlayerPlayer1];
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
        [self.delegate matchReady];
    } else if (message->messageType == kMessageTypeGameStart) {
        [self.delegate gameStarted];
    } //else if (message->messageType == kMessageTypeCard) {
//        MessageCard *messageCard = (MessageCard *)[data bytes];
//        NSDictionary *dictionary = @{DETAILS_1_KEY : @(messageCard->details1), DETAILS_2_KEY : @(messageCard->details2)};
//        NSLog(@"Back D1: %u, D2: %u", messageCard->details1, messageCard->details2);
//        [self.delegate card:dictionary];
     else if (message->messageType == kMessageTypeDrawCard) {
        NSLog(@"Draw Card message received");
        [self.delegate drawCard];
    } else if (message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        [self.delegate matchEnded];
    } else {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.delegate gameInfo:object];
    }
}

@end

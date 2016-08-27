//
//  GameKitHelper.m
//  CardFit
//
//  Created by Braden Gray on 5/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()

@property (nonatomic) BOOL enableGameCenter;
@property (nonatomic) BOOL matchStarted;
@property (nonatomic, strong) GKInvite *pendingInvite;

@end

@implementation GameKitHelper

#define DEFAULT_CONTAINER @"iCloud.com.graycode.cardfit"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authencticated";
NSString *const PresentGKMatchMakerViewController = @"present_match_maker_view_controller";

- (id)init {
    self = [super init];
    if (self) {
        self.enableGameCenter = YES;
//        [GKGameSession createSessionInContainer:DEFAULT_CONTAINER
//                                      withTitle:@"Game"
//                            maxConnectedPlayers:2
//                              completionHandler:^(GKGameSession * _Nullable session, NSError * _Nullable error) {
//                                  if (error) {
//                                      NSLog(@"Error:%@", error.localizedDescription);
//                                  }
//                                  NSLog(@"Session:%@", session.identifier);
//                              }];
        [[GKLocalPlayer localPlayer] registerListener:self];
        [GKGameSession addEventListener:self];
    }
    return self;
}

- (void)dealloc {
    [[GKLocalPlayer localPlayer] unregisterListener:self];
    [GKGameSession removeEventListener:self];
}

+ (instancetype)sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (void)authenticateLocalPlayer {
    // 1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        return;
    }
    //2
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        if (viewController != nil) {
            //4
            [self setAuthenticationViewController:viewController];
        } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            self.enableGameCenter = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];

        } else {
            //6
            self.enableGameCenter = NO;
        }
    };
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %lu players...", (unsigned long)_match.players.count);
    
    NSMutableArray *playerIDs = [[NSMutableArray alloc] init];
    for (GKPlayer *player in _match.players) {
        [playerIDs addObject:player.playerID];
    }
    
    [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray<GKPlayer *> * _Nullable players, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            _matchStarted = NO;
            [_delegate matchEnded];
        } else {
            // Populate players dict
            _playersDictionary = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found Player: %@", player.alias);
                [_playersDictionary setObject:player forKey:player.playerID];
            }
            [_playersDictionary setObject:[GKLocalPlayer localPlayer] forKey:[GKLocalPlayer localPlayer].playerID];
            
            // Notify delegate match can begin.
            _matchStarted = YES;
            [_delegate matchStarted];
        }
    }];
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
    }
}

- (void)setLastError:(NSError *)lastError {
    _lastError = [lastError copy];
    if (_lastError) {
        NSLog(@"GameKitHelper Error: %@", [[_lastError userInfo] description]);
    }
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameKitHelperDelegate>)delegate {
    if (!self.enableGameCenter) {
        return;
    }
    
    self.matchStarted = NO;
    self.match = nil;
    self.delegate = delegate; //networking engine
    [viewController dismissViewControllerAnimated:NO completion:nil]; //mian page
    GKMatchmakerViewController *mmvc;
    
    if (self.pendingInvite != nil) { //no invites
        mmvc = [[GKMatchmakerViewController alloc] initWithInvite:self.pendingInvite];
    } else {
        
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
        
        mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    }
    
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
    
    self.pendingInvite = nil;
}

#pragma mark - MatchMakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate matchCanceled];
}

// Matchmaking has failed with error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [GKGameSession createSessionInContainer:DEFAULT_CONTAINER
                                  withTitle:@"Game"
                        maxConnectedPlayers:2
                          completionHandler:^(GKGameSession * _Nullable session, NSError * _Nullable error) {
                              if (error) {
                                  NSLog(@"Error: %@", error.localizedDescription);
                              }
                              NSLog(@"Session:%@", session.identifier);
                              self.session = session;
                          }];
    _match = match;
    _match.delegate = self;
    if (!self.matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}

- (BOOL)isICloudAvailable {
    if ([[NSFileManager defaultManager] ubiquityIdentityToken]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - GKMatchDelegate

// The match received date sent from player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player {
    if (_match != match) {
        return;
    }
    
    [_delegate myMatch:match didRecieveData:data fromPlayer:player];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(nonnull GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state {
    if (_match != match) {
        return;
    }
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!self.matchStarted && match.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            break;
            
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected");
            self.matchStarted = NO;
            [self.delegate matchEnded];
            break;
            
        case GKPlayerStateUnknown:
            NSLog(@"UnknownError");
            self.matchStarted = NO;
            [self.delegate matchEnded];
            break;
    }
}

// The match was unable to be established with any players due to an error
- (void)match:(GKMatch *)match didFailWithError:(nullable NSError *)error {
    if (self.match != match) {
        return;
    }
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    self.matchStarted = NO;
    [self.delegate matchEnded];
}

#pragma mark - GKLocalPlayerListener

- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite {
    self.pendingInvite = invite;
    [[NSNotificationCenter defaultCenter] postNotificationName:PresentGKMatchMakerViewController object:nil];
}

- (void)player:(GKPlayer *)player didRequestMatchWithRecipients:(NSArray<GKPlayer *> *)recipientPlayers {
    NSLog(@"Did request invite");
}

#pragma mark = GKGameSessionEventListener

- (void)session:(GKGameSession *)session didReceiveData:(NSData *)data fromPlayer:(GKCloudPlayer *)player {
#warning send some data
}

- (void)session:(GKGameSession *)session player:(GKCloudPlayer *)player didChangeConnectionState:(GKConnectionState)newState {
    if (newState == GKConnectionStateNotConnected) {
        //Do Something
    } else {
        //Do Something Else
    }
}

@end

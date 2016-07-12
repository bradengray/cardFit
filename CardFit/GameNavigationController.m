//
//  GameNavigationController.m
//  CardFit
//
//  Created by Braden Gray on 5/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "GameNavigationController.h"
#import "GameKitHelper.h"

@implementation GameNavigationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Listen to radio station for message to present authentication view controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    //Start authenticating local player
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void)showAuthenticationViewController { //Called when radio station sends message to present Authentification view controller
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    //Present authentification view controller
    [self.topViewController presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)dealloc { //Stop listening to radio station
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

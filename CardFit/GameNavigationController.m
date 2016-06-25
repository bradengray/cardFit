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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void)showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    [self.topViewController presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

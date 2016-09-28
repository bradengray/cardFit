//
//  GameDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "GameDataController.h"

@implementation GameDataController

//Create new data when multiplayer is set
- (void)setMultiplayer:(BOOL)multiplayer {
    _multiplayer = multiplayer;
    self.data = [self createData];
}

#pragma mark - Abstract Methods

- (NSInteger)rowForSelectedNumberOfCards { //Abstract
    return 0;
}

- (NSUInteger)pointsForCard:(Card *)card { //Abstract
    return 0;
}

- (NSString *)labelForCard:(Card *)card { //Abstract
    return nil;
}

- (void)settingsForGameInfo:(id)gameInfo { //Abstract
    return;
}

- (Settings *)getSettings { //Abstract
    return nil;
}

@end

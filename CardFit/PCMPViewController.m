//
//  PCMPViewController.m
//  CardFit
//
//  Created by Braden Gray on 9/15/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PCMPViewController.h"
#import "PlayingCardGameDataController.h"

@interface PCMPViewController ()

@property (nonatomic, strong) PlayingCardGameDataController *playingCardDataSource;

@end

@implementation PCMPViewController

#pragma mark - Initialization

- (PlayingCardGameDataController *)playingCardDataSource {
    if (!_playingCardDataSource) {
        _playingCardDataSource = [[PlayingCardGameDataController alloc] init];
    }
    return _playingCardDataSource;
}

- (GameDataController *)createDataSource {
    return self.playingCardDataSource;
}

@end

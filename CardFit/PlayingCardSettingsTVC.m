//
//  PlayingCardSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsTVC.h"
#import "PlayingCardSettings.h"

@interface PlayingCardSettingsTVC ()

@property (nonatomic, strong) PlayingCardSettings *playingCardSettings;

@end

@implementation PlayingCardSettingsTVC

#pragma mark - Initialization

- (PlayingCardSettings *)playingCardSettings {
    if (!_playingCardSettings) {
        _playingCardSettings = [[PlayingCardSettings alloc] init];
    }
    return _playingCardSettings;
}

- (Settings *)createSettings { //Return Playing Card Settings object to super class
    return self.playingCardSettings;
}

@end

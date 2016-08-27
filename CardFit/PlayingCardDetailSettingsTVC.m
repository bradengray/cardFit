//
//  PlayingCardDetailSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 6/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDetailSettingsTVC.h"
#import "PlayingCardSettings.h"

@interface PlayingCardDetailSettingsTVC ()

@property (nonatomic, strong) PlayingCardSettings *playingCardSettings;

@end

@implementation PlayingCardDetailSettingsTVC

#pragma mark - Initialization

- (PlayingCardSettings *)playingCardSettings {
    if (!_playingCardSettings) {
        _playingCardSettings = [[PlayingCardSettings alloc] init];
    }
    return _playingCardSettings;
}

- (Settings *)createSettings { //Return Playing Card Settings
    return self.playingCardSettings;
}

@end

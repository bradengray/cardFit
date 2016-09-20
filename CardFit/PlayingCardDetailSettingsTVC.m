//
//  PlayingCardDetailSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDetailSettingsTVC.h"
#import "PlayingCardDetailSettingsController.h"

@interface PlayingCardDetailSettingsTVC ()

@property (nonatomic, strong) PlayingCardDetailSettingsController *playingCardDataSource; //Stores data source object

@end

@implementation PlayingCardDetailSettingsTVC
//Lazy instanticate data source
- (PlayingCardDetailSettingsController *)playingCardDataSource {
    if (!_playingCardDataSource) {
        _playingCardDataSource = [[PlayingCardDetailSettingsController alloc] init];
        _playingCardDataSource.selectedIndexPath = self.selectedIndexPath;
    }
    return _playingCardDataSource;
}

//Creates data source
- (SettingsDataController *)createDataSource { //Abstract
    return self.playingCardDataSource;
}

@end

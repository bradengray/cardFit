//
//  PlayingCardSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsTVC.h"
#import "PlayingCardMainSettingsController.h"

@interface PlayingCardSettingsTVC ()

@property (nonatomic, strong) PlayingCardMainSettingsController *playingCardDataSource; //Stores data source object

@end

@implementation PlayingCardSettingsTVC

#pragma mark - Properties
//Lazy instantiate data source object
- (PlayingCardMainSettingsController *)playingCardDataSource {
    if (!_playingCardDataSource) {
        _playingCardDataSource = [[PlayingCardMainSettingsController alloc] init];
    }
    return _playingCardDataSource;
}

#pragma mark - Abstract Methods

- (DataController *)createDataSource { //Abstract returns dataSource
    return self.playingCardDataSource;
}

@end

//
//  PlayingCardSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsTVC.h"
#import "PlayingCardSettings.h"

@implementation PlayingCardSettingsTVC

#pragma mark - Initialization

- (Settings *)createSettings {
    return [PlayingCardSettings sharedPlayingCardSettings];
}

@end

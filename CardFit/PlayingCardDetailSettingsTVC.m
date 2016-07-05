//
//  PlayingCardDetailSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 6/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDetailSettingsTVC.h"
#import "PlayingCardSettings.h"

@implementation PlayingCardDetailSettingsTVC

- (Settings *)createSettings {
    return [PlayingCardSettings sharedPlayingCardSettings];
}

@end

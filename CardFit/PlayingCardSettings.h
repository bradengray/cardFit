//
//  PlayingCardSettings.h
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
//#import "CardFitPlayingCard.h"

@interface PlayingCardSettings : Settings <NSCoding>

//Creates a shared instance of PlayingCardSettings it is important to note that the shared instance is by default set to store values in NSUserDefaults
//When decoding an PlayingCardSettings object it will replace your sharedSettings object and will not create a new object.
+(instancetype)sharedPlayingCardSettings;

//Bool for whether or not deck should have jokers;
@property (nonatomic) BOOL jokers;

@end

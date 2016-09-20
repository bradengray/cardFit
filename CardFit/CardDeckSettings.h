//
//  CardDeckSettings.h
//  CardFit
//
//  Created by Braden Gray on 9/14/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Settings.h"

#define NUMBER_OF_CARDS @"Number Of Cards"
#define MULTIPLAYER_NUMBER_OF_CARDS @"Multiplayer Number Of Cards"

@interface CardDeckSettings : Settings

//note should only store values containted in numberOfCardsKeys
@property (nonatomic, strong) NSString *numberOfCards; //Stores number of cards selected

@property (nonatomic, strong) NSArray *numberOfCardsKeys; //Array of NSStrings

//Returns the integer vale for the numberOfCards selected
- (NSUInteger)getNumberOfCards; //Abstract

@end

//
//  CardFitPlayingCard.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card <NSCoding>

//Integer telling suit of card. Spade = 0, Club = 1, Heart = 2, Diamond = 3.
@property (nonatomic) NSUInteger suit;
//Integer telling rank of card. Ace = 1, 2-10 = 2-10, Jack = 11, Queen = 12, King = 13, Joker = 14;
@property (nonatomic) NSUInteger rank;

//returns the maximum integer values for suit and rank.
+ (NSUInteger)maxRank;
+ (NSUInteger)maxSuit;

@end

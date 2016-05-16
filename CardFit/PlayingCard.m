//
//  DefaultPlayingCard.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#pragma mark - Class Methods

+ (NSArray *)validRankStrings { //Array of valid Strings used for Ranks.
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"Joker"];
}

+ (NSArray *)validSuitStrings { //Array of valid Strings used for Suits.
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

+ (NSUInteger)maxRank { //returns max integer value for Rank.
    return [[self validRankStrings] count] - 1;
}

+ (NSUInteger)maxSuit { //returns max integer value for Suit.
    return [[self validSuitStrings] count] - 1;
}

#pragma mark - Inhereted Methods

- (NSString *)contents { //Overwrites inherited contents property from Card.h
    //Get's rank string and suit string for card and appends them together into one string for contents.
    return [[PlayingCard validRankStrings][self.rank] stringByAppendingString:[PlayingCard validSuitStrings][self.suit]];
}

#pragma mark - Properties

//As long as suit is less than maxsuit then set suit.
- (void)setSuit:(NSUInteger)suit {
    if (suit <= [PlayingCard maxSuit]) {
        _suit = suit;
    }
}

//As long as rank is less than max Rank then set rank.
- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end

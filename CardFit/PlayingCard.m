//
//  CardFitPlayingCard.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCard.h"
//#import "PlayingCardSettings.h"

#define SUIT_KEY @"Suit Key"
#define RANK_KEY @"Rank Key"

@interface PlayingCard ()

//@property (nonatomic, strong) PlayingCardSettings *settings;

@end

@implementation PlayingCard

#pragma mark - NSCoding Protocol

//Called when NSCoder encodes this object using NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.suit forKey:SUIT_KEY];
    [aCoder encodeInteger:self.rank forKey:RANK_KEY];
}

//Called when NSCoder decodes this object using NSKeyedUnarchiver
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.suit = [aDecoder decodeIntegerForKey:SUIT_KEY];
        self.rank = [aDecoder decodeIntegerForKey:RANK_KEY];
    }
    return self;
}

#pragma mark - Initialization

////Creates a shared instance of our playing Card Settings
//- (PlayingCardSettings *)settings {
//    return [PlayingCardSettings sharedPlayingCardSettings];
//}

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

////Returns points for our card from playing card settings based on it's rank
//- (NSUInteger)points {
//    return [self.settings pointsForRank:self.rank];
//}
//
////Returns a label for our card from our playing card settings
//- (NSString *)label {
//    return [self.settings labelForSuit:self.suit andRank:self.rank];
//}

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

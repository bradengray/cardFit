//
//  DefaultPlayingCard.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitPlayingCard.h"
#import "PlayingCardSettings.h"

#define SUIT_KEY @"Suit Key"
#define RANK_KEY @"Rank Key"

@interface CardFitPlayingCard ()

@property (nonatomic, strong) PlayingCardSettings *settings;

@end

@implementation CardFitPlayingCard

#pragma mark - NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.suit forKey:SUIT_KEY];
    [aCoder encodeInteger:self.rank forKey:RANK_KEY];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.suit = [aDecoder decodeIntegerForKey:SUIT_KEY];
        self.rank = [aDecoder decodeIntegerForKey:RANK_KEY];
    }
    return self;
}

#pragma mark - Initialization

- (PlayingCardSettings *)settings {
    return [PlayingCardSettings sharedPlayingCardSettings];
}

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
    return [[CardFitPlayingCard validRankStrings][self.rank] stringByAppendingString:[CardFitPlayingCard validSuitStrings][self.suit]];
}

#pragma mark - Properties

- (NSUInteger)reps {
    if (self.rank == 1) {
        return self.settings.acesReps;
    } else if (self.rank == 11) {
        return self.settings.jacksReps;
    } else if (self.rank == 12) {
        return self.settings.queensReps;
    } else if (self.rank == 13) {
        return self.settings.kingsReps;
    } else if (self.rank == 14) {
        return self.settings.jokersReps;
    } else {
        return self.rank;
    }
}

- (NSString *)label {
    return [self.settings labelForSuit:self.suit andRank:self.rank];
}

//As long as suit is less than maxsuit then set suit.
- (void)setSuit:(NSUInteger)suit {
    if (suit <= [CardFitPlayingCard maxSuit]) {
        _suit = suit;
    }
}

//As long as rank is less than max Rank then set rank.
- (void)setRank:(NSUInteger)rank {
    if (rank <= [CardFitPlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
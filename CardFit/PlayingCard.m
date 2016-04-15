//
//  DefaultPlayingCard.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

+ (NSArray *)validRankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"Joker"];
}

+ (NSArray *)validSuitStrings {
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

+ (NSUInteger)maxRank {
    return [[self validRankStrings] count] - 1;
}

+ (NSUInteger)maxSuit {
    return [[self validSuitStrings] count] - 1;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard validRankStrings];
    NSArray *suitStrings = [PlayingCard validSuitStrings];
    return [rankStrings[self.rank] stringByAppendingString:suitStrings[self.suit]];
}

#pragma mark - Initialization

@synthesize suit = _suit;

- (void)setSuit:(NSUInteger)suit {
    if (suit <= [PlayingCard maxSuit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end

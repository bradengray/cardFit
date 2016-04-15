//
//  DefaultPlayingCardDeck.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init {
    self = [super init];
    
    for (int suit = 0; suit <= [PlayingCard maxSuit]; suit++) {
        for (int rank = 1; rank <= [PlayingCard maxRank]; rank++) {
            if (!(rank == 14) || (rank == 14 && suit < 2)) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    return self;
}

@end

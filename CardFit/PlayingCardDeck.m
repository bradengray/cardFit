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

#pragma mark - Initialization

- (instancetype)initWithNumberOfDecks:(NSUInteger)numberOfDecks withJokers:(BOOL)jokers { //designated initialiazer
    self = [super init];
    
    //Cycle through number of decks, suits, ranks, and jokers to create a deck or decks of cards.
    for (int decks = 0; decks < numberOfDecks; decks++) {
        for (int suit = 0; suit <= [PlayingCard maxSuit]; suit++) {
            for (int rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                if (rank != 14 || (rank == 14 && suit < 2)) {
                    if (rank !=14 || (rank == 14 && jokers)) {
                        PlayingCard *card = [[PlayingCard alloc] init];
                        card.rank = rank;
                        card.suit = suit;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end

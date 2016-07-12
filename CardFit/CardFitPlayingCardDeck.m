//
//  CardFitPlayingCardDeck.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitPlayingCardDeck.h"
#import "PlayingCardSettings.h"

@implementation CardFitPlayingCardDeck

#pragma mark - Initialization

#define STANDARD_NUMBER_OF_CARDS 52

//Called as the designated initializer
- (instancetype)initWithNumberOfCards:(NSUInteger)numberOfCards { //designated initialiazer
    self = [super init];
    //Get the number of decks needed to satisfy the number of cards requested
    NSUInteger numberOfDecks;
    if (numberOfCards > STANDARD_NUMBER_OF_CARDS) {
        numberOfDecks = numberOfCards/STANDARD_NUMBER_OF_CARDS;
    } else {
        numberOfDecks = 1;
    }
    
    //Cycle through number of decks, suits, ranks, and jokers to create a deck or decks of cards.
    for (int decks = 0; decks < numberOfDecks; decks++) {
        for (int suit = 0; suit <= [CardFitPlayingCard maxSuit]; suit++) {
            for (int rank = 1; rank <= [CardFitPlayingCard maxRank]; rank++) {
                if (rank != 14 || (rank == 14 && suit < 2)) {
                    //If the deck has jokers create two Joker cards
                    if (rank !=14 || (rank == 14 && [PlayingCardSettings sharedPlayingCardSettings].jokers)) {
                        CardFitPlayingCard *card = [[CardFitPlayingCard alloc] init];
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

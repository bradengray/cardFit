//
//  Deck.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Deck.h"

@interface Deck ()

@property (nonatomic, strong) NSMutableArray *cards; //of Cards

@end

@implementation Deck

#pragma mark - Methods

- (NSMutableArray *)cards { //Lazy Instantiate the cards.
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop { //Add cards at index 0 or just add card.
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (void)addCard:(Card *)card { //Add Card
    [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard {
    Card *randomCard = nil;

    //If there is a card count then get a random number, modulo by the card count, and choose the card at that index. 
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

@end

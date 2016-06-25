//
//  DefaultPlayingCardDeck.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Deck.h"
#import "CardFitPlayingCard.h"

@interface CardFitPlayingCardDeck : Deck

//Using a designated initializer to control the number of decks created and whether or not the decks have Jokers.
//This will return standard 52 card decks. 54 If you include jokers.
- (instancetype)initWithNumberOfDecks:(NSUInteger)numberOfDecks withJokers:(BOOL)jokers; //Designated Initializer

@end

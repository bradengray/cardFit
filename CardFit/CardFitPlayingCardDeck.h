//
//  CardFitPlayingCardDeck.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Deck.h"
#import "CardFitPlayingCard.h"

@interface CardFitPlayingCardDeck : Deck

//This will return standard 52 card decks. 54 If your playing card settings includes jokers.
- (instancetype)initWithNumberOfCards:(NSUInteger)numberOfCards; //Designated Initializer

@end

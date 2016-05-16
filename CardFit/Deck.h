//
//  Deck.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop; //Adds card object to deck at index 0.
- (void)addCard:(Card *)card; //Adds a card object to deck.

//Draws a random card from the deck of initialized cards.
- (Card *)drawRandomCard;

@end

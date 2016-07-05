//
//  CardFitGame.h
//  CardFit
//
//  Created by Braden Gray on 4/18/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Card.h"
#import "CardFitCard.h"
#import "Deck.h"

@interface CardFitGame : NSObject

@property (nonatomic, readonly) NSInteger score; //Returns a score for the game based on totalReps and gameTime (totalReps / gametime) * 100.
@property (nonatomic, strong) NSString *gameTime; //Returns a string containing the current time elapsed during gameplay.
@property (nonatomic) NSInteger totalPoints; //Accumulates the total number of reps that have happened to date in game.
@property (nonatomic) BOOL paused; //pauses the timer in the game.

//- (Card *)drawCardAtIndex:(NSUInteger)index; //Draws a card for the deck in the game at a specific index.
- (CardFitCard *)drawCard; //Draws a card for the deck in the game.
- (instancetype)initWithCardCount:(NSUInteger)cardCount withDeck:(Deck *)deck; //designated Initializer

@end

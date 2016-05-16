//
//  CardFitGame.m
//  CardFit
//
//  Created by Braden Gray on 4/18/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitGame.h"
#import "Timer.h"

@interface CardFitGame ()

@property (nonatomic ,readwrite) NSInteger score; //writes to score
@property (nonatomic, strong) NSMutableArray *cards; //of cards
@property (nonatomic, strong) Deck *deck; //Instance of Deck.h
@property (nonatomic, strong) Timer *timer; //Instance of Timer.h

@end

@implementation CardFitGame

#pragma mark - Initialization

- (instancetype)initWithCardCount:(NSUInteger)cardCount withDeck:(Deck *)deck { //designated initializer
    self = [super init];
    
    //Draw cards from the deck given based on the cardCount.
    if (self) {
        for (int i; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            //If there is a card add it to self.cards.
            if (card) {
                [self.cards addObject:card];
            } else {
                //else then the deck does not contain enough cards to initialize. Throw Error.
                NSLog(@"Error: Not enough cards in deck. Designated Initialzier CardFitGame.h");
                self = nil;
                break;
            }
        }
        //Keep the deck given as self.deck.
        _deck = deck;
    }
    return self;
}

#pragma mark - Properties

- (NSMutableArray *)cards { //Lazy Instantiate cards.
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (Timer *)timer { //Lazy Instantiate timer.
    if (!_timer) {
        _timer = [[Timer alloc] init];
    }
    return _timer;
}

- (void)setPaused:(BOOL)paused { //When paused set timer.active equal to paused.
    _paused = paused;
    self.timer.active = paused;
}

- (NSString *)gameTime { //Lazy Instantiate gameTime.
    //If gameTime does not exist start timer.
    if (!_gameTime) {
        self.timer.active = YES;
    }
    //set gametime equal to formatted string from Timer.h
    _gameTime = self.timer.timeFormattedForHourMinuteSecondsMiliseconds;
    return _gameTime;
}

- (void)setTotalReps:(NSInteger)totalReps { //adds to reps to existing number of reps.
    _totalReps += totalReps;
}

- (NSInteger)score { //Score is totalReps / time * 100
    _score = self.totalReps / self.timer.timeElapsed *100;
    return _score;
}

#pragma mark - Methods

//- (Card *)drawCardAtIndex:(NSUInteger)index {
//    return (index < [self.cards count]) ? self.cards[index] : nil;
//}

- (Card *)drawCard { //draws a card from self.cards.
    
    //if self.cards has a count.
    if ([self.cards count]) {
        //pull the card from index 0.
        Card *card = [self.cards objectAtIndex:0];
        //if card exists them remove it form self.cards.
        if (card) {
            [self.cards removeObject:card];
        }
        //return card.
        return card;
    } else {
        //else let us know that there are no more cards and return nil.
        NSLog(@"No More Cards");
        return nil;
    }
}

@end

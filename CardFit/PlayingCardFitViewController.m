//
//  PlayingCardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardFitViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@implementation PlayingCardFitViewController

//When view disappears it sets the shared playing card object back to save so that values are stored in NSUserDefaults
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Abstract Methods

- (Deck *)createDeck { //Creates deck for game play
    return [[PlayingCardDeck alloc] initWithNumberOfCards:self.dataSource.numberOfCards];
}

- (UIView *)createCardViewWithCard:(Card *)card { //Creates card view for card object
    PlayingCardView *playingCardView = [[PlayingCardView alloc] init];
    [self updateCardView:playingCardView withCard:card];
    return playingCardView;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card { //Updates Card view for card object
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.selected;
        } else if (!card) {
            playingCardView.rank = 0;
        }
    }
}

@end

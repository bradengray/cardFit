//
//  PlayingCardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardFitViewController.h"
#import "CardFitPlayingCardDeck.h"
#import "CardFitPlayingCard.h"
#import "PlayingCardView.h"
#import "PlayingCardSettings.h"

@interface PlayingCardFitViewController ()

@property (nonatomic, strong) PlayingCardSettings *settings;

@end

@implementation PlayingCardFitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardAspectRatio = 0.620;
    self.maxCardWidth = 414;
    self.maxCardHeight = 668;
    self.minCardWidth = 10;
    self.minCardHeight = 10;
}

- (PlayingCardSettings *)settings {
    return [PlayingCardSettings sharedPlayingCardSettings];
}

#pragma mark - properties

- (Deck *)createDeck {
    return [[CardFitPlayingCardDeck alloc] initWithNumberOfDecks:[self numberOfDecks] withJokers:self.settings.jokers];
}

- (NSUInteger)numberOfDecks {
    if (self.numberOfCards >= [self numberOfCardsInDeck]) {
        return self.numberOfCards / [self numberOfCardsInDeck];
    } else {
        return 1;
    }
}

- (NSUInteger)numberOfCardsInDeck {
    if (self.settings.jokers) {
        return 54;
    } else {
        return 52;
    }
}

- (UIView *)createCardViewWithCard:(Card *)card {
    PlayingCardView *playingCardView = [[PlayingCardView alloc] init];
    [self updateCardView:playingCardView withCard:card];
    return playingCardView;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card {
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
        if ([card isKindOfClass:[CardFitPlayingCard class]]) {
            CardFitPlayingCard *playingCard = (CardFitPlayingCard *)card;
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.selected;
        }
    }
}

@end

//
//  MultiPCFViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MultiPCFViewController.h"
#import "CardFitPlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCardSettings.h"

@interface MultiPCFViewController ()

@property (nonatomic, strong) PlayingCardSettings *playingCardSettings;

@end

@implementation MultiPCFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardAspectRatio = 0.620;
    self.maxCardWidth = 414;
    self.maxCardHeight = 668;
    self.minCardWidth = 10;
    self.minCardHeight = 10;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.playingCardSettings.save = YES;
}

- (PlayingCardSettings *) playingCardSettings {
    return [PlayingCardSettings sharedPlayingCardSettings];
}

#pragma mark - properties

- (Deck *)createDeck {
    return [[CardFitPlayingCardDeck alloc] initWithNumberOfDecks:[self numberOfDecks] withJokers:self.playingCardSettings.jokers];
}

//- (Settings *)createSettings {
//    return [PlayingCardSettings sharedPlayingCardSettings];
//}

- (id)settings {
    return self.playingCardSettings;
}

- (void)recievedSettings:(id)settings {
    if ([settings isKindOfClass:[PlayingCardSettings class]]) {
        self.playingCardSettings = (PlayingCardSettings *)settings;
    }
}

- (NSUInteger)numberOfDecks {
    if (self.numberOfCards >= [self numberOfCardsInDeck]) {
        return self.numberOfCards / [self numberOfCardsInDeck];
    } else {
        return 1;
    }
}

- (NSUInteger)numberOfCardsInDeck {
    if (self.playingCardSettings.jokers) {
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

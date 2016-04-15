//
//  PlayingCardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardFitViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "Settings.h"

@interface PlayingCardFitViewController ()

@property (nonatomic, strong) Settings *settings;

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

- (Settings *)settings {
    if (!_settings) {
        _settings = [[Settings alloc] init];
    }
    return _settings;
}

#pragma mark - properties

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (UIView *)createCardViewWithCard:(Card *)card {
    PlayingCardView *playingCardView = [[PlayingCardView alloc] init];
    [self updateCardView:playingCardView withCard:card];
    return playingCardView;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card {
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.selected;
        }
    }
}

- (NSString *)setTitleForCardView:(UIView *)cardView { //abstract
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        if (playingCardView.rank < 2) {
            return [NSString stringWithFormat:@"%lu %@", self.settings.acesReps, self.settings.acesExerciseString];
        } else if (playingCardView.rank > 13) {
            return [NSString stringWithFormat:@"%@", self.settings.jokersExerciseString];
        } else {
            NSString *exerciseString = [self getExerciseStringForSuit:playingCardView.suit];
            if (playingCardView.rank > 10) {
                NSUInteger reps = [self getRepsForRank:playingCardView.rank];
                return [NSString stringWithFormat:@"%lu %@", reps, exerciseString];
            } else {
                return [NSString stringWithFormat:@"%lu %@", playingCardView.rank, exerciseString];
            }
        }
    } else {
        return @"Error";
    }
}

- (NSString *)getExerciseStringForSuit:(NSUInteger)suit {
    if (suit == 0) {
        return self.settings.spadesExerciseString;
    } else if (suit == 1) {
        return self.settings.heartsExerciseString;
    } else if (suit == 2) {
        return self.settings.clubsExerciseString;
    } else if (suit == 3) {
        return self.settings.diamondsExerciseString;
    } else {
        return @"Error";
    }
}

- (NSUInteger)getRepsForRank:(NSUInteger)rank {
    if (rank == 11) {
        return self.settings.jacksReps;
    } else if (rank == 12) {
        return self.settings.queensReps;
    } else if (rank == 13) {
        return self.settings.kingsReps;
    } else {
        NSLog(@"Error in getRepsForRank:(NSUInteger)rank PlayingCardFitViewController");
        return 0;
    }
}

@end

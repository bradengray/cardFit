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
    if (!_settings) {
        _settings = [[PlayingCardSettings alloc] init];
    }
    return _settings;
}

#pragma mark - properties

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] initWithNumberOfDecks:[self numberOfDecks] withJokers:self.settings.jokers];
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
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.selected;
        }
    }
}

- (NSString *)setTitleForCardView:(Card *)card { //abstract
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        return [self.settings labelForPlayingCard:playingCard];
    } else {
        return @"Error";
    }
}

//- (NSString *)setTitleForCardView:(UIView *)cardView { //abstract
//    if ([cardView isKindOfClass:[PlayingCardView class]]) {
//        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
//        if (playingCardView.rank < 2) {
//            return [NSString stringWithFormat:@"%lu %@", (unsigned long)self.settings.acesReps, self.settings.acesExerciseString];
//        } else if (playingCardView.rank > 13) {
//            return [NSString stringWithFormat:@"%@", self.settings.jokersExerciseString];
//        } else {
//            NSString *exerciseString = [self getExerciseStringForSuit:playingCardView.suit];
//            if (playingCardView.rank > 10) {
//                NSUInteger reps = [self getRepsForRank:playingCardView.rank];
//                return [NSString stringWithFormat:@"%lu %@", (unsigned long)reps, exerciseString];
//            } else {
//                return [NSString stringWithFormat:@"%lu %@", (unsigned long)playingCardView.rank, exerciseString];
//            }
//        }
//    } else {
//        return @"Error";
//    }
//}

//- (NSNumber *)repsForCard:(Card *)card {
//    if ([card isKindOfClass:[PlayingCard class]]) {
//        PlayingCard *playingCard = (PlayingCard *)card;
//        if (playingCard.rank < 2 || playingCard.rank > 10) {
//            return [NSNumber numberWithInteger:[self getRepsForRank:playingCard.rank]];
//        } else {
//            return [NSNumber numberWithInteger:playingCard.rank];
//        }
//    } else {
//        return nil;
//    }
//}
//
//- (NSString *)getExerciseStringForSuit:(NSUInteger)suit {
//    if (suit == 0) {
//        return self.settings.spadesExerciseString;
//    } else if (suit == 1) {
//        return self.settings.heartsExerciseString;
//    } else if (suit == 2) {
//        return self.settings.clubsExerciseString;
//    } else if (suit == 3) {
//        return self.settings.diamondsExerciseString;
//    } else {
//        return @"Error";
//    }
//}
//
//- (NSUInteger)getRepsForRank:(NSUInteger)rank {
//    if (rank == 1) {
//        return self.settings.acesReps;
//    } else if(rank == 11) {
//        return self.settings.jacksReps;
//    } else if (rank == 12) {
//        return self.settings.queensReps;
//    } else if (rank == 13) {
//        return self.settings.kingsReps;
//    } else if (rank == 14) {
//        return 40;
//    } else {
//        NSLog(@"Error in getRepsForRank:(NSUInteger)rank PlayingCardFitViewController");
//        return 0;
//    }
//}

@end

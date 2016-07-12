//
//  PlayingCardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardFitViewController.h"
#import "CardFitPlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCardSettings.h"

@interface PlayingCardFitViewController ()

@property (nonatomic, strong) PlayingCardSettings *playingCardSettings; //Our Specific settings object

@end

@implementation PlayingCardFitViewController

- (void)viewDidLoad { //Set all required values for our layout view
    [super viewDidLoad];
    self.cardAspectRatio = 0.620;
    self.maxCardWidth = 414;
    self.maxCardHeight = 668;
    self.minCardWidth = 10;
    self.minCardHeight = 10;
}

//When view disappears it sets the shared playing card object back to save so that values are stored in NSUserDefaults
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.playingCardSettings.save = YES;
}

- (PlayingCardSettings *) playingCardSettings { //Creates shared setting value
    return [PlayingCardSettings sharedPlayingCardSettings];
}

#pragma mark - Abstract Methods

- (Deck *)createDeck { //Creates deck for game play
    return [[CardFitPlayingCardDeck alloc] initWithNumberOfCards:[self numberOfCards]];
}

- (id)settings { //Returns settings object
    return self.playingCardSettings;
}

- (void)recievedSettings:(id)settings { //Sets shared setting object to the new settings
    if ([settings isKindOfClass:[PlayingCardSettings class]]) {
        self.playingCardSettings = (PlayingCardSettings *)settings;
    }
}

- (UIView *)createCardViewWithCard:(Card *)card { //Creates card view for card object
    PlayingCardView *playingCardView = [[PlayingCardView alloc] init];
    [self updateCardView:playingCardView withCard:card];
    return playingCardView;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card { //Updates Card view for card object
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

- (NSUInteger)numberOfCards { //Returns number of cards based on selection
    NSString *numOfCardsKey;
    if (self.multiplayer) { //Checks to see if multiplayer game or not
        numOfCardsKey = self.playingCardSettings.multiplayerNumberOfCards;
    } else {
        numOfCardsKey = self.playingCardSettings.onePlayerNumberOfCards;
    }
    //Returns number of cards bases on if Jokers are wanted or not
    int numberOfCards = [[self.playingCardSettings.numberOfCardsOptionValues objectForKey:numOfCardsKey] intValue];
    if (self.playingCardSettings.jokers) {
        return numberOfCards;
    } else {
        return numberOfCards = numberOfCards - ((numberOfCards/54) * 2);
    }
}

@end

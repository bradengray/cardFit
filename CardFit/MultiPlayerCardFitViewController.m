//
//  MultiPlayerCardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MultiPlayerCardFitViewController.h"
#import "CardFitLayoutView.h"
#import "CardFitGame.h"
#import "Timer.h"

#define CARD_KEY @"Card Key"

@interface MultiPlayerCardFitViewController ()
@property (nonatomic, strong) CardFitGame *game;
@property (nonatomic, strong) CardFitLayoutView *cardFitLayoutView;

@property (nonatomic, strong) CardFitCard *currentCard;
@property (nonatomic, strong) UIView *cardView;

@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic) NSUInteger counter;
@property (nonatomic) BOOL rotated;
@property (nonatomic) BOOL started;
@property (nonatomic, strong) NSTimer *gameTimer;

@property (nonatomic) NSUInteger cardCounter;

@property (nonatomic) BOOL playerOne;
@property (nonatomic) BOOL gameOver;

@end

@implementation MultiPlayerCardFitViewController

- (BOOL)playerOne {
    if (!_playerOne) {
        _playerOne = NO;
    }
    return _playerOne;
}

- (BOOL)gameOver {
    if (!_gameOver) {
        _gameOver = NO;
    }
    return _gameOver;
}

- (NSUInteger)cardCounter {
    if (!_cardCounter) {
        _cardCounter = 0;
    }
    return _cardCounter;
}

#pragma mark - ViewController Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.countDownLabel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
//    self.settings = [self createSettings];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [self orientation];
         if (orientation == UIInterfaceOrientationLandscapeLeft || orientation ==UIInterfaceOrientationLandscapeRight) {
             self.cardFitLayoutView.rotated = YES;
         } else {
             self.cardFitLayoutView.rotated = NO;
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self updateUI];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (UIInterfaceOrientation)orientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

#pragma mark - Properties

- (CardFitGame *)game {
    if (!_game) {
        _game = [[CardFitGame alloc] initWithCardCount:self.numberOfCards withDeck:[self createDeck]];
    }
    return _game;
}

- (NSUInteger)numberOfCards {
    if (!_numberOfCards) {
        _numberOfCards = 20;
    }
    return _numberOfCards;
}

- (CardFitLayoutView *)cardFitLayoutView {
    if (!_cardFitLayoutView) {
        CGSize layoutViewSize;
        if (self.rotated) {
            layoutViewSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
        } else {
            layoutViewSize = self.view.frame.size;
        }
        _cardFitLayoutView = [[CardFitLayoutView alloc] init];
        _cardFitLayoutView.rotated = self.rotated;
        _cardFitLayoutView.size = layoutViewSize;
        _cardFitLayoutView.aspectRatio = self.cardAspectRatio;
        _cardFitLayoutView.maxSubViewWidth = self.maxCardWidth;
        _cardFitLayoutView.maxSubViewHeight = self.maxCardHeight;
        _cardFitLayoutView.minSubViewWidth = self.minCardWidth;
        _cardFitLayoutView.minSubViewHeight = self.minCardHeight;
    }
    return _cardFitLayoutView;
}

- (BOOL)rotated {
    if (!_rotated) {
        UIInterfaceOrientation orientation = [self orientation];
        if (orientation != UIInterfaceOrientationPortrait) {
            _rotated = YES;
        } else {
            _rotated = NO;
        }
    }
    return _rotated;
}

- (NSUInteger)counter {
    if (!_counter ) {
        _counter = 0;
    }
    return _counter;
}

- (UILabel *)taskLabel {
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] init];
    }
    return _taskLabel;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timerLabel;
}

#pragma mark - Countdown And Setup

#define COUNTDOWN_INTERVAL 1.0
#define GAME_TIMER_INTERVAL 0.1

- (void)activateGameTimer {
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:GAME_TIMER_INTERVAL target:self selector:@selector(updateGameTimeLabel) userInfo:nil repeats:YES];
}

- (void)deactivateGameTimer {
    [self.gameTimer invalidate];
}

- (void)setUpUIForGameStart {
    [self createButton];
    if (self.playerOne) {
        self.currentCard = [self drawRandomCard];
        [self updateUI];
        [self removeGesturesForView:self.cardView];
        NSRange range = NSMakeRange(0, 1);
        self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Player One" attributes:[self.taskLabel.attributedText attributesAtIndex:0 effectiveRange:&range]];
        self.countDownLabel.hidden = YES;
    } else {
        [self.networkingEngine drawCard];
    }
}

- (void)startCountDown {
    self.taskLabel.hidden = YES;
    self.countDownLabel.hidden = NO;
    [self.view bringSubviewToFront:self.countDownLabel];
    [self countDown];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:COUNTDOWN_INTERVAL target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    if (self.counter <= 3) {
        [self animateCountDownLabel];
    } else {
        self.countDownLabel.hidden = YES;
        [self setLabelTitleForCardView:self.cardView];
        self.pauseButton.enabled = YES;
        [self flipCard];
        [self deactivateGameTimer];
        [self activateGameTimer];
        [self.pauseButton setAttributedTitle:[self setButtonAttributedTitleForHeight:self.pauseButton.frame.size.height] forState:UIControlStateNormal];
    }
    self.counter++;
}

- (void)flipCard {
    [UIView transitionWithView:self.cardView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.currentCard.selected = !self.currentCard.selected;
                        [self updateCardView:self.cardView withCard:self.currentCard];
                    } completion:^(BOOL finished) {
                        if (self.currentCard.selected) {
                            self.taskLabel.hidden = NO;
                            self.cardView.alpha = 1.0;
                            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                            [self updateUI];
                        }
                    }];
}

- (void)updateGameTimeLabel {
    [self.timerLabel setText:self.game.gameTime];
    self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
}

- (void)animateCountDownLabel {
    self.countDownLabel.attributedText = [self countDownLabelAttributedText];
    self.countDownLabel.alpha = .15;
    [UIView animateWithDuration:0.8 animations:^{
        self.countDownLabel.font = [self.countDownLabel.font fontWithSize:130];
        self.countDownLabel.alpha = 1.0;
    }];
}

- (NSAttributedString *)countDownLabelAttributedText {
    return [[NSAttributedString alloc] initWithString:[self labelString] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2}];
}

- (NSString *)labelString {
    if (self.counter == 0) {
        return @"3";
    } else if (self.counter == 1) {
        return @"2";
    } else if (self.counter == 2) {
        return @"1";
    } else if (self.counter == 3) {
        return @"GO";
    } else {
        return @"Error";
    }
}

#pragma mark - UI and EndGame

- (void)updateUI {
    if (self.currentCard) {
        if (!self.cardView) {
            self.cardView = [self createCardViewWithCard:self.currentCard];
            self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            [self.view addSubview:self.cardView];
            [self setLabelTitleForCardView:self.cardView];
            self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
            [self.view addSubview:self.taskLabel];
            self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
            [self.view addSubview:self.timerLabel];
        } else {
            [UIView transitionWithView:self.cardView
                              duration:.001
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
                                self.pauseButton.frame = [self.cardFitLayoutView frameForStartButton:self.pauseButton];
                                self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
                                self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
                            } completion:nil];
        }
    } else {
        if (self.playerOne) {
            [self endGame];
        }
    }
}

- (CardFitCard *)drawRandomCard {
    CardFitCard *card = [self.game drawCard];
    self.cardCounter++;
    NSLog(@"%ld", self.cardCounter);
    if (!card) {
        NSLog(@"No more Cards");
    }
    return card;
}

- (void)removeGesturesForView:(UIView *)view {
    for (UIGestureRecognizer *gesture in self.cardView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [view removeGestureRecognizer:gesture];
        }
    }
}

- (void)endGame {
    NSRange range = NSMakeRange(0, 1);
    NSDictionary *attributes = [self.taskLabel.attributedText attributesAtIndex:0 effectiveRange:&range];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Points:%ld", self.game.totalPoints] attributes:attributes];
    self.taskLabel.attributedText = attributedString;
    [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
    self.pauseButton.enabled = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.game.paused = YES;
}

#pragma mark - PauseButton

- (void)createButton {
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.pauseButton.layer.cornerRadius = 10;
    
    self.pauseButton.frame = [self.cardFitLayoutView frameForStartButton:self.pauseButton];
    
    [self.pauseButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    
    [self.pauseButton setAttributedTitle:[self setButtonAttributedTitleForHeight:self.pauseButton.frame.size.height] forState:UIControlStateNormal];
    
    [self.pauseButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.pauseButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.pauseButton];
}

#define BUTTON_FONT_SCALE_FACTOR 25

- (NSAttributedString *)setButtonAttributedTitleForHeight:(CGFloat)height {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *buttonTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    buttonTitleFont = [buttonTitleFont fontWithSize:buttonTitleFont.pointSize * (height / BUTTON_FONT_SCALE_FACTOR)];
    
    NSAttributedString *buttonAttributedTitle = [[NSAttributedString alloc] initWithString:[self buttonString] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : buttonTitleFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-3}];
    
    return buttonAttributedTitle;
}

- (void)buttonTouchDown:(UIButton *)button {
    button.titleLabel.alpha = 0.35;
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.2 blue:.7 alpha:0.9]];
}

- (void)buttonTouchUpInside:(UIButton *)button {
    button.titleLabel.alpha = 1.0;
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    if (self.started) {
        self.game.paused = !self.game.paused;
        if (!self.game.paused) {
            [self activateGameTimer];
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.navigationBar.hidden = YES;
                self.cardView.alpha = 1.0;
                self.taskLabel.alpha = 1.0;
                [button setAttributedTitle:[self setButtonAttributedTitleForHeight:button.frame.size.height] forState:UIControlStateNormal];
                [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            }];
        } else {
            [button setAttributedTitle:[self setButtonAttributedTitleForHeight:button.frame.size.height] forState:UIControlStateNormal];
            self.navigationController.navigationBar.hidden = NO;
            self.cardView.alpha = 0.35;
            self.taskLabel.alpha = 0.35;
            [self deactivateGameTimer];
            [self removeGesturesForView:self.cardView];
        }
    } else {
        self.pauseButton.enabled = NO;
        [self startCountDown];
        self.started = YES;
        [self.networkingEngine startGame];
    }
}

- (NSString *)buttonString {
    if (self.started) {
        if (!self.game.paused) {
            return @"Pause";
        } else {
            return @"Resume";
        }
    } else {
        return @"Start";
    }
}

#pragma mark - Task Label

#define LABEL_FONT_SCALE_FACTOR 0.005

- (CGFloat)labelFontScaleFactor {
    CGFloat cardHeight;
    if (self.cardFitLayoutView.rotated) {
        cardHeight = self.view.bounds.size.width;
    } else {
        cardHeight = self.view.bounds.size.height;
    }
    return cardHeight * LABEL_FONT_SCALE_FACTOR;
}

- (void)setLabelTitleForCardView:(UIView *)cardView {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    labelFont = [labelFont fontWithSize:36];
    
    self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.currentCard.label] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}];
    
    self.taskLabel.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:0.50];
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.playerOne) {
        [self.cardView removeFromSuperview];
        self.cardView = nil;
        self.currentCard = [self drawRandomCard];
        self.game.totalPoints = self.currentCard.points; //[[self repsForCard:self.currentCard] integerValue];
        self.currentCard.selected = YES;
        [self updateUI];
    } else {
        if (!self.gameOver) {
            [self.networkingEngine drawCard];
        } else {
            [self endGame];
        }
    }
}

- (void)card:(CardFitCard *)card {
    self.currentCard = card;
    if (self.started) {
        [self.cardView removeFromSuperview];
        self.cardView = nil;
        self.game.totalPoints = self.currentCard.points; //[[self repsForCard:self.currentCard] intValue];
        self.currentCard.selected = YES;
        [self updateUI];
    } else {
        self.pauseButton.enabled = NO;
        self.countDownLabel.hidden = NO;
        self.currentCard.selected = NO;
        [self updateUI];
        [self removeGesturesForView:self.cardView];
        NSRange range = NSMakeRange(0, 1);
        self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Player Two" attributes:[self.taskLabel.attributedText attributesAtIndex:0 effectiveRange:&range]];
    }
}

#pragma mark - MultiplayerNetworkingProtocol

- (void)matchReady {
    NSLog(@"Ready");
    [self setUpUIForGameStart];
}

- (void)gameStarted {
    NSLog(@"We are playing the game");
    [self startCountDown];
    self.started = YES;
}

- (void)isPlayerOne {
    NSLog(@"I know now who I am");
    [self.networkingEngine sendGameInfo:[self settings]];
    self.playerOne = YES;
    [self setUpUIForGameStart];
}

- (void)drawCard {
    NSLog(@"Drawing Card");
    Card *card = [self drawRandomCard];
    if (card) {
        [self.networkingEngine sendGameInfo:card];
    } else {
        [self.networkingEngine gameEnded];
    }
}

- (void)gameInfo:(id)gameInfo {
    if ([gameInfo isKindOfClass:[CardFitCard class]]) {
        CardFitCard *card = (CardFitCard *)gameInfo;
        [self card:card];
    } else {
        [self settings:gameInfo];
    }
}

- (void)matchEnded {
    self.gameOver = YES;
    [self endGame];
}

#pragma mark - Abstract Methods

- (Deck *)createDeck { //abstract
    return nil;
}

- (id)settings { //abstract
    return nil;
}

- (void)settings:(id)settings { //abstract
    return;
}

- (UIView *)createCardViewWithCard:(Card *)card { // abstract
    return nil;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card { // abstract
    return;
}

@end

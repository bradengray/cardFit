//
//  CardFitViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitViewController.h"
#import "Orientation.h"
#import "CardFitGame.h"
#import "Timer.h"

#define CARD_KEY @"Card Key"

@interface CardFitViewController ()
@property (nonatomic, strong) CardFitGame *game; //Instance of game

@property (nonatomic, strong) Card *currentCard; //Keeps track of the current shown card
@property (nonatomic, strong) CardView *cardView; //Keeps track of the current shown card's view

@property (nonatomic, strong) UIBarButtonItem *pauseButton; //Button that pauses game
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress; //Progress view that shows the progress of the game
@property (nonatomic) BOOL started; //Tells if game has started or not
@property (nonatomic, strong) NSTimer *gameTimer; //Timer to determine when countDownLabel and timerLabel should update

@property (nonatomic) BOOL playerOne; //Bool to track whether or not we are playerOne
@property (nonatomic) BOOL gameOver; //Bool to track if game is over or not

@end

@implementation CardFitViewController

#pragma mark - ViewController Life Cycle


//Called when view will appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Hide progress bar
    self.progress.hidden = YES;
    //If not multiplayer game
    if (!self.multiplayer) {
        //Setup game for start
        [self setUpUIForGameStart];
    }
}

#pragma mark - Rotation

//Called when the view changes size or the device changes orientation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.cardView setNeedsUpdateConstraints];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //When done update the UI
         [self updateUI];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Properties

//Lazy instantiate game
- (CardFitGame *)game {
    if (!_game) {
        //Use designated initializer to create game
        _game = [[CardFitGame alloc] initWithCardCount:[self numberOfCards] withDeck:[self createDeck]];
    }
    //Return result
    return _game;
}

//Getter for playerOne
- (BOOL)playerOne {
    //If not multiplayer
    if (!self.multiplayer) {
        //Then we are player one
        return YES;
    } else { //If multiplayer
        //Then return what was set by game
        return _playerOne;
    }
}

#pragma mark - Countdown And Setup

#define COUNTDOWN_INTERVAL 1.0 //NSTimer interval for how often to update count down label
#define GAME_TIMER_INTERVAL 0.1 //NSTimer interval for how often to update timer label

//Sets up the UI for the game to Start
- (void)setUpUIForGameStart {
    //Create Pause button
    [self createButton];
    //Show progress bar
    self.progress.hidden = NO;
    //Check to see if player One
    if (self.playerOne) {
        //Draw a card
        self.currentCard = [self drawRandomCard];
        //Setup Game
        [self setUp];
    } else { //If not player one
        //Draw a card from networking engine
        [self.networkingEngine drawCard];
    }
}

//Called for setUP
- (void)setUp {
    //Update UI
    [self updateUI];
    //Create a range for getting attributes from task label text
    NSRange range = NSMakeRange(0, 1);
    //Declare textString
    NSString *textString;
    //If multiplayer
    if (self.multiplayer) {
        if (self.playerOne) {
            //Set textString to Player One
            textString = @"Player One";
        } else {
            //Set textString to Player Two
            textString = @"Player Two";
            self.pauseButton.enabled = NO;
        }
    } else { //if single player
        //Set textString to CardFit
        textString = @"TAP TO START";
    }
    //Set task label text with attributes
    self.cardView.centerLabel.attributedText = [[NSAttributedString alloc] initWithString:textString attributes:[self.cardView.centerLabel.attributedText attributesAtIndex:0 effectiveRange:&range]];
}

//Activate NSTimer to the GAME_TIMER_INTERVAL
- (void)activateGameTimer {
    //Set NSTimer to call updateGameTimeLabel for GAME_TIMER_INTERVAL
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:GAME_TIMER_INTERVAL target:self selector:@selector(updateGameTimeLabel) userInfo:nil repeats:YES];
}

//Deactivate the NSTimer
- (void)deactivateGameTimer {
    [self.gameTimer invalidate];
}

//Called when Count Down to game start is needed
- (void)startCountDown {
    //Set CountDownLabels Background to clear
    self.cardView.centerLabel.backgroundColor = [UIColor clearColor];
    //Set cound down label tag equal 3 to start count down
    self.cardView.centerLabel.tag = 3;
    //Count down
    [self countDown];
    //Start NStimer to call count down for COUNTDOWN_INTERVAL
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:COUNTDOWN_INTERVAL target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

//Make count down label count down 3, 2, 1, Go....
- (void)countDown {
    //Set local variable couner
    int counter = (int)self.cardView.centerLabel.tag;
    //If counter is between 0 and 4 then count down is active
    if (self.cardView.centerLabel.tag <= 3 && self.cardView.centerLabel.tag > 0) {
        // animate countdown label
        [self animateCountDownLabel];
    } else { //Count down finished
        //Set task label for card view
        [self setTaskLabelTitleForCardView:self.cardView];
        //If not player one
        if (!self.pauseButton.enabled) {
            //Enable pause button
            self.pauseButton.enabled = YES;
        }
        //Flip the card view
        [self flipCard];
        //Deactivate NSTimer
        [self deactivateGameTimer];
        //Activate NSTimer for game timer label
        [self activateGameTimer];
    }
    //increase counter
    counter--;
    self.cardView.centerLabel.tag = counter;
}

//Animate count down label to change alpha from light do dark over time
- (void)animateCountDownLabel {
    //Set count down label text
    self.cardView.centerLabel.attributedText = [self countDownLabelAttributedText];
    //Make count down label transparent
    self.cardView.centerLabel.alpha = .15;
    //Animate over time
    [UIView animateWithDuration:0.8 animations:^{
        //Set count down label to opaque
        self.cardView.centerLabel.alpha = 1.0;
    }];
}

//Set count down label text
- (NSAttributedString *)countDownLabelAttributedText {
    //returns NSAttributed text from labelString
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *countDownLabelFont = [[UIFont alloc] init];
    countDownLabelFont = [UIFont fontWithName:@"Helvetica-Bold" size:130];
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.cardView.centerLabel.tag] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : countDownLabelFont, NSParagraphStyleAttributeName : paragraphStyle}];
}

//Animate card view changing from face down to face up
- (void)flipCard {
    //Animate over time flipping from left
    [UIView transitionWithView:self.cardView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        //Set current card BOOL selected
                        self.currentCard.selected = !self.currentCard.selected;
                        //Update card view
                        [self updateCardView:self.cardView withCard:self.currentCard];
                    } completion:^(BOOL finished) {
                        //If card is selected
                        if (self.currentCard.selected) {
                            //Add tap gesture so player can choose cards
                            [self addTapGestureToView:self.cardView];
                            //Update UI
                            [self updateUI];
                        }
                    }];
}

//Update label for game timer
- (void)updateGameTimeLabel {
    //Set text string for game timer
    [self.timerLabel setText:self.game.gameTime];
}

#pragma mark - UI and EndGame

//Update UI
- (void)updateUI {
    //If there is a current card
    if (self.currentCard) {
        //but there isn't a card view
        if (!self.cardView) {
            //Create card view for current card
            self.cardView = [self createCardViewWithCard:self.currentCard];
            //Add tap gesture so player can choose card
            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            //Add the cardview to our view
            [self.view addSubview:self.cardView];
            //Send CardView to Bottom of subviews
            [self.view sendSubviewToBack:self.cardView];
            //Set text string for task label for card view
            [self setTaskLabelTitleForCardView:self.cardView];
            //Set game points based on current card
            self.game.totalPoints = [self pointsForCard:self.currentCard];
        } else { //Device may have been rotated
            [self updateCardView:self.cardView withCard:self.currentCard];
            if (self.started) {
                [self setTaskLabelTitleForCardView:self.cardView];
            }
        }
    } else { //If there is no card
        //If you are player one
        if (self.playerOne) {
            //End game
            [self endGame];
        }
    }
}

//Draw card from game
- (Card *)drawRandomCard {
    //Set progress for player one
    [self.progress setProgress:self.game.progress];
    //Set progress for all other players
    [self.networkingEngine sendProgress:self.game.progress];
    //Draw a card from game
    Card *card = [self.game drawCard];
    //Return Card
    return card;
}

//Add tap gesture to view
- (void)addTapGestureToView:(UIView *)view {
    //Add tap gesture to given view
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

//Remove tap gestures from view
- (void)removeGesturesForView:(UIView *)view {
    //Iterate through gestures on view
    for (UIGestureRecognizer *gesture in self.cardView.gestureRecognizers) {
        //If view is a tap gesture
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            //remove it
            [view removeGestureRecognizer:gesture];
        }
    }
}

//Called when game is ended
- (void)endGame {
    //Set progress
    [self.progress setProgress:self.game.progress];
    //Get range for task label attributed text
    NSRange range = NSMakeRange(0, 1);
    //Get dictionary of attributes for that range
    NSDictionary *attributes = [self.cardView.centerLabel.attributedText attributesAtIndex:0 effectiveRange:&range];
    //Set an attributed string for task label to reflect score
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Score:%ld\n\nPoints:%ld", self.game.score ,self.game.totalPoints] attributes:attributes];
    //Set task label attributed text to that string
    self.cardView.centerLabel.attributedText = attributedString;;
    //Disable pause button
    self.pauseButton.enabled = NO;
    //Show navigation bar to exit
    self.navigationController.navigationBar.hidden = NO;
    //set game paused
    self.game.paused = YES;
    self.cardView.centerLabel.backgroundColor = [UIColor clearColor];
    [self updateCardView:self.cardView withCard:nil];
//    self.cardView.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.cardView startEmittingFireworks:YES];
    [self changeLeftBarButton];
}

#pragma mark - PauseButton

//Called to create pause button
- (void)createButton {
    self.pauseButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pause"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTouchUpInside)];
    self.navigationItem.rightBarButtonItem = self.pauseButton;
}

#define BUTTON_FONT_SCALE_FACTOR 25 //Scale font based on button height

//Called when user releases touch inside button
- (void)buttonTouchUpInside {
    //Change BOOL paused
    self.game.paused = !self.game.paused;
    //If game is not paused
    if (!self.game.paused) {
        //Activate NStimer for timer label
        [self activateGameTimer];
        //animate over time
        [UIView animateWithDuration:0.3 animations:^{
            //Set cardView to opaque
            self.cardView.alpha = 1.0;
            //Set task label to opaque
            self.cardView.centerLabel.alpha = 1.0;
            //Add tap gesture so player can select card
            [self addTapGestureToView:self.cardView];
        }];
    } else { //If game is paused
        //Make cardview transparent
        self.cardView.alpha = 0.10;
        //Make task label transparent
        self.cardView.centerLabel.alpha = 0.35;
        //Deactivate NSTimer for timer label
        [self deactivateGameTimer];
        //Remove tap gesture from card so player cannot select card
        [self removeGesturesForView:self.cardView];
    }
    [self changeLeftBarButton];
}

- (void)changeLeftBarButton { //Hide and show back button
    if (self.game.paused) {
        [self.navigationItem setHidesBackButton:NO animated:YES];
    } else {
        [self.navigationItem setHidesBackButton:YES animated:YES];
    }
}

#pragma mark - Task Label

#define LABEL_FONT_SCALE_FACTOR 0.005 //Scale font based on label height

//Called to determine font scale factor
- (CGFloat)labelFontScaleFactor {
    CGFloat cardHeight;
    //If device is landscape
    if ([Orientation landscapeOrientation]) {
        //set card height to view width
        cardHeight = self.view.bounds.size.width;
    } else { //If device orientation is portrait
        //Set cardHeight to view height
        cardHeight = self.view.bounds.size.height;
    }
    //Return cardHeight time scale factor
    return cardHeight * LABEL_FONT_SCALE_FACTOR;
}

//Called to set title for task label
- (void)setTaskLabelTitleForCardView:(UIView *)cardView {
    //Intialize paragraph style object
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //Set text alignment center
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //Initialize font with style
    UIFont *labelFont = [[UIFont alloc] init];
    labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:36];
    //Set task label attributed text with attributes
    self.cardView.centerLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [self labelForCard:self.currentCard]] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}];
    //Set task label background color to light gray
    self.cardView.centerLabel.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:0.60];
}

#pragma mark - Tap Gesture

//Called when user initialized tap gesture
- (void)tap:(UITapGestureRecognizer *)gesture {
    if (!self.started) {
        //Disable pause button
        self.pauseButton.enabled = NO;
        //Start count down
        [self startCountDown];
        //Set BOOL started equal YES
        self.started = YES;
        //Start game for all players
        [self.networkingEngine startGame];
        [self changeLeftBarButton];
    } else {
        //If player one
        if (self.playerOne) {
            //Draw a new card
            self.currentCard = [self drawRandomCard];
            self.currentCard.selected = YES;
            //Remove old card view and update UI
            [self updateUI];
        } else { //If not player one
            //If game is not over
            if (!self.gameOver) {
                //Draw a card from player one
                [self.networkingEngine drawCard];
            } else { //If game is over
                //End game
                [self endGame];
            }
        }
    }
}

#pragma mark - MultiPlayerHelperMethod

//Called when a card is recieved from player one
- (void)recievedCard:(Card *)card {
    //Set current card equal to new card
    self.currentCard = card;
    //If game has started
    if (self.started) {
        //remove old card view and update UI
        self.currentCard.selected = YES;
        [self updateUI];
    } else { //If game has not started
        //Set card as not selected
        self.currentCard.selected = NO;
        //SetUp Game
        [self setUp];
    }
}

#pragma mark - MultiplayerNetworkingProtocol

//Called when match is ready
- (void)matchReady {
    //Set up game for start
    [self setUpUIForGameStart];
}

//Called when game has started
- (void)gameStarted {
    //Start count down
    [self startCountDown];
    //Set BOOL started equal YES
    self.started = YES;
}

//Called if player is player one
- (void)isPlayerOne {
    //Send your settings to all other players
    [self.networkingEngine sendGameInfo:[self settings]];
    //Set BOOL playerOne equal YES
    self.playerOne = YES;
    //Set up game for start
    [self setUpUIForGameStart];
}

//Called when player asks for card from player one
- (void)drawCard {
    //Draw card
    Card *card = [self drawRandomCard];
    //If card
    if (card) {
#warning needs to be specific to player
        //Send the player a card
        [self.networkingEngine sendGameInfo:card];
    } else { //If no card
        //End game for other player
        [self.networkingEngine gameEnded];
    }
}

//Called when game progress has changed
- (void)progress:(float)currentProgress {
    //Set progress bar to currentProgress
    [self.progress setProgress:currentProgress];
}

//Called when game info is recieved
- (void)gameInfo:(id)gameInfo {
    //Use introspection to see if info is a card
    if ([gameInfo isKindOfClass:[Card class]]) { // If card
        //Set card
        Card *card = (Card *)gameInfo;
        //call recievedCard
        [self recievedCard:card];
    } else { //If not card them must be settings
        //call recieved Settings
        [self recievedSettings:gameInfo];
    }
}

//Called when match has eneded
- (void)matchEnded {
    //Set BOOL gameOver equal YES
    self.gameOver = YES;
    //End Game
    [self endGame];
}

//Called when match making is canceled
- (void)matchCanceled {
    //Pop view controller
    [self.navigationController popViewControllerAnimated:YES];
    //Show navigation bar
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Abstract Methods

- (Deck *)createDeck { //abstract
    return nil;
}

- (id)settings { //abstract
    return nil;
}

- (void)recievedSettings:(id)settings { //abstract
    return;
}

- (CardView *)createCardViewWithCard:(Card *)card { // abstract
    return nil;
}

- (void)updateCardView:(CardView *)cardView withCard:(Card *)card { // abstract
    return;
}

- (NSUInteger)numberOfCards { //abstract
    return 0;
}

- (NSUInteger)pointsForCard:(Card *)card { //abstract
    return 0;
}

- (NSString *)labelForCard:(Card *)card { //abstract
    return nil;
}

@end

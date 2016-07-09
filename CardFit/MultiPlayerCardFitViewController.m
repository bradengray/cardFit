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
@property (nonatomic, strong) CardFitGame *game; //Instance of game
@property (nonatomic, strong) CardFitLayoutView *cardFitLayoutView; //Instance of LayoutView

@property (nonatomic, strong) CardFitCard *currentCard; //Keeps track of the current shown card
@property (nonatomic, strong) UIView *cardView; //Keeps track of the current shown card's view

@property (nonatomic, strong) UIButton *pauseButton; //Button that pauses game
@property (nonatomic, strong) UILabel *taskLabel; //Label that displays the exercise
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel; //Label that displays countdown
@property (nonatomic, strong) UILabel *timerLabel; //Label that displays the current game time
@property (weak, nonatomic) IBOutlet UIProgressView *progress; //Progress view that shows the progress of the game

@property (nonatomic) BOOL rotated; //Tells if device orientiation is landscape or not
@property (nonatomic) BOOL started; //Tells if game has started or not
@property (nonatomic, strong) NSTimer *gameTimer; //Timer to determine when countDownLabel and timerLabel should update

@property (nonatomic) BOOL playerOne; //Bool to track whether or not we are playerOne
@property (nonatomic) BOOL gameOver; //Bool to track if game is over or not

@end

@implementation MultiPlayerCardFitViewController

#pragma mark - ViewController Life Cycle

//Called when view will appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Hide the Navigation Bar
    self.navigationController.navigationBar.hidden = YES;
    //Hide the Count Down Label
    self.countDownLabel.hidden = YES;
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
         //Checks the devices orientation
         UIInterfaceOrientation orientation = [self orientation];
         //If the orientation is landscape
         if (orientation == UIInterfaceOrientationLandscapeLeft || orientation ==UIInterfaceOrientationLandscapeRight) {
             //Set BOOL rotated equal YES
             self.cardFitLayoutView.rotated = YES;
         } else { //If orientation is portrait
             //Set BOOL rotated equal NO
             self.cardFitLayoutView.rotated = NO;
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //When done update the UI
         [self updateUI];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (UIInterfaceOrientation)orientation {
    //Get device orientation based on orientation of the status bar
    return [[UIApplication sharedApplication] statusBarOrientation];
}

#pragma mark - Properties

//Lazy instantiate game
- (CardFitGame *)game {
    if (!_game) {
        //Use designated initializer to create game
        _game = [[CardFitGame alloc] initWithCardCount:self.numberOfCards withDeck:[self createDeck]];
    }
    return _game;
}

//Lazy Instatiate numberOfCards
-(NSUInteger)numberOfCards {
    if (!_numberOfCards) {
        //Set default to 20 cards
        _numberOfCards = 20;
    }
    return _numberOfCards;
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

//Lazy instantiate the card Fit Layout View
- (CardFitLayoutView *)cardFitLayoutView {
    if (!_cardFitLayoutView) {
        //Determine layout size based on orientation
        CGSize layoutViewSize;
        if (self.rotated) {
            //If landscape swap the heights and width
            layoutViewSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
        } else { //If portrait
            //Set layOutViewSize equal to views frame size
            layoutViewSize = self.view.frame.size;
        }
        _cardFitLayoutView = [[CardFitLayoutView alloc] init]; //initialize
        _cardFitLayoutView.rotated = self.rotated; //Tell if rotated
        _cardFitLayoutView.size = layoutViewSize; //Set size
        _cardFitLayoutView.aspectRatio = self.cardAspectRatio; //Set aspect ratio of view
        _cardFitLayoutView.maxSubViewWidth = self.maxCardWidth; //Set max width of view
        _cardFitLayoutView.maxSubViewHeight = self.maxCardHeight; //Set max height of view
        _cardFitLayoutView.minSubViewWidth = self.minCardWidth; //Set min width of view
        _cardFitLayoutView.minSubViewHeight = self.minCardHeight; //Set min height of view
    }
    return _cardFitLayoutView;
}

//Lazy Instantiate BOOL rotated
- (BOOL)rotated {
    //Check the orientation of the device
    UIInterfaceOrientation orientation = [self orientation];
    if (orientation != UIInterfaceOrientationPortrait) {
        //If landscape roated equals YES
        _rotated = YES;
    } else {
        //If portrait landscape equals NO
        _rotated = NO;
    }
    return _rotated;
}

//Lazy Instantiate task label
- (UILabel *)taskLabel {
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] init];
    }
    return _taskLabel;
}

//Lazy instanstiate timer label
- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        //Center timer label text
        _timerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timerLabel;
}

#pragma mark - Countdown And Setup

#define COUNTDOWN_INTERVAL 1.0 //NSTimer interval for how often to update count down label
#define GAME_TIMER_INTERVAL 0.1 //NSTimer interval for how often to update timer label

//Sets up the UI for the game to Start
- (void)setUpUIForGameStart {
    //Create Pause button
    [self createButton];
    //Check to see if player One
    if (self.playerOne) {
        //Draw a card
        self.currentCard = [self drawRandomCard];
        //Update UI
        [self updateUI];
        //Remove gestures from current cardview so that the player cannot draw cards
        [self removeGesturesForView:self.cardView];
        //Create a range for getting attributes from task label text
        NSRange range = NSMakeRange(0, 1);
        //Declare textString
        NSString *textString;
        //If multiplayer
        if (self.multiplayer) {
            //Set textString to PlayerOne
            textString = @"Player One";
        } else { //if single player
            //Set textString to CardFit
            textString = @"CardFit";
        }
        self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:textString attributes:[self.taskLabel.attributedText attributesAtIndex:0 effectiveRange:&range]];
    } else { //If not player one
        //Draw a card from networking engine
        [self.networkingEngine drawCard];
    }
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
    //Hide task label
    self.taskLabel.hidden = YES;
    //Set cound down label tag equal 3 to start count down
    self.countDownLabel.tag = 3;
    //Show count down label
    self.countDownLabel.hidden = NO;
    //Bring count down label to the top layer of the view
    [self.view bringSubviewToFront:self.countDownLabel];
    //Count down
    [self countDown];
    //Start NStimer to call count down for COUNTDOWN_INTERVAL
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:COUNTDOWN_INTERVAL target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

//Make count down label count down 3, 2, 1, Go....
- (void)countDown {
    //Set local variable couner
    int counter = (int)self.countDownLabel.tag;
    //If counter is between 0 and 4 then count down is active
    if (self.countDownLabel.tag <= 3 && self.countDownLabel.tag > 0) {
        // animate countdown label
        [self animateCountDownLabel];
    } else { //Count down finished
        //Hide count down lable
        self.countDownLabel.hidden = YES;
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
        //Set pause button title
#warning possible to move
        [self.pauseButton setAttributedTitle:[self setButtonAttributedTitleForHeight:self.pauseButton.frame.size.height] forState:UIControlStateNormal];
    }
    //increase counter
    counter--;
    self.countDownLabel.tag = counter;
}

//Animate count down label to change alpha from light do dark over time
- (void)animateCountDownLabel {
    //Set count down label text
    self.countDownLabel.attributedText = [self countDownLabelAttributedText];
    //Make count down label transparent
    self.countDownLabel.alpha = .15;
    //Animate over time
    [UIView animateWithDuration:0.8 animations:^{
        //Set font size
        self.countDownLabel.font = [self.countDownLabel.font fontWithSize:130];
        //Set count down label to opaque
        self.countDownLabel.alpha = 1.0;
    }];
}

//Set count down label text
- (NSAttributedString *)countDownLabelAttributedText {
    //returns NSAttributed text from labelString
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.countDownLabel.tag] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2}];
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
                            //Show task label
                            self.taskLabel.hidden = NO;
//                            self.cardView.alpha = 1.0;
                            //Add tap gesture so player can choose cards
#warning should be moved
                            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                            //Update UI
                            [self updateUI];
                        }
                    }];
}

//Update label for game timer
- (void)updateGameTimeLabel {
    //Set text string for game timer
    [self.timerLabel setText:self.game.gameTime];
    //Set frame for Game timer
    self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
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
            //Set card view frame
            self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
            //Add tap gesture so player can choose card
            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            //Add the cardview to our view
            [self.view addSubview:self.cardView];
            //Set text string for task label for card view
            [self setTaskLabelTitleForCardView:self.cardView];
            //Set task label frame
            self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
            //Add task label to subview
            [self.view addSubview:self.taskLabel];
            //Set frame for timer label
            self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
            //Add timer label to view
            [self.view addSubview:self.timerLabel];
            //Set game points based on current card
            self.game.totalPoints = self.currentCard.points;
        } else { //Device may have been rotated
            //Reset frames with animation over time
            [UIView transitionWithView:self.cardView
                              duration:.001
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                //Set card view frame
                                self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
                                //Set pause button frame
                                self.pauseButton.frame = [self.cardFitLayoutView frameForStartButton:self.pauseButton];
                                //Set task label frame
                                self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
                                //Set timer label frame
                                self.timerLabel.frame = [self.cardFitLayoutView frameForTimerLabel:self.timerLabel];
                            } completion:nil];
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
- (CardFitCard *)drawRandomCard {
    //Draw a card from game
    CardFitCard *card = [self.game drawCard];
    //Set progress for player one
    [self.progress setProgress:self.game.progress];
    //Set progress for all other players
    [self.networkingEngine sendProgress:self.game.progress];
//    self.cardCounter++;
//    NSLog(@"%ld", self.cardCounter);
//    if (!card) {
//        NSLog(@"No more Cards");
//    }
    return card;
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
    [self.progress setProgress:1.0];
    //Get range for task label attributed text
    NSRange range = NSMakeRange(0, 1);
    //Get dictionary of attributes for that range
    NSDictionary *attributes = [self.taskLabel.attributedText attributesAtIndex:0 effectiveRange:&range];
    //Set an attributed string for task label to reflect score
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Points:%ld", self.game.totalPoints] attributes:attributes];
    //Set task label attributed text to that string
    self.taskLabel.attributedText = attributedString;
    //Set frame for task label
    [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
    //Disable pause button
    self.pauseButton.enabled = NO;
    //Show navigation bar to exit
    self.navigationController.navigationBar.hidden = NO;
    //set game paused
    self.game.paused = YES;
}

#pragma mark - PauseButton

//Called to create pause button
- (void)createButton {
    //Create custom button
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //Set corner radius so the corners are curved
    self.pauseButton.layer.cornerRadius = 10;
    //Set pause button frame
    self.pauseButton.frame = [self.cardFitLayoutView frameForStartButton:self.pauseButton];
    //Set pause button background color
    [self.pauseButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    //Set attributed title for pause button based on whther game has started and whether game is paused or not
    [self.pauseButton setAttributedTitle:[self setButtonAttributedTitleForHeight:self.pauseButton.frame.size.height] forState:UIControlStateNormal];
    //Call buttonTouchDown if button touched
    [self.pauseButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    //Call buttonTouchUpInside if player release touch inside button
    [self.pauseButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    //Add button to view
    [self.view addSubview:self.pauseButton];
}

#define BUTTON_FONT_SCALE_FACTOR 25 //Scale font based on button height

//Called when setting attributed title for button
- (NSAttributedString *)setButtonAttributedTitleForHeight:(CGFloat)height {
    //Initialize paragraphStyle object
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //Set alignment to center
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //Initialize font object with style
    UIFont *buttonTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    //Set font size based on height
    buttonTitleFont = [buttonTitleFont fontWithSize:buttonTitleFont.pointSize * (height / BUTTON_FONT_SCALE_FACTOR)];
    //Initialize attribted string with attributes
    NSAttributedString *buttonAttributedTitle = [[NSAttributedString alloc] initWithString:[self buttonString] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : buttonTitleFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-3}];
    //return that string
    return buttonAttributedTitle;
}

//Called when button touched to animate button being touched
- (void)buttonTouchDown:(UIButton *)button {
    //Set text string alpha to transparent
    button.titleLabel.alpha = 0.35;
    //Change button background color
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.2 blue:.7 alpha:0.9]];
}

//Called when user releases touch inside button
- (void)buttonTouchUpInside:(UIButton *)button {
    //Set text string alpha to opaque
    button.titleLabel.alpha = 1.0;
    //Change background color
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    //If game has started
    if (self.started) {
        //Change BOOL paused
        self.game.paused = !self.game.paused;
        //If game is not paused
        if (!self.game.paused) {
            //Activate NStimer for timer label
            [self activateGameTimer];
            //animate over time
            [UIView animateWithDuration:0.3 animations:^{
                //Hide navigation bar
                self.navigationController.navigationBar.hidden = YES;
                //Set cardView to opaque
                self.cardView.alpha = 1.0;
                //Set task label to opaque
                self.taskLabel.alpha = 1.0;
                //Set button title to Pause
                [button setAttributedTitle:[self setButtonAttributedTitleForHeight:button.frame.size.height] forState:UIControlStateNormal];
#warning put add tap gesture in its own method
                //Add tap gesture so player can select card
                [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            }];
        } else { //If game is paused
            //Set button title to Resume
            [button setAttributedTitle:[self setButtonAttributedTitleForHeight:button.frame.size.height] forState:UIControlStateNormal];
            //Show navigation bar
            self.navigationController.navigationBar.hidden = NO;
            //Make cardview transparent
            self.cardView.alpha = 0.35;
            //Make task label transparent
            self.taskLabel.alpha = 0.35;
            //Deactivate NSTimer for timer label
            [self deactivateGameTimer];
            //Remove tap gesture from card so player cannot select card
            [self removeGesturesForView:self.cardView];
        }
    } else { //If game is not started
        //Disable pause button
        self.pauseButton.enabled = NO;
        //Start count down
        [self startCountDown];
        //Set BOOL started equal YES
        self.started = YES;
        //Start game for all players
        [self.networkingEngine startGame];
    }
}

//Call for butting title string based on whether game has started and is paused or not
- (NSString *)buttonString {
    //If game is started
    if (self.started) {
        //If game is not paused
        if (!self.game.paused) {
            //Return Pause
            return @"Pause";
        } else { //If game is paused
            //Return Resume
            return @"Resume";
        }
    } else { //If game is not started
        //Return Start
        return @"Start";
    }
}

#pragma mark - Task Label

#define LABEL_FONT_SCALE_FACTOR 0.005 //Scale font based on label height

//Called to determine font scale factor
- (CGFloat)labelFontScaleFactor {
    CGFloat cardHeight;
    //If device is landscape
    if (self.cardFitLayoutView.rotated) {
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
    UIFont *labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    //Set font size
    labelFont = [labelFont fontWithSize:36];
    //Set task label attributed text with attributes
    self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.currentCard.label] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}];
    //Set task label background color to light gray
    self.taskLabel.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:0.50];
}

//Called when user initialized tap gesture
- (void)tap:(UITapGestureRecognizer *)gesture {
    //If player one
    if (self.playerOne) {
        //Remove current cardview form view
        [self.cardView removeFromSuperview];
        //Set cardview equal to nil
        self.cardView = nil;
        //Draw a new card
        self.currentCard = [self drawRandomCard];
        //Set card as selected
        self.currentCard.selected = YES;
        //Update UI
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

//Called when a card is recieved from player one
- (void)recievedCard:(CardFitCard *)card {
    //Set current card equal to new card
    self.currentCard = card;
    //If game has started
    if (self.started) {
#warning redundant tap
        //Remove cardview from view
        [self.cardView removeFromSuperview];
        //Set card view to nil
        self.cardView = nil;
        //Set card to selected
        self.currentCard.selected = YES;
        //update UI
        [self updateUI];
    } else { //If game has not started
#warning redundant setup game
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

//Called when match is ready
- (void)matchReady {
#warning NSLOGS to check for redundancy or game start
    NSLog(@"Match is ready");
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
    NSLog(@"Player One");
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
    if ([gameInfo isKindOfClass:[CardFitCard class]]) { // If card
        //Set card
        CardFitCard *card = (CardFitCard *)gameInfo;
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

- (UIView *)createCardViewWithCard:(Card *)card { // abstract
    return nil;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card { // abstract
    return;
}

@end

//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "Settings.h"
#import "CardFitViewController.h"
#import "MultiplayerNetworking.h"

//Adheres to UIPickerViewDelegate and UIPickerViewDataSource Protocols
@interface MainPageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *multiPlayerButton; //Outlet for multiplayer button
@property (weak, nonatomic) IBOutlet UIButton *onePlayerButton; //Outlet for singleplayer button
@property (weak, nonatomic) IBOutlet UIButton *nextButton; //Outlet for nextbutton
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView; //Pickerview for selecting number of cards
@property (nonatomic, strong) Settings *settings; //Settings object
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //networking engine object
@property (nonatomic, strong) UIBarButtonItem *sidebarButton; //Navigationbar button for side menu
@property (nonatomic) BOOL selected; //Tracks whether game type was selected single player or multiplayer
@property (nonatomic) BOOL multiPlayer; //Tracks whether multiplayer option is selected or not
@property (nonatomic) BOOL multiplayerReady; //Tracks player authentication

@end

@implementation MainPageViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    //Set delegates and hide picker view nad next button
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    self.nextButton.hidden = YES;
    //Set up buttons
    [self setUpButton:self.multiPlayerButton withTitle:@"MultiPlayer"];
    [self setUpButton:self.onePlayerButton withTitle:@"Single Player"];
    [self setUpButton:self.nextButton withTitle:@"Next"];
    //Set up reveal view controller for side menu
    self.revealViewController.rightViewController = nil;
    [self setMenuBarButton];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated { //Called when view appears
    [super viewWillAppear:animated];
    //Add radio stations for player authentication and match maker view controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMatchMakerViewController) name:PresentGKMatchMakerViewController object:nil];
    //Check if player is authenticated to enable multiplayer selection
    if (!self.multiplayerReady) {
        self.multiPlayerButton.enabled = NO;
        self.multiPlayerButton.titleLabel.alpha = 0.15;
    }
}

#pragma mark - Radio Station Methods

- (void)playerAuthenticated {
    self.multiplayerReady = YES;
    self.multiPlayerButton.enabled = YES;
    self.multiPlayerButton.titleLabel.alpha = 1.0;
}

- (void)presentMatchMakerViewController {
    self.multiPlayer = YES;
    [self performSegueWithIdentifier:@"Play Game" sender:self.nextButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (BOOL)multiplayerReady { //Returns multiplayerReady and checks player authentication
    if (!_multiplayerReady) {
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    }
    return _multiplayerReady;
}

- (Settings *)settings { //Initializes Settings object
    if (!_settings) {
        _settings = [[Settings alloc] init];
    }
    return _settings;
}

#pragma mark - Buttons

- (void)setMenuBarButton { //Sets side bar menu button
    self.sidebarButton = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.sidebarButton = [[UIBarButtonItem alloc] init];
    self.sidebarButton.image = [UIImage imageNamed:@"list"];
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
}

- (void)setCancelBarButton { //Sets navigation bar cancel button
    self.sidebarButton = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.sidebarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonTouched)];
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
}

- (void)cancelBarButtonTouched { //Called when navigation bar cancel button is touched
    //Set game type to not selected
    self.selected = !self.selected;
    //Animate buttons
    [UIView animateWithDuration:0.15 animations:^{
        self.nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        //Hide pickerview and next button also setup navigation bar menu button
        [self setMenuBarButton];
        self.pickerView.hidden = YES;
        self.nextButton.hidden = YES;
        [self.onePlayerButton setAttributedTitle:[self buttonAttributedTitleWithString:@"One Player"] forState:UIControlStateNormal];
        self.multiPlayerButton.hidden = NO;
        self.onePlayerButton.hidden = NO;
        NSArray *objects = @[self.multiPlayerButton, self.onePlayerButton];
        [self animateObjects:objects];
    }];
}

- (void)setUpButton:(UIButton *)button withTitle:(NSString *)title { //Set up button with title
    [button setBackgroundColor:self.view.backgroundColor];
    [button setAttributedTitle:[self buttonAttributedTitleWithString:title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchDown:(UIButton *)button { //Animates button when touched
    button.titleLabel.alpha = 0.15;
}

- (void)buttonTouchUpInside:(UIButton *)button { //Button touch released inside button
    //Animate touch
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
    }];
    //If game type not selected
    if (!self.selected) {
        //Decide if multiplayer or not and set datasources for picker views
        if (button == self.multiPlayerButton) {
            self.multiPlayer = YES;
            self.pickerView.dataSource = nil;
            self.pickerView.dataSource = self;
            [self updatePickerView];
        } else if (button == self.onePlayerButton) {
            self.multiPlayer = NO;
            self.pickerView.dataSource = nil;
            self.pickerView.dataSource = self;
            [self updatePickerView];
        }
        //Animate buttons and picker views
        [UIView animateWithDuration:0.15 animations:^{
            self.multiPlayerButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.onePlayerButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self setCancelBarButton];
            self.multiPlayerButton.hidden = YES;
            self.onePlayerButton.hidden = YES;
            [self.onePlayerButton setAttributedTitle:[self buttonAttributedTitleWithString:@"Next"] forState:UIControlStateNormal];
            self.pickerView.hidden = NO;
            self.nextButton.hidden = NO;
            NSArray *objects = @[self.pickerView, self.nextButton];
            [self animateObjects:objects];
        }];
        //Set whether game type was chosen or not.
        self.selected = !self.selected;
    } else { //If game type selected the Next button must have been selected. Play game.
        [self performSegueWithIdentifier:@"Play Game" sender:button];
    }
}

#define BUTTON_FONT_SCALE_FACTOR .003

- (NSAttributedString *)buttonAttributedTitleWithString:(NSString *)string { //Returns attributed string for button titles
    
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    font = [font fontWithSize:font.pointSize * (self.view.bounds.size.height * BUTTON_FONT_SCALE_FACTOR)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:.3 blue:.8 alpha:1], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

#pragma mark - Animations

#define SPRING_DAMPING 0.70
#define SPRING_VELOCITY 0.10
#define ANIMATION_DURATION 0.50

- (void)animateObjects:(NSArray *)objects { //Animates the comings and goings of buttons and picker views
    CGFloat counter = 0;
    //Check to see if object is a button or a picker view then animate
    for (id object in objects) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)object;
            [UIView animateWithDuration:ANIMATION_DURATION delay:counter usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionTransitionNone animations:^{
                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        } else if ([object isKindOfClass:[UIPickerView class]]) {
            UIPickerView *picker = (UIPickerView *)object;
            [UIView animateWithDuration:ANIMATION_DURATION delay:counter usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionTransitionNone animations:^{
                picker.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }
    }
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { //Set number of components for picker view to 1 column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { //Set rows for pickerview
    //Check to see what gameType
    if (!self.multiPlayer) {
        return [self.settings.onePlayerNumberOfCardsOptionStrings count];
    } else {
        return [self.settings.multiplayerNumberOfCardsOptionStrings count];
    }
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { //Gets title for row
    //Check to see what gameType
    if (!self.multiPlayer) {
        return self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        return self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { //Called when row selected
    //Check to see what gameType
    if (!self.multiPlayer) {
        self.settings.onePlayerNumberOfCards = self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        self.settings.multiplayerNumberOfCards = self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

-(void)updatePickerView { //Updates pickerview to moste recently selected row
    NSInteger row;
    //Check to see what gameType
    if (!self.multiPlayer) {
        row = [self.settings.onePlayerNumberOfCardsOptionStrings indexOfObject:self.settings.onePlayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    } else {
        row = [self.settings.multiplayerNumberOfCardsOptionStrings indexOfObject:self.settings.multiplayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Performs segue
    if ([sender isKindOfClass:[UIButton class]]) { //Check sender class
        if ((UIButton *)sender == self.nextButton) { //Check sender
            if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) { //Check destination
                CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
                //Check to see what gameType
                if (self.multiPlayer) {
                    self.networkingEngine = [[MultiplayerNetworking alloc] init];
                    self.networkingEngine.delegate = cfvc;
                    cfvc.networkingEngine = self.networkingEngine;
                    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self.networkingEngine];
                }
                cfvc.title = @"CardFit Game";
                cfvc.multiplayer = self.multiPlayer;
            }
        }
    }
}

@end

//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "PlayingCardSettings.h"
#import "CardFitViewController.h"
#import "MultiPlayerCardFitViewController.h"
#import "GameKitHelper.h"
#import "MultiplayerNetworking.h"

@interface MainPageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *multiPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *onePlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) PlayingCardSettings *settings;
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;
@property (nonatomic, strong) UIBarButtonItem *sidebarButton;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL multiPlayer;
@property (nonatomic) BOOL multiplayerReady;

@end

@implementation MainPageViewController

#pragma mark - View Life Cycle

- (BOOL)multiplayerReady {
    if (!_multiplayerReady) {
        _multiplayerReady = NO;
    }
    return _multiplayerReady;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.multiPlayerButton.enabled = NO;
    self.multiPlayerButton.titleLabel.alpha = 0.15;
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    self.nextButton.hidden = YES;
    [self setUpButton:self.multiPlayerButton withTitle:@"MultiPlayer"];
    [self setUpButton:self.onePlayerButton withTitle:@"One Player"];
    [self setUpButton:self.nextButton withTitle:@"Next"];
    
    self.revealViewController.rightViewController = nil;
    [self setMenuBarButton];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMatchMakerViewController) name:PresentGKMatchMakerViewController object:nil];
}

#pragma mark - Properties

- (PlayingCardSettings *)settings {
    if (!_settings) {
        _settings = [[PlayingCardSettings alloc] init];
    }
    return _settings;
}

- (void)setMenuBarButton {
    self.sidebarButton = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.sidebarButton = [[UIBarButtonItem alloc] init];
    self.sidebarButton.image = [UIImage imageNamed:@"list"];
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
}

- (void)setCancelBarButton {
    self.sidebarButton = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.sidebarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonTouched)];
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
}

- (void)playerAuthenticated {
    self.multiplayerReady = YES;
    self.multiPlayerButton.enabled = YES;
    self.multiPlayerButton.titleLabel.alpha = 1.0;
}

- (void)presentMatchMakerViewController {
    [self performSegueWithIdentifier:@"Play Multiplayer" sender:self.nextButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button Setup

- (void)setUpButton:(UIButton *)button withTitle:(NSString *)title {
    [button setBackgroundColor:self.view.backgroundColor];
    [button setAttributedTitle:[self buttonAttributedTitleWithString:title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchDown:(UIButton *)button {
    button.titleLabel.alpha = 0.15;
}

- (void)buttonTouchUpInside:(UIButton *)button {
    
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
    }];
    
    if (!self.selected) {
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
        self.selected = !self.selected;
    } else {
//        if (self.onePlayer) {
//            [self performSegueWithIdentifier:@"Play Game" sender:button];
//        } else if (self.multiplayerReady) {
//            [self performSegueWithIdentifier:@"Play Multiplayer" sender:button];
//        }
        [self performSegueWithIdentifier:@"Play Multiplayer" sender:button];
    }
}

- (void)cancelBarButtonTouched {
    self.selected = !self.selected;
    [UIView animateWithDuration:0.15 animations:^{
        self.nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
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

#define BUTTON_FONT_SCALE_FACTOR .003

- (NSAttributedString *)buttonAttributedTitleWithString:(NSString *)string {
    
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

- (void)animateObjects:(NSArray *)objects {
    CGFloat counter = 0;
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!self.multiPlayer) {
        return [self.settings.onePlayerNumberOfCardsOptionStrings count];
    } else {
        return [self.settings.multiplayerNumberOfCardsOptionStrings count];
    }
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (!self.multiPlayer) {
        return self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        return self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!self.multiPlayer) {
        self.settings.onePlayerNumberOfCards = self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        self.settings.multiplayerNumberOfCards = self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

-(void)updatePickerView {
    NSInteger row;
    if (!self.multiPlayer) {
        row = [self.settings.onePlayerNumberOfCardsOptionStrings indexOfObject:self.settings.onePlayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    } else {
        row = [self.settings.multiplayerNumberOfCardsOptionStrings indexOfObject:self.settings.multiplayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }
}

#pragma mark - Segue

-(void)prepareCardFitViewController:(CardFitViewController *)cfvc toPlayWithNumOfCards:(NSUInteger)numOfCards {
    if (!self.settings.jokers) {
        numOfCards = numOfCards - ((numOfCards/54) * 2);
    }
    cfvc.numberOfCards = numOfCards;
    cfvc.title = @"CardFitGame";
}

-(void)prepareMultiPlayerCardFitViewController:(MultiPlayerCardFitViewController *)mpcfvc toPlayWithNumOfCards:(NSUInteger)numOfCards {
    if (!self.settings.jokers) {
        numOfCards = numOfCards - ((numOfCards/54) * 2);
    }
    mpcfvc.numberOfCards = numOfCards;
    mpcfvc.title = @"CardFitGame";
    mpcfvc.multiplayer = self.multiPlayer;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        if ((UIButton *)sender == self.nextButton) {
            if ([segue.identifier isEqualToString:@"Play Game"]) {
                if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) {
                    CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
                    [self prepareCardFitViewController:cfvc toPlayWithNumOfCards:[[self.settings.numberOfCardsOptionValues valueForKey:self.settings.onePlayerNumberOfCards] intValue]];
                }
            } else if ([segue.identifier isEqualToString:@"Play Multiplayer"]) {
                if ([segue.destinationViewController isKindOfClass:[MultiPlayerCardFitViewController class]]) {
                    MultiPlayerCardFitViewController *mpcfvc = (MultiPlayerCardFitViewController *)segue.destinationViewController;
                    if (self.multiPlayer) {
                        self.networkingEngine = [[MultiplayerNetworking alloc] init];
                        self.networkingEngine.delegate = mpcfvc;
                        mpcfvc.networkingEngine = self.networkingEngine;
                        [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self.networkingEngine];
                    }
                    [self prepareMultiPlayerCardFitViewController:mpcfvc toPlayWithNumOfCards:[[self.settings.numberOfCardsOptionValues valueForKey:self.settings.multiplayerNumberOfCards] intValue]];
                }
            }
        }
    }
}

@end

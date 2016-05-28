//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
//#import "OnePlayerViewController.h"
#import "PlayingCardSettings.h"
#import "CardFitViewController.h"
//#import "GameSettingsTVC.h"

@interface MainPageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *multiPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *onePlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) PlayingCardSettings *settings;
@property (nonatomic, strong) UIBarButtonItem *sidebarButton;
@property (nonatomic) BOOL selected;

@end

@implementation MainPageViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
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
    [self updatePickerView];
//    self.multiPlayerButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    self.onePlayerButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    NSArray *buttons = @[self.multiPlayerButton, self.onePlayerButton];
//    [self animateButtons:buttons];
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
    if (self.selected) {
        [self performSegueWithIdentifier:@"Play Game" sender:button];
        self.selected = !self.selected;
    } else {
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
    }
    self.selected = !self.selected;
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
//        counter += .2;
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate Methods

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.settings.onePlayerNumberOfCardsOptionStrings count];
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.settings.onePlayerNumberOfCardsOptionStrings[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.settings.onePlayerNumberOfCards = self.settings.onePlayerNumberOfCardsOptionStrings[row];
}

-(void)updatePickerView {
    NSInteger row = [self.settings.onePlayerNumberOfCardsOptionStrings indexOfObject:self.settings.onePlayerNumberOfCards];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}

-(void)prepareCardFitViewController:(CardFitViewController *)cfvc toPlayWithNumOfCards:(NSUInteger)numOfCards {
    if (!self.settings.jokers) {
        numOfCards = numOfCards - ((numOfCards/54) * 2);
    }
    cfvc.numberOfCards = numOfCards;
    cfvc.title = @"CardFitGame";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //sender is button use that
    if ([segue.identifier isEqualToString:@"Play Game"]) {
        if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) {
            CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
            [self prepareCardFitViewController:cfvc toPlayWithNumOfCards:[[self.settings.numberOfCardsOptionValues valueForKey:self.settings.onePlayerNumberOfCards] intValue]];
        }
    }
}

@end

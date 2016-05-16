//
//  OnePlayerViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "OnePlayerViewController.h"
#import "NumOfCardsPopoverContentTVC.h"
#import "CardFitViewController.h"
#import "PlayingCardSettings.h"

@interface OnePlayerViewController () <UITextFieldDelegate, NumberOfCardsDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textFieldLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberOfCardsTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *jokerSwitch;
@property (nonatomic, strong) PlayingCardSettings *settings;

@end

@implementation OnePlayerViewController

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setButtonAttributes];
    [self setLabelText];
    [self updateUI];
}

#pragma mark - Properties

- (PlayingCardSettings *)settings {
    if (!_settings) {
        _settings = [[PlayingCardSettings alloc] init];
    }
    return _settings;
}

#pragma mark - UserInterface

- (void)updateUI {
    self.numberOfCardsTextField.text = self.settings.onePlayerNumberOfCards;
    self.jokerSwitch.on = self.settings.jokers;
}

- (IBAction)touchedJokerSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.settings.jokers = YES;
    } else {
        self.settings.jokers = NO;
    }
}

- (void)setLabelText {
    self.textFieldLabel.text = @"Number Of Cards";
    self.switchLabel.text = @"Jokers";
}

#pragma mark - Start Button

#define BUTTON_CORNER_RADIUS 5.0

- (void)setButtonAttributes {
    [self.startButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    [self.startButton setAttributedTitle:[self setButton:self.startButton AttributedTitleForHeight:self.view.bounds.size.height] forState:UIControlStateNormal];
    self.startButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [self.startButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.startButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

#define BUTTON_FONT_SCALE_FACTOR .003

- (NSAttributedString *)setButton:(UIButton *)button AttributedTitleForHeight:(CGFloat)height {
    NSString *title = @"Next";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *buttonTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    buttonTitleFont = [buttonTitleFont fontWithSize:buttonTitleFont.pointSize * (height * BUTTON_FONT_SCALE_FACTOR)];
    
    NSAttributedString *buttonAttributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : buttonTitleFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-3}];
    
    return buttonAttributedTitle;
}
- (void)buttonTouchDown:(UIButton *)button {
    button.titleLabel.alpha = 0.15;
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.2 blue:.7 alpha:0.9]];
}

- (void)buttonTouchUpInside:(UIButton *)button {
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
        [button setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    }];
}

#pragma mark - Segue

- (void)prepareUITableViewController:(NumOfCardsPopoverContentTVC *)tvc {
    tvc.numberOfCardsSelections = self.settings.onePlayerNumberOfCardsOptionStrings;
    tvc.delegate = self;
}

-(void)prepareCardFitViewController:(CardFitViewController *)cfvc toPlayWithNumOfCards:(NSUInteger)numOfCards {
    if (!self.settings.jokers) {
        numOfCards = numOfCards - ((numOfCards/54) * 2);
    }
    cfvc.numberOfCards = numOfCards;
    cfvc.title = @"CardFitGame";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Popover Content"]) {
        if ([segue.destinationViewController isKindOfClass:[NumOfCardsPopoverContentTVC class]]) {
            UIPopoverPresentationController *popPC = segue.destinationViewController.popoverPresentationController;
            if (popPC != nil) {
                popPC.delegate = self;
                popPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
                [self prepareUITableViewController:segue.destinationViewController];
            }
        }
    } else if ([segue.identifier isEqualToString:@"Play Game"]) {
        if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) {
            CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
            [self prepareCardFitViewController:cfvc toPlayWithNumOfCards:[[self.settings.numberOfCardsOptionValues valueForKey:self.numberOfCardsTextField.text] intValue]];
        }
    }
}

#pragma mark - Number Of Cards Delegate Methods

- (void)selectedNumberOfCards:(NSString *)numberOfCards {
    self.settings.onePlayerNumberOfCards = numberOfCards;
    [self updateUI];
}

#pragma mark - UIPopoverPresentationControllerDelegate Methods

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self performSegueWithIdentifier:@"Popover Content" sender:textField];
    return NO;
}

@end

//
//  SideMenuViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SideMenuViewController.h"
#import "GameSettingsTVC.h"

@interface SideMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton; //Button for main menu
@property (weak, nonatomic) IBOutlet UIButton *optionsButton; //Button for game options
@property (nonatomic) NSUInteger counter; //Counts

@end

@implementation SideMenuViewController

#warning consider adding prepare for segue
- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    //Set up buttons
    [self setUpButton:self.mainMenuButton];
    [self setUpButton:self.optionsButton];
}

- (void)viewWillAppear:(BOOL)animated { //Called when view appears
    [super viewWillAppear:animated];
    //Animate buttons to dissapear
    self.mainMenuButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.optionsButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    NSArray *buttons = @[self.mainMenuButton, self.optionsButton];
    //Animate buttons to reappear
    [self animateButtons:buttons];
}

#warning re-write counter don't need it
- (NSUInteger)counter { //Return counter and set default to 0
    if (!_counter) {
        _counter = 0;
    }
    return _counter;
}

- (void)setUpButton:(UIButton *)button { //Set up button
    [button setBackgroundColor:self.view.backgroundColor];
    [button setAttributedTitle:[self buttonAttributedTitle] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTouchDown:(UIButton *)button { //Called when button touched
    button.titleLabel.alpha = 0.15;
}

- (void)buttonTouchUpInside:(UIButton *)button { //called when touch released inside button
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
    }];
}

- (NSAttributedString *)buttonAttributedTitle { //Returns title string for button
    NSString *title;
    if (self.counter == 0) {
        title = @"Main Menu";
        self.counter++;
    } else {
        title = @"Game Options";
    }
    //Set font
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    //Center text
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //Set attributes dictionary
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    //Return attributed string
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

//Values for animations
#define SPRING_DAMPING 0.70
#define SPRING_VELOCITY 0.10
#define ANIMATION_DURATION 0.40

- (void)animateButtons:(NSArray *)buttons { //Animates buttons to appear on screan
    CGFloat counter = 0;
    for (UIButton *button in buttons) {
        [UIView animateWithDuration:ANIMATION_DURATION delay:counter usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionTransitionNone animations:^{
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        counter += .2;
    }
}

@end

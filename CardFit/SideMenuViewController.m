//
//  SideMenuViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SideMenuViewController.h"
#import "GameSettingsTVC.h"

#define BUTTON_TITLE_ONE @"Main Menu"
#define BUTTON_TITLE_TWO @"Game Options"

@interface SideMenuViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation SideMenuViewController

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    //Set up buttons
    [self setUpButtons];
}

- (void)viewWillAppear:(BOOL)animated { //Called when view appears
    [super viewWillAppear:animated];
    //Animate buttons to dissapear
    for (UIButton *button in self.buttons) {
        button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    //Animate buttons to reappear
    [self animateButtons:self.buttons];
}

- (void)setUpButtons {
    int counter = 0;
    for (UIButton *button in self.buttons) { //Set up buttons
        button.tag = counter;
        [button setBackgroundColor:self.view.backgroundColor];
        [button setAttributedTitle:[self buttonAttributedTitleForButton:button] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        counter++;
    }
}

- (void)buttonTouchDown:(UIButton *)button { //Called when button touched
    button.titleLabel.alpha = 0.15;
}

- (void)buttonTouchUpInside:(UIButton *)button { //called when touch released inside button
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
    }];
}

- (NSAttributedString *)buttonAttributedTitleForButton:(UIButton *)button { //Returns title string for button
    NSString *title;
    if (button.tag == 0) {
        title = BUTTON_TITLE_ONE;
    } else {
        title = BUTTON_TITLE_TWO;
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

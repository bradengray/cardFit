//
//  SideMenuViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SettingsTVC.h"

#define BUTTON_TITLE_ONE @"Main Menu"
#define BUTTON_TITLE_TWO @"Game Options"

@interface SideMenuViewController ()
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *gameOptionsButton;

@end

@implementation SideMenuViewController

#pragma mark - ViewController Life Cycle

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

#pragma mark - Size Classes

#define COMPACT_FONT_SIZE 18.0
#define REGULAR_FONT_SIZE 24.0

- (BOOL)sizeClassIsRegularByRegular { //Tells if Size Class is Regular by regular
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Buttons

- (NSArray *)buttons { //Returns array of buttons
    return @[self.mainMenuButton, self.gameOptionsButton];
}

- (void)setUpButtons {
    int counter = 0;
    for (UIButton *button in self.buttons) { //Set up buttons
        button.tag = counter;
        [button setBackgroundColor:self.view.backgroundColor];
        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:button.titleLabel.text attributes:[self buttonAttributes]] forState:UIControlStateNormal];
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

- (UIFont *)buttonFont {
    return [UIFont fontWithName:@"Helvetica" size:[self sizeClassIsRegularByRegular] ? REGULAR_FONT_SIZE : COMPACT_FONT_SIZE];
}

- (NSDictionary *)buttonAttributes{ //Returns title string for button
    //Center text
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //Set attributes dictionary
    return @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : [self buttonFont], NSParagraphStyleAttributeName : paragraphStyle};
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

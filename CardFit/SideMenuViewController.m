//
//  SideMenuViewController.m
//  CardFit
//
//  Created by Braden Gray on 5/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SideMenuViewController.h"
//#import "Settings.h"
#import "GameSettingsTVC.h"

@interface SideMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (nonatomic) NSUInteger counter;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpButton:self.instructionsButton];
    [self setUpButton:self.optionsButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.instructionsButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.optionsButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    NSArray *buttons = @[self.instructionsButton, self.optionsButton];
    [self animateButtons:buttons];
}

- (NSUInteger)counter {
    if (!_counter) {
        _counter = 0;
    }
    return _counter;
}

- (void)setUpButton:(UIButton *)button {
    [button setBackgroundColor:self.view.backgroundColor];
    [button setAttributedTitle:[self buttonAttributedTitle] forState:UIControlStateNormal];
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
}

- (NSAttributedString *)buttonAttributedTitle {
    NSString *title;
    if (self.counter == 0) {
        title = @"Main Menu";
        self.counter++;
    } else {
        title = @"Game Options";
    }
    
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#define SPRING_DAMPING 0.70
#define SPRING_VELOCITY 0.10
#define ANIMATION_DURATION 0.40

- (void)animateButtons:(NSArray *)buttons {
    CGFloat counter = 0;
    for (UIButton *button in buttons) {
        [UIView animateWithDuration:ANIMATION_DURATION delay:counter usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionTransitionNone animations:^{
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        counter += .2;
    }
}

@end

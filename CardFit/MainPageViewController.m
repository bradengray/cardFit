//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "OnePlayerViewController.h"

@interface MainPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *multiPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *onePlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

#define BUTTON_CORNER_RADIUS 5.0

- (void)updateUI {
    [self.multiPlayerButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    [self.multiPlayerButton setAttributedTitle:[self setButton:self.multiPlayerButton AttributedTitleForHeight:self.view.bounds.size.height] forState:UIControlStateNormal];
    self.multiPlayerButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [self.multiPlayerButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.multiPlayerButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.onePlayerButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    [self.onePlayerButton setAttributedTitle:[self setButton:self.onePlayerButton AttributedTitleForHeight:self.view.bounds.size.height] forState:UIControlStateNormal];
    self.onePlayerButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [self.onePlayerButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.onePlayerButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.settingsButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    [self.settingsButton setAttributedTitle:[self setButton:self.settingsButton AttributedTitleForHeight:self.view.bounds.size.height] forState:UIControlStateNormal];
    self.settingsButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [self.settingsButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.settingsButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

#define BUTTON_FONT_SCALE_FACTOR .003

- (NSAttributedString *)setButton:(UIButton *)button AttributedTitleForHeight:(CGFloat)height {
    NSString *title;
    if (button == self.multiPlayerButton) {
        title = @"MultiPlayer";
    } else if (button == self.onePlayerButton) {
        title = @"One Player";
    } else if (button == self.settingsButton) {
        title = @"Settings";
    }
    
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

- (void)prepareViewController:(OnePlayerViewController *)opvc {
    opvc.title = @"One Player";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"One Player Identifier"]) {
        if ([segue.destinationViewController isKindOfClass:[OnePlayerViewController class]]) {
            OnePlayerViewController *opvc = (OnePlayerViewController *)segue.destinationViewController;
            [self prepareViewController:opvc];
        }
    }
}

@end

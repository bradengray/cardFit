//
//  ViewController.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitViewController.h"
#import "CardFitLayoutView.h"
#import <CoreMotion/CoreMotion.h>

@interface CardFitViewController ()
@property (nonatomic, strong) Deck *deck; //of Cards
@property (nonatomic) NSUInteger cardCount;
@property (nonatomic, strong) CardFitLayoutView *cardFitLayoutView;
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *taskLabel;

@end

@implementation CardFitViewController

#pragma mark - ViewController Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createButton];
    self.currentCard = [self drawRandomCard];
    [self updateUI];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationLandscapeLeft) {
             self.cardFitLayoutView.rotated = YES;
             self.cardFitLayoutView.landscapeLeft = YES;
         } else if (orientation == UIInterfaceOrientationLandscapeRight) {
             self.cardFitLayoutView.rotated = YES;
             self.cardFitLayoutView.landscapeLeft = NO;
         } else {
             self.cardFitLayoutView.rotated = NO;
             self.cardFitLayoutView.landscapeLeft = NO;
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self updateUI];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Properties

#define CARD_ASPECT_RATIO 0.620
#define CORNER_OFFSET 5.0

- (CGFloat)cardHeight {
    return [self cardWidth] / CARD_ASPECT_RATIO;
}

- (CGFloat)cardWidth {
    return (self.view.bounds.size.width - (CORNER_OFFSET * 2.0));
}

- (CardFitLayoutView *)cardFitLayoutView {
    if (!_cardFitLayoutView) {
        _cardFitLayoutView = [[CardFitLayoutView alloc] init];
        _cardFitLayoutView.size = self.view.frame.size;
        _cardFitLayoutView.aspectRatio = self.cardAspectRatio;
        _cardFitLayoutView.maxSubViewWidth = self.maxCardWidth;
        _cardFitLayoutView.maxSubViewHeight = self.maxCardHeight;
        _cardFitLayoutView.minSubViewWidth = self.minCardWidth;
        _cardFitLayoutView.minSubViewHeight = self.minCardHeight;
    }
    return _cardFitLayoutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

- (NSUInteger)cardCount {
    if (!_cardCount ) {
        _cardCount = 0;
    }
    return _cardCount;
}

- (Deck *)deck {
    if (!_deck) {
        _deck = [self createDeck];
    }
    return _deck;
}

- (UILabel *)taskLabel {
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] init];
    }
    return _taskLabel;
}


- (void)updateUI {
    if (self.currentCard) {
        if (!self.cardView) {
            self.cardView = [self createCardViewWithCard:self.currentCard];
            self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
            [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            [self.view addSubview:self.cardView];
            [self setLabelTitleForCardView:self.cardView];
            self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
            [self.view addSubview:self.taskLabel];
        } else {
            [UIView transitionWithView:self.cardView
                              duration:.001
                               options:UIViewAnimationOptionCurveEaseIn
            animations:^{
                self.cardView.frame = [self.cardFitLayoutView frameForCardView:self.cardView];
                self.startButton.frame = [self.cardFitLayoutView frameForStartButton:self.startButton];
//                self.taskLabel.font = [self labelfont];
                self.taskLabel.frame = [self.cardFitLayoutView frameForTasklabel:self.taskLabel];
            } completion:nil];
        }
    } else {
        NSLog(@"Error No Card");
    }
}

- (Card *)drawRandomCard {
    self.cardCount++;
    NSLog(@"%lu", (unsigned long)self.cardCount);
    Card *card = [self.deck drawRandomCard];
    if (!card) {
        NSLog(@"No More Cards");
    }
    
    return card;
}

#pragma mark - StartButton

- (void)createButton {
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.startButton.layer.cornerRadius = 10;
    
    self.startButton.frame = [self.cardFitLayoutView frameForStartButton:self.startButton];
    
    [self.startButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    
    [self.startButton setAttributedTitle:[self setButtonAttributedTitleForHeight:self.startButton.frame.size.height] forState:UIControlStateNormal];
    
    [self.startButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.startButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.startButton];
}

#define BUTTON_FONT_SCALE_FACTOR 25

- (NSAttributedString *)setButtonAttributedTitleForHeight:(CGFloat)height {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *buttonTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    buttonTitleFont = [buttonTitleFont fontWithSize:buttonTitleFont.pointSize * (height / BUTTON_FONT_SCALE_FACTOR)];
    
    NSAttributedString *buttonAttributedTitle = [[NSAttributedString alloc] initWithString:@"Start" attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : buttonTitleFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-3}];
    
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
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Label

#define LABEL_FONT_SCALE_FACTOR 0.005

- (CGFloat)labelFontScaleFactor {
    CGFloat cardHeight;
    if (self.cardFitLayoutView.rotated) {
        cardHeight = self.view.bounds.size.width;
    } else {
        cardHeight = self.view.bounds.size.height;
    }
    return cardHeight * LABEL_FONT_SCALE_FACTOR;
}

- (void)setLabelTitleForCardView:(UIView *)cardView {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
//    UIFont *labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//    labelFont = [labelFont fontWithSize:labelFont.pointSize * [self labelFontScaleFactor]];
    
    self.taskLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [self setTitleForCardView:cardView]] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : [self labelfont], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}];
    
    self.taskLabel.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:0.50];
}

- (UIFont *)labelfont {
    UIFont *labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    labelFont = [labelFont fontWithSize:labelFont.pointSize * [self labelFontScaleFactor]];
    return labelFont;
}

- (NSString *)setTitleForCardView:(UIView *)cardView { //abstract
    return nil;
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    [self.cardView removeFromSuperview];
    self.cardView = nil;
    self.currentCard = [self drawRandomCard];
    [self updateUI];
}

#pragma mark - Abstract Methods

- (Deck *)createDeck { //abstract
    return nil;
}

- (UIView *)createCardViewWithCard:(Card *)card { // abstract
    return nil;
}

- (void)updateCardView:(UIView *)cardView withCard:(Card *)card { // abstract
    return;
}

@end

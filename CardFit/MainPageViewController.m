//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "CardFitViewController.h"
#import "MultiplayerNetworking.h"

//Adheres to UIPickerViewDelegate and UIPickerViewDataSource Protocols
@interface MainPageViewController () <UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *flyingSoloButton; //Outlet for multiplayer button
@property (weak, nonatomic) IBOutlet UIButton *withFriendsButton; //Outlet for singleplayer button
@property (weak, nonatomic) IBOutlet UIButton *nextButton; //Outlet for nextbutton
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView; //Pickerview for selecting number of cards
@property (nonatomic, strong) GameDataController *dataSource; //For Accessing Game Data
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //networking engine object
@property (nonatomic, strong) UIBarButtonItem *sidebarButton; //Navigationbar button for side menu
@property (nonatomic) BOOL gameTypeSelected; //Tracks whether game type was selected single player or multiplayer
@property (nonatomic) BOOL multiplayerReady; //Tracks player authentication

@end

@implementation MainPageViewController

#pragma mark - View Life Cycle

#define UBIQUITY_TOKEN @"com.apple.cardfit.UbiquityIdentityToken"

//- (void)iCloudAlert {
//    id currentiCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:UBIQUITY_TOKEN];
//    if (!currentiCloudToken) {// && firstLaunchWithiCloudAvailable) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Storage Option"
//                                                                       message:@"Should documents be stored in iCloud and available on all your devices?"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Local Only"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:nil];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Use iCloud"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:nil];
//        [alert addAction:action1];
//        [alert addAction:action2];
//        
//        [self presentViewController:alert
//                           animated:YES
//                         completion:nil];
//    }
//}

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    //Set delegates and hide picker view nad next button
    self.pickerView.dataSource = self.dataSource;
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    self.pickerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.80];
    self.nextButton.hidden = YES;
//    [self iCloudAlert];
    //Set up buttons
    [self setUpButton:self.flyingSoloButton withTitle:@"F L Y I N G\nS O L O"];
    [self setUpButton:self.withFriendsButton withTitle:@"W I T H\nF R I E N D S"];
    [self setUpButton:self.nextButton withTitle:@"N E X T"];
    //Set up reveal view controller for side menu
    self.revealViewController.rightViewController = nil;
    [self setMenuBarButton];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated { //Called when view appears
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"BackGround"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + 25, imageView.frame.size.width, imageView.frame.size.height);
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.75 green:0.80 blue:0.86 alpha:0.7] CGColor], (id)[[UIColor colorWithRed:0.02 green:0.44 blue:0.75 alpha:0.80] CGColor], nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
    //Add radio stations for player authentication and match maker view controller
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerAuthenticated)
                                                 name:LocalPlayerIsAuthenticated
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentMatchMakerViewController)
                                                 name:PresentGKMatchMakerViewController
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(segueToGame)
                                                 name:GKMatchMakerViewControllerDismissed
                                               object:nil];
    //Check if player is authenticated to enable multiplayer selection
    if (!self.multiplayerReady) {
        self.withFriendsButton.enabled = NO;
        self.withFriendsButton.titleLabel.alpha = 0.15;
    }
}

- (void)dealloc { //Stop listening to radio stations
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Radio Station Methods

- (void)playerAuthenticated { //Called when player is authenticated
    //Enable multiplayer game
    self.multiplayerReady = YES;
    self.withFriendsButton.enabled = YES;
    self.withFriendsButton.titleLabel.alpha = 1.0;
}

- (void)presentMatchMakerViewController { //Called when MatchMakerViewController is wanted
    self.dataSource.multiplayer = YES;
    self.networkingEngine = [[MultiplayerNetworking alloc] init];
    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self.networkingEngine];
}

- (void)segueToGame { //Called when ready to segue to game
    [self performSegueWithIdentifier:@"Play Game" sender:self.nextButton];
}

#pragma mark - Properties

- (BOOL)multiplayerReady { //Returns multiplayerReady and checks player authentication
    if (!_multiplayerReady) {
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    }
    return _multiplayerReady;
}

- (GameDataController *)dataSource {
    if (!_dataSource) {
        _dataSource = [self createDataSource];
    }
    return _dataSource;
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
    self.gameTypeSelected = !self.gameTypeSelected;
    //Animate buttons
    [UIView animateWithDuration:0.15 animations:^{
        self.nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        //Hide pickerview and next button also setup navigation bar menu button
        [self setMenuBarButton];
        self.pickerView.hidden = YES;
        self.nextButton.hidden = YES;
        NSArray *objects = @[self.flyingSoloButton, self.withFriendsButton];
        [self animateObjects:objects];
    }];
}

- (void)setUpButton:(UIButton *)button withTitle:(NSString *)title { //Set up button with title
    [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
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
    if (!self.gameTypeSelected) {
        //Decide if multiplayer or not and set datasources for picker views
        if (button == self.withFriendsButton) {
            self.dataSource.multiplayer = YES;
            [self.pickerView reloadAllComponents];
        } else if (button == self.flyingSoloButton) {
            self.dataSource.multiplayer = NO;
            [self.pickerView reloadAllComponents];
        }
        [self updatePickerView];
        //Animate buttons and picker views
        [UIView animateWithDuration:0.15 animations:^{
            self.flyingSoloButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.withFriendsButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self setCancelBarButton];
            self.flyingSoloButton.hidden = YES;
            self.withFriendsButton.hidden = YES;
            NSArray *objects = @[self.pickerView, self.nextButton];
            [self animateObjects:objects];
        }];
        //Set whether game type was chosen or not.
        self.gameTypeSelected = !self.gameTypeSelected;
    } else { //If game type selected the Next button must have been selected. Play game.
        if (self.dataSource.multiplayer) {
            [self presentMatchMakerViewController];
        } else {
            [self performSegueWithIdentifier:@"Play Game" sender:button];
        }
    }
}

#define BUTTON_FONT_SCALE_FACTOR .0379
#define BUTTON_FONT_SCALE_FACTOR2 .0616

#define FONT @"Helvetica"
#define FONT_BOLD @"Helvetica-Bold"

- (UIFont *)getScaledFontBold:(BOOL)bold {
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont fontWithName:bold ? FONT_BOLD : FONT size:1];
    float scaleFactor = bold ? BUTTON_FONT_SCALE_FACTOR2 : BUTTON_FONT_SCALE_FACTOR;
    font = [font fontWithSize:font.pointSize * (self.view.bounds.size.height * scaleFactor)];
    return font;
}

- (NSDictionary *)getAttributesDictionaryForFontBold:(BOOL)bold Centered:(BOOL)centered {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = centered ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    return @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-1, NSFontAttributeName : [self getScaledFontBold:bold], NSParagraphStyleAttributeName : paragraphStyle};
}

- (NSAttributedString *)buttonAttributedTitleWithString:(NSString *)string { //Returns attributed string for button titles
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    BOOL twoWords = [components count] > 1 ? YES : NO;
    
    NSString *string1 = components[0];
    NSAttributedString *aString1;
    if (twoWords) {
        NSString *string2 = components[1];
        aString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", string1] attributes:[self getAttributesDictionaryForFontBold:NO Centered:YES]];
        NSAttributedString *aString2 = [[NSAttributedString alloc] initWithString:string2 attributes:[self getAttributesDictionaryForFontBold:YES Centered:YES]];
        NSMutableAttributedString *myString = [aString1 mutableCopy];
        [myString appendAttributedString:aString2];
        return myString;
    } else {
        aString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string1] attributes:[self getAttributesDictionaryForFontBold:YES Centered:YES]];
        return aString1;
    }

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
                button.hidden = NO;
                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        } else if ([object isKindOfClass:[UIPickerView class]]) {
            UIPickerView *picker = (UIPickerView *)object;
            [UIView animateWithDuration:ANIMATION_DURATION delay:counter usingSpringWithDamping:SPRING_DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionTransitionNone animations:^{
                picker.hidden = NO;
                picker.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *componentTitle = self.dataSource.dataSectionTitles[component];
    NSArray *titles = [self.dataSource.data objectForKey:componentTitle];
    return [[NSAttributedString alloc] initWithString:[titles objectAtIndex:row] attributes:[self getAttributesDictionaryForFontBold:YES Centered:YES]]; //Return string for row
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { //Called when row selected
    [self.dataSource didSelectIndexPath:[NSIndexPath indexPathForRow:row inSection:component]]; //Store data for row
}

-(void)updatePickerView { //Updates pickerview to most recently selected row
    [self.pickerView reloadAllComponents];
    NSInteger row = [self.dataSource rowForSelectedNumberOfCards];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Performs segue
    if ([sender isKindOfClass:[UIButton class]]) { //Check sender class
        if ((UIButton *)sender == self.nextButton) { //Check sender
            if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) { //Check destination
                CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
//                cfvc.multiplayer = self.dataSource.multiplayer;
                cfvc.dataSource = self.dataSource;
                //Check to see what gameType
                if (self.dataSource.multiplayer) {
                    self.networkingEngine.delegate = cfvc;
                    cfvc.networkingEngine = self.networkingEngine;
                }
            }
        }
    }
}

#pragma mark - Abstract Methods

- (GameDataController *)createDataSource { //Abstract
    return nil;
}

@end

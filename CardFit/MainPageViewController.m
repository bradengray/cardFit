//
//  MainPageViewController.m
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "Settings.h"
#import "CardFitViewController.h"
#import "MultiplayerNetworking.h"

//Adheres to UIPickerViewDelegate and UIPickerViewDataSource Protocols
@interface MainPageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
//@property (weak, nonatomic) IBOutlet UIButton *flyingSoloButton; //Outlet for multiplayer button
//@property (weak, nonatomic) IBOutlet UIButton *withFriendsButton; //Outlet for singleplayer button
//@property (weak, nonatomic) IBOutlet UIButton *nextButton; //Outlet for nextbutton
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView; //Pickerview for selecting number of cards
@property (nonatomic, strong) Settings *settings; //Settings object
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //networking engine object
@property (nonatomic, strong) UIBarButtonItem *sidebarButton; //Navigationbar button for side menu
@property (nonatomic) BOOL selected; //Tracks whether game type was selected single player or multiplayer
@property (nonatomic) BOOL multiPlayer; //Tracks whether multiplayer option is selected or not
@property (nonatomic) BOOL multiplayerReady; //Tracks player authentication

@end

@implementation MainPageViewController

#pragma mark - View Life Cycle

#define UBIQUITY_TOKEN @"com.apple.cardfit.UbiquityIdentityToken"

- (void)iCloudAlert {
    id currentiCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:UBIQUITY_TOKEN];
    if (!currentiCloudToken) {// && firstLaunchWithiCloudAvailable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Storage Option"
                                                                       message:@"Should documents be stored in iCloud and available on all your devices?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Local Only"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Use iCloud"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

//- (void)tomtom {
//    __block NSURL *myContainer;
//    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        myContainer = [[NSFileManager defaultManager]
//                       URLForUbiquityContainerIdentifier:@"iCloud.com.graycode.cardfit"];
//        if (myContainer != nil) {
//            // Your app can write to the iCloud container
//            
//            dispatch_async (dispatch_get_main_queue (), ^(void) {
//                // On the main thread, update UI and state as appropriate
//            });
//        }
//    });
//    //    This example assumes that you have previously defined myContainer as an instance variable of type NSURL prior to executing this code.
//    
//    
//}

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    //Set delegates and hide picker view nad next button
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
//    UIButton *nextButton = self.buttons[2];
    [self getButtonAtIndex:2].hidden = YES;
    [self iCloudAlert];
//    [self tomtom];
    //Set up buttons
    [self setUpButtons];
//    [self setUpButton:self.flyingSoloButton withTitle:@"FLYING SOLO"];
//    [self setUpButton:self.withFriendsButton withTitle:@"WITH FRIENDS"];
//    [self setUpButton:self.nextButton withTitle:@"Next"];
    //Set up reveal view controller for side menu
    self.revealViewController.rightViewController = nil;
    [self setMenuBarButton];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated { //Called when view appears
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"BackGround"];
//    [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + self.navigationController.navigationBar.frame.size.height, imageView.frame.size.width, imageView.frame.size.height);
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    //Add radio stations for player authentication and match maker view controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMatchMakerViewController) name:PresentGKMatchMakerViewController object:nil];
    //Check if player is authenticated to enable multiplayer selection
    [self shouldEnableMultiplayer];
//    if (!self.multiplayerReady) {
////        self.withFriendsButton.enabled = NO;
////        self.withFriendsButton.titleLabel.alpha = 0.15;
//        [self shouldEnableMultiplayer]
//    }
}

- (void)shouldEnableMultiplayer {
    UIButton *button = [self getButtonAtIndex:1];
    if (!self.multiplayerReady) {
        button.enabled = NO;
        button.titleLabel.alpha = 0.15;
    } else {
        button.enabled = YES;
        button.titleLabel.alpha = 1.0;
    }
}

- (void)dealloc { //Stop listening to radio stations
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Radio Station Methods

- (void)playerAuthenticated { //Called when player is authenticated
    //Enable multiplayer game
    [self shouldEnableMultiplayer];
//    self.multiplayerReady = YES;
//    self.withFriendsButton.enabled = YES;
//    self.withFriendsButton.titleLabel.alpha = 1.0;
}

- (void)presentMatchMakerViewController { //Called when MatchMakerViewController is wanted
    self.multiPlayer = YES;
//    UIButton *nextButton = self.buttons[2];
    [self performSegueWithIdentifier:@"Play Game" sender:[self getButtonAtIndex:2]];
}

#pragma mark - Properties

- (BOOL)multiplayerReady { //Returns multiplayerReady and checks player authentication
    if (!_multiplayerReady) {
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    }
    return _multiplayerReady;
}

- (Settings *)settings { //Initializes Settings object
    if (!_settings) {
        _settings = [[Settings alloc] init];
    }
    return _settings;
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
    self.selected = !self.selected;
    //Animate buttons
    UIButton *flyingSoloButton = [self getButtonAtIndex:0];
    UIButton *withFriendsButton = [self getButtonAtIndex:1];
    UIButton *nextButton = [self getButtonAtIndex:2];
    [UIView animateWithDuration:0.15 animations:^{
        nextButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.pickerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        //Hide pickerview and next button also setup navigation bar menu button
        [self setMenuBarButton];
        self.pickerView.hidden = YES;
        nextButton.hidden = YES;
//        [self.withFriendsButton setAttributedTitle:[self buttonAttributedTitleWithString:@"with Friends"] forState:UIControlStateNormal];
        flyingSoloButton.hidden = NO;
        withFriendsButton.hidden = NO;
        NSArray *objects = @[flyingSoloButton, withFriendsButton];
        [self animateObjects:objects];
    }];
}

- (void)setUpButtons { //Set up button with title
    int buttonTag = 0;
    for (UIButton *button in self.buttons) {
        button.tag = buttonTag;
        [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
        [button setAttributedTitle:[self buttonAttributedTitleForButton:(UIButton *)button] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        buttonTag++;
    }
}

- (UIButton *)getButtonAtIndex:(int)index {
    return self.buttons[index];
}

//- (void)setUpButton:(UIButton *)button withTitle:(NSString *)title { //Set up button with title
//    [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
//    [button setAttributedTitle:[self buttonAttributedTitleWithString:title] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)buttonTouchDown:(UIButton *)button { //Animates button when touched
    button.titleLabel.alpha = 0.15;
}

- (void)buttonTouchUpInside:(UIButton *)button { //Button touch released inside button
    //Animate touch
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.alpha = 1.0;
    }];
    //If game type not selected
    if (!self.selected) {
        //Decide if multiplayer or not and set datasources for picker views
        if (button.tag == 1) {
            self.multiPlayer = YES;
            self.pickerView.dataSource = nil;
            self.pickerView.dataSource = self;
            [self updatePickerView];
        } else if (button.tag == 0) {
            self.multiPlayer = NO;
            self.pickerView.dataSource = nil;
            self.pickerView.dataSource = self;
            [self updatePickerView];
        }
        //Animate buttons and picker views
        [UIView animateWithDuration:0.15 animations:^{
            [self transformAllViewsSmall];
        } completion:^(BOOL finished) {
            [self setCancelBarButton];
//            self.flyingSoloButton.hidden = YES;
//            self.withFriendsButton.hidden = YES;
            [self hideNextButtonAndPickerView:self.selected];
//            [self.withFriendsButton setAttributedTitle:[self buttonAttributedTitleWithString:@"Next"] forState:UIControlStateNormal];
//            self.pickerView.hidden = NO;
//            self.nextButton.hidden = NO;
            NSArray *objects = @[self.pickerView, [self getButtonAtIndex:2]];
            [self animateObjects:objects];
        }];
        //Set whether game type was chosen or not.
        self.selected = !self.selected;
    } else { //If game type selected the Next button must have been selected. Play game.
        [self performSegueWithIdentifier:@"Play Game" sender:button];
    }
}

- (void)hideNextButtonAndPickerView:(BOOL)selected {
    if (!self) {
        for (UIButton *button in self.buttons) {
            if (button.tag != 2) {
                button.hidden = YES;
            }
        }
    } else {
        for (UIButton *button in self.buttons) {
            if (button.tag == 2) {
                button.hidden = YES;
            }
            self.pickerView.hidden = YES;
        }
    }
}

- (void)transformAllViewsSmall {
    static float size = 0.01;
    for (UIButton *button in self.buttons) {
        button.transform = CGAffineTransformMakeScale(size, size);
    }
        self.pickerView.transform = CGAffineTransformMakeScale(size, size);
}

#define BUTTON_FONT_SCALE_FACTOR .002
#define BUTTON_FONT_SCALE_FACTOR2 .004

- (NSString *)titleForButton:(UIButton *)button {
    if (button.tag < 1) {
        return @"FLYING SOLO";
    } else if (button.tag == 1) {
        return @"WITH FRIENDS";
    } else {
        return @"NEXT";
    }
}

- (NSAttributedString *)buttonAttributedTitleForButton:(UIButton *)button { //Returns attributed string for button titles
    NSArray *components = [[self titleForButton:button] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL twoWords = [components count] > 1 ? YES : NO;
    
    NSString *string1 = components[0];
    NSUInteger length1 = [string1 length];
    unichar buffer1[length1+1];
    NSMutableString *newstring1 = [[NSMutableString alloc] init];
    [string1 getCharacters:buffer1 range:NSMakeRange(0, length1)];
    for (int i = 0; i < length1; i++) {
        [newstring1 appendString:[NSString stringWithFormat:@"%C ", buffer1[i]]];
    }
    string1 = newstring1;
    
    
    NSString *string2;
    if (twoWords) {
        string2 = components[1];
        NSUInteger length2 = [string2 length];
        unichar buffer2[length2+1];
        NSMutableString *newstring2 = [[NSMutableString alloc] init];
        [string2 getCharacters:buffer2 range:NSMakeRange(0, length2)];
        for (int i = 0; i < length2; i++) {
            [newstring2 appendString:[NSString stringWithFormat:@"%C ", buffer2[i]]];
        }
        string2 = newstring2;
    }
    
    UIFont *font1 = [[UIFont alloc] init];
    font1 = [UIFont fontWithName:@"Helvetica" size:16];
    font1 = [font1 fontWithSize:font1.pointSize * (self.view.bounds.size.height * BUTTON_FONT_SCALE_FACTOR)];
    
    UIFont *font2 = [[UIFont alloc] init];
    font2 = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    font2 = [font2 fontWithSize:font2.pointSize * (self.view.bounds.size.height * BUTTON_FONT_SCALE_FACTOR2)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font1, NSParagraphStyleAttributeName : paragraphStyle};
    
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font2, NSParagraphStyleAttributeName : paragraphStyle};
    
    NSAttributedString *aString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", string1] attributes:attributes1];
    NSAttributedString *aString2;
    if (twoWords) {
        aString2 = [[NSAttributedString alloc] initWithString:string2 attributes:attributes2];
    }
    
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] init];
    [myString appendAttributedString:aString1];
    if (twoWords) {
        [myString appendAttributedString:aString2];
    }
    
    return myString;
}

//- (NSAttributedString *)buttonAttributedTitleWithString:(NSString *)string { //Returns attributed string for button titles
//    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    BOOL twoWords = [components count] > 1 ? YES : NO;
//    
//    NSString *string1 = components[0];
//    NSUInteger length1 = [string1 length];
//    unichar buffer1[length1+1];
//    NSMutableString *newstring1 = [[NSMutableString alloc] init];
//    [string1 getCharacters:buffer1 range:NSMakeRange(0, length1)];
//    for (int i = 0; i < length1; i++) {
//        [newstring1 appendString:[NSString stringWithFormat:@"%C ", buffer1[i]]];
//    }
//    string1 = newstring1;
//
//    
//    NSString *string2;
//    if (twoWords) {
//        string2 = components[1];
//        NSUInteger length2 = [string2 length];
//        unichar buffer2[length2+1];
//        NSMutableString *newstring2 = [[NSMutableString alloc] init];
//        [string2 getCharacters:buffer2 range:NSMakeRange(0, length2)];
//        for (int i = 0; i < length2; i++) {
//            [newstring2 appendString:[NSString stringWithFormat:@"%C ", buffer2[i]]];
//        }
//        string2 = newstring2;
//    }
//    
//    UIFont *font1 = [[UIFont alloc] init];
//    font1 = [UIFont fontWithName:@"Helvetica" size:16];
//    font1 = [font1 fontWithSize:font1.pointSize * (self.view.bounds.size.height * BUTTON_FONT_SCALE_FACTOR)];
//    
//    UIFont *font2 = [[UIFont alloc] init];
//    font2 = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//    font2 = [font2 fontWithSize:font2.pointSize * (self.view.bounds.size.height * BUTTON_FONT_SCALE_FACTOR2)];
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    NSDictionary *attributes1 = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font1, NSParagraphStyleAttributeName : paragraphStyle};
//    
//    NSDictionary *attributes2 = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSStrokeColorAttributeName : [UIColor blackColor], NSStrokeWidthAttributeName : @-2, NSFontAttributeName : font2, NSParagraphStyleAttributeName : paragraphStyle};
//    
//    NSAttributedString *aString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", string1] attributes:attributes1];
//    NSAttributedString *aString2;
//    if (twoWords) {
//        aString2 = [[NSAttributedString alloc] initWithString:string2 attributes:attributes2];
//    }
//    
//    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] init];
//    [myString appendAttributedString:aString1];
//    if (twoWords) {
//        [myString appendAttributedString:aString2];
//    }
//    
//    return myString;
//}

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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { //Set number of components for picker view to 1 column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { //Set rows for pickerview
    //Check to see what gameType
    if (!self.multiPlayer) {
        return [self.settings.onePlayerNumberOfCardsOptionStrings count];
    } else {
        return [self.settings.multiplayerNumberOfCardsOptionStrings count];
    }
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { //Gets title for row
    //Check to see what gameType
    if (!self.multiPlayer) {
        return self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        return self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { //Called when row selected
    //Check to see what gameType
    if (!self.multiPlayer) {
        self.settings.onePlayerNumberOfCards = self.settings.onePlayerNumberOfCardsOptionStrings[row];
    } else {
        self.settings.multiplayerNumberOfCards = self.settings.multiplayerNumberOfCardsOptionStrings[row];
    }
}

-(void)updatePickerView { //Updates pickerview to moste recently selected row
    NSInteger row;
    //Check to see what gameType
    if (!self.multiPlayer) {
        row = [self.settings.onePlayerNumberOfCardsOptionStrings indexOfObject:self.settings.onePlayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    } else {
        row = [self.settings.multiplayerNumberOfCardsOptionStrings indexOfObject:self.settings.multiplayerNumberOfCards];
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Performs segue
    if ([sender isKindOfClass:[UIButton class]]) { //Check sender class
        if ([(UIButton *)sender tag] == 2) { //Check sender
            if ([segue.destinationViewController isKindOfClass:[CardFitViewController class]]) { //Check destination
                CardFitViewController *cfvc = (CardFitViewController *)segue.destinationViewController;
                //Check to see what gameType
                if (self.multiPlayer) {
                    self.networkingEngine = [[MultiplayerNetworking alloc] init];
                    self.networkingEngine.delegate = cfvc;
                    cfvc.networkingEngine = self.networkingEngine;
                    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self.networkingEngine];
                }
                cfvc.title = @"CardFit Game";
                cfvc.multiplayer = self.multiPlayer;
            }
        }
    }
}

@end

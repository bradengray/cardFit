//
//  SettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsTVC.h"
#import "Settings.h"

@interface  SettingsTVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *spadesExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *clubsExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *heartsExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *diamondsExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *acesExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *jokersExerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *jacksRepsTextField;
@property (weak, nonatomic) IBOutlet UITextField *queensRepsTextField;
@property (weak, nonatomic) IBOutlet UITextField *kingsRepsTextField;
@property (weak, nonatomic) IBOutlet UITextField *acesRepsTextField;
@property (weak, nonatomic) IBOutlet UITextField *jokersRepsTextField;
@property (strong, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic, strong) NSString *textFieldRecentValue;

@property (nonatomic, strong) Settings *settings;

@end

@implementation SettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDefaultButton];
    [self loadTextFieldValues];
}

- (Settings *)settings {
    if (!_settings) {
        _settings = [[Settings alloc] init];
    }
    return _settings;
}

#define CORNER_RADIUS 5.0

- (void)createDefaultButton {
    [self.defaultButton setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:.8 alpha:1]];
    [self.defaultButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Reset Defaults" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]}] forState:UIControlStateNormal];
    self.defaultButton.layer.cornerRadius = CORNER_RADIUS;
    [self.defaultButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.defaultButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchDown:(UIButton *)button {
    button.titleLabel.alpha = 0.15;
    button.backgroundColor = [UIColor colorWithRed:0 green:.2 blue:.7 alpha:.9];
}

- (void)touchUpInside:(UIButton *)button {
    [UIView animateWithDuration:.3 animations:^{
        button.titleLabel.alpha = 1.0;
        button.backgroundColor = [UIColor colorWithRed:0 green:.3 blue:.8 alpha:1];
    }];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self loadTextFieldValues];
}

#pragma mark - TextFields

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveUserInputForTextField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveUserInputForTextField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    self.textFieldRecentValue = textField.text;
}

- (void)loadTextFieldValues {
    self.spadesExerciseTextField.text = self.settings.spadesExerciseString;
    self.clubsExerciseTextField.text = self.settings.clubsExerciseString;
    self.heartsExerciseTextField.text = self.settings.heartsExerciseString;
    self.diamondsExerciseTextField.text = self.settings.diamondsExerciseString;
    self.acesExerciseTextField.text = self.settings.acesExerciseString;
    self.jokersExerciseTextField.text = self.settings.jokersExerciseString;
    
    UIToolbar *numberToolBar = [self numberToolBar];
    self.jacksRepsTextField.inputAccessoryView = numberToolBar;
    self.queensRepsTextField.inputAccessoryView = numberToolBar;
    self.kingsRepsTextField.inputAccessoryView = numberToolBar;
    self.acesRepsTextField.inputAccessoryView = numberToolBar;
    self.jokersRepsTextField.inputAccessoryView = numberToolBar;
    
    self.jacksRepsTextField.text = [NSString stringWithFormat:@"%lu", self.settings.jacksReps];
    self.queensRepsTextField.text = [NSString stringWithFormat:@"%lu", self.settings.queensReps];
    self.kingsRepsTextField.text = [NSString stringWithFormat:@"%lu", self.settings.kingsReps];
    self.acesRepsTextField.text = [NSString stringWithFormat:@"%lu", self.settings.acesReps];
    self.jokersRepsTextField.text = [NSString stringWithFormat:@"%lu", self.settings.jokersReps];
}

- (UIToolbar *)numberToolBar {
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)cancelNumberPad {
    [self.currentTextField resignFirstResponder];
}

-(void)doneWithNumberPad {
//    [self saveUserInputForTextField:self.currentTextField];
    [self saveUserInputForTextField];
    [self.currentTextField resignFirstResponder];
}

#define MINIMUM_STRING_LENGTH 20
#define MAX_REPS_NUMBER 1000

- (void)saveUserInputForTextField {
    
    if (!self.currentTextField.text) {
        [self alert:@"Entry Required"];
        self.currentTextField.text = self.textFieldRecentValue;
    } else {
        if ([self numberField]) {
            if ([self.currentTextField.text integerValue] > MAX_REPS_NUMBER) {
                [self alert:[NSString stringWithFormat:@"Reps Must Be Less Than %d", MAX_REPS_NUMBER]];
                self.currentTextField.text = self.textFieldRecentValue;
            } else {
                [self saveTextField:self.currentTextField];
            }
        } else {
            if ([self.currentTextField.text length] > MINIMUM_STRING_LENGTH) {
                [self alert:[NSString stringWithFormat:@"Exercise Must Contain Less Than %d Characters", MINIMUM_STRING_LENGTH]];
                self.currentTextField.text = self.textFieldRecentValue;
            } else {
                [self saveTextField:self.currentTextField];
            }
        }
    }
}

- (void)saveTextField:(UITextField *)textField {
    if (textField == self.spadesExerciseTextField) {
        self.settings.spadesExerciseString = textField.text;
    } else if (textField == self.clubsExerciseTextField) {
        self.settings.clubsExerciseString = textField.text;
    } else if (textField == self.heartsExerciseTextField) {
        self.settings.heartsExerciseString = textField.text;
    } else if (textField == self.diamondsExerciseTextField) {
        self.settings.diamondsExerciseString = textField.text;
    } else if (textField == self.acesExerciseTextField) {
        self.settings.acesExerciseString = textField.text;
    } else if (textField == self.jokersExerciseTextField) {
        self.settings.jokersExerciseString = textField.text;
    } else if (textField == self.jacksRepsTextField) {
        self.settings.jacksReps = [textField.text integerValue];
    } else if (textField == self.queensRepsTextField) {
        self.settings.queensReps = [textField.text integerValue];
    } else if (textField == self.kingsRepsTextField) {
        self.settings.kingsReps = [textField.text integerValue];
    } else if (textField == self.acesRepsTextField) {
        self.settings.acesReps = [textField.text integerValue];
    } else if (textField == self.jokersRepsTextField) {
        self.settings.jokersReps = [textField.text integerValue];
    }
}

- (BOOL)numberField {
    if (self.currentTextField == self.spadesExerciseTextField || self.currentTextField == self.heartsExerciseTextField || self.currentTextField == self.clubsExerciseTextField || self.currentTextField == self.diamondsExerciseTextField || self.currentTextField == self.acesExerciseTextField || self.currentTextField == self.jokersExerciseTextField) {
        return NO;
    } else {
        return YES;
    }
}

- (void)alert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

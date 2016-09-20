//
//  TextFieldTableViewCell.m
//  CardFit
//
//  Created by Braden Gray on 9/12/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextField *textField; //Textfield object
@property (weak, nonatomic) IBOutlet UILabel *label; //Label object
@property (nonatomic) BOOL cancelEntry; //Tells if keyboard was canceled

@end

@implementation TextFieldTableViewCell

#pragma mark - Initialization
//Set textfield delegate
- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}

#pragma mark - Set Values
//Set textfield text and keypad
- (void)textFieldText:(NSString *)text withNumberPad:(BOOL)numberPad {
    if (numberPad) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.inputAccessoryView = [self numberToolBar];
    }
    self.textField.text = text;
}

//Set textfield tag
- (void)setTextFieldTag:(NSInteger)tag {
    self.textField.tag = tag;
}

//set label title
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];

    self.label.attributedText = [[NSAttributedString alloc] initWithString:titleText attributes:@{NSFontAttributeName : font}];
}


#pragma mark - Number Pad and Accessories

- (UIToolbar *)numberToolBar { //Adds accessory inputs for number pad "Apply" and "Cancel" buttons
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)cancelNumberPad { //Called if canceled his hit on number pad
    self.cancelEntry = YES; //No need to save settings
    [self.textField resignFirstResponder]; //Get rid of keyboard
}

-(void)doneWithNumberPad { //Called when "Apply" button is pressed on number pad
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField { //Get rid of keyboard when return is hit
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField { //Called when text field is selected
    self.cancelEntry = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField { //Called when text field is dismissed
        if (self.cancelEntry) { //If canceled reset textfield to original settings
            textField.text = nil;
            [self.delegate tableViewCell:self changedTextField:textField];
        } else { //If not save new settings entry
            [self.delegate tableViewCell:self changedTextField:textField];
        }
}

//Only allow capital letters
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}

@end

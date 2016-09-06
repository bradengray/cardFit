//
//  GameSettingsDetailTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "GameSettingsDetailTVC.h"

@interface GameSettingsDetailTVC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *currentTextField; //Tracks current selected text field
@property (nonatomic) BOOL cancelEntry; //Tracks whether entry was canceled
@property (nonatomic, strong) Settings *settings; //Settings object

@end

@implementation GameSettingsDetailTVC

#pragma mark - View LifeCycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    self.settings = [self createSettings]; //Create settings
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor]; //Set table view background color
}

- (void)viewDidAppear:(BOOL)animated { //Called When View Appears
    [super viewDidAppear:animated];
    //Select First Cell in table view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)setSettingsCell:(SettingsCell *)settingsCell {
    _settingsCell = settingsCell;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //Number of sections in table view
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { //Set footer for section
    //Create footer view
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    if (self.settingsCell.footerInstrucions) {
        //Create label for view
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.bounds.size.width - 15, 0)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.backgroundColor = [UIColor clearColor];
        //Set text for footer
        NSString *string = self.settingsCell.footerInstrucions;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : font};
        label.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
        
        //Add label to footer
        [footer addSubview:label];
    }
    return footer;

}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { //Return Height for footer
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //Number of rows in section of tableview
    return [self.settingsCell.detailSettingsCells count];
}

//Constraints for textfield cells
#define TRAILING_SPACE 25.0
#define CELL_WIDTH 600.0
#define CELL_HEIGHT 44.0
#define VOFFSET 1.0

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //Creates cell for row
    static NSString *cellIdentifier;
    UITableViewCell *cell;

    SettingsCell *detailSettingsCell = [self.settingsCell.detailSettingsCells objectAtIndex:indexPath.row];
//    NSString *rowValue = [self.settingsDetailDictionary objectForKey:rowName];
    
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    //Create cell with a text field
    cellIdentifier = @"Cell1";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITextField *textField;
    //Make sure reused cell does not already have textfield
    for (id object in cell.contentView.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            textField = object;
        }
    }
    //Setup Textfield
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:detailSettingsCell.title attributes:@{NSFontAttributeName : font}];
    if (!textField) {
        CGRect frame = CGRectMake (cell.textLabel.attributedText.size.width + TRAILING_SPACE, VOFFSET, CELL_WIDTH - (cell.textLabel.attributedText.size.width + TRAILING_SPACE), CELL_HEIGHT);
        textField = [[UITextField alloc] initWithFrame:frame];
        [cell.contentView addSubview:textField];
        textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //If cell contatins number then set keyboard to number pad and add accessory buttons
    if (detailSettingsCell.cellBool) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.inputAccessoryView = [self numberToolBar];
    }
    textField.text = detailSettingsCell.value;
    textField.tag = indexPath.row;
    textField.delegate = self;
    
    return cell;
}

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
    [self.currentTextField resignFirstResponder]; //Get rid of keyboard
     self.currentTextField = nil; //Set text field to nil
}

-(void)doneWithNumberPad { //Called when "Apply" button is pressed on number pad
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { //Called when cell is selected
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //Get the textfield from the cell and make it first responder
    for (id object in cell.contentView.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)object;
            [textField becomeFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField { //Get rid of keyboard when return is hit
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField { //Called when text field is selected
    self.currentTextField = textField;
    self.cancelEntry = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField { //Called when text field is dismissed
    if (self.cancelEntry) { //If canceled reset textfield to original settings
        textField.text = [self.settingsCell.detailSettingsCells objectAtIndex:textField.tag];
    } else { //If not save new settings entry
        [self saveUserInputForTextField:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}

#pragma mark - Alerts 

//Constraints for alert messages
#define MINIMUM_STRING_LENGTH 15
#define MAX_NUMBER_VALUE 1000

- (void)saveUserInputForTextField:(UITextField *)textField { //Called when New settings should be saved
    //Get the dictionary key
    SettingsCell *detailSettingsCell = [self.settingsCell.detailSettingsCells objectAtIndex:textField.tag];
    //Make sure entry is valid and check for alerts
    NSString *alertString = [self.settings alertLabelForString:textField.text forKey:detailSettingsCell.title];
    //If alert message then sent alert and reset text field to orignal settings
    if (alertString) {
        [self alert:alertString];
        textField.text = detailSettingsCell.value;
    } else { //If not alert then save new settings by calling delegate
        self.settingsCell = [self.settingsCell setDetailSettingsValue:textField.text forIndex:textField.tag];
//        [self.delegate settingsChanged:self.settingsCell];
        [self.settings storeNewSettings:self.settingsCell];
    }
}

- (void)alert:(NSString *)msg { //Called when alert message is needed
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

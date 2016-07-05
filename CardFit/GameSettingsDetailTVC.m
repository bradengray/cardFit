//
//  GameSettingsDetailTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "GameSettingsDetailTVC.h"
#import "SettingsChangedNotification.h"

@interface GameSettingsDetailTVC () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic) BOOL cancelEntry;
@property (nonatomic, strong) Settings *settings;

@end

@implementation GameSettingsDetailTVC

#pragma mark - View LifeCycle

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserverForName:SettingsChangedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      self.settingsDetailDictionary = note.userInfo[SettingsChanged];
                                                  }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:SettingsChangedNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [self createSettings];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *string in self.settings.values) {
        if ([[_settingsDetailDictionary allKeys] containsObject:string]) {
            [array addObject:string];
        }
    }
    self.rows = array;
}

- (void)setSettingsDetailDictionary:(NSDictionary *)settingsDetailDictionary {
    _settingsDetailDictionary = settingsDetailDictionary;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rows count];
}

#define TRAILING_SPACE 25.0
#define CELL_WIDTH 600.0
#define CELL_HEIGHT 44.0
#define VOFFSET 1.0

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier;
    UITableViewCell *cell;

    NSString *rowName = [self.rows objectAtIndex:indexPath.row];
    NSString *rowValue = [self.settingsDetailDictionary objectForKey:rowName];
    
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    cellIdentifier = @"Cell1";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITextField *textField;
    for (id object in cell.contentView.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            textField = object;
        }
    }
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", rowName] attributes:@{NSFontAttributeName : font}];
    if (!textField) {
        CGRect frame = CGRectMake (cell.textLabel.attributedText.size.width + TRAILING_SPACE, VOFFSET, CELL_WIDTH - (cell.textLabel.attributedText.size.width + TRAILING_SPACE), CELL_HEIGHT);
        textField = [[UITextField alloc] initWithFrame:frame];
        [cell.contentView addSubview:textField];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.settings.numbers containsObject:rowName]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.inputAccessoryView = [self numberToolBar];
    }
    textField.text = rowValue;
    textField.tag = indexPath.row;
    textField.delegate = self;
    if ([rowName isEqualToString:CARD_LABEL]) {
        textField.enabled = NO;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
        
    return cell;
}

- (void)switchChanged:(UISwitch *)switchView {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.settingsDetailDictionary];
    [dictionary setObject:[NSNumber numberWithBool:switchView.on] forKey:CELL_BOOL_KEY];
    [self.delegate settingsChanged:dictionary];
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
    self.cancelEntry = YES;
    [self.currentTextField resignFirstResponder];
     self.currentTextField = nil;
}

-(void)doneWithNumberPad {
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    for (id object in cell.contentView.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)object;
            [textField becomeFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    self.cancelEntry = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *key = [self.rows objectAtIndex:textField.tag];
    if (self.cancelEntry) {
        textField.text = [self.settingsDetailDictionary objectForKey:key];
    } else {
        [self saveUserInputForTextField:textField];
    }
}

#pragma mark - Alerts 

#define MINIMUM_STRING_LENGTH 15
#define MAX_NUMBER_VALUE 1000

- (void)saveUserInputForTextField:(UITextField *)textField {
    
    NSString *key = [self.rows objectAtIndex:textField.tag];
    
    NSString *value = [self.settings alertLabelForString:textField.text forKey:key];
    
    if (value) {
        [self alert:value];
        textField.text = [self.settingsDetailDictionary objectForKey:key];
    } else {
        NSMutableDictionary *dictionary = [self.settingsDetailDictionary mutableCopy];
        [dictionary setObject:textField.text forKey:key];
        [self.delegate settingsChanged:dictionary];
    }
}

- (void)alert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

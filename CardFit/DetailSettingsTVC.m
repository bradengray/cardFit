//
//  GameSettingsDetailTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DetailSettingsTVC.h"
#import "TextFieldTableViewCell.h"

@interface DetailSettingsTVC () <UITextFieldDelegate>

@property (nonatomic, strong) SettingsDataController *dataSource; //Stores data source

@end

@implementation DetailSettingsTVC

#pragma mark - View LifeCycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor]; //Set table view background color
    self.tableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:AlertPosted
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self alert:[note.userInfo objectForKey:AlertPosted]];
                                                  }];
}

- (void)viewDidAppear:(BOOL)animated { //Called When View Appears
    [super viewDidAppear:animated];
    //Select First Cell in table view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath { //Sets selected index path
    _selectedIndexPath = selectedIndexPath;
    self.dataSource = [self createDataSource];
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { //Set footer for section
    UIView *footer;
    if (section == [self.dataSource.dataSectionTitles count] - 1) {
        //Create footer view
        footer = [[UIView alloc] initWithFrame:CGRectZero];
        footer.backgroundColor = [UIColor clearColor];
        //Create label for view
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.bounds.size.width - 15, 0)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.backgroundColor = [UIColor clearColor];
        //Set text for footer
        NSString *string = [self.dataSource textForFooterInSection:section];
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

#pragma mark - Alerts

- (void)alert:(NSString *)msg { //Called when alert message is needed
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark Abstract Methods

- (SettingsDataController *)createDataSource { //Abstract
    return nil;
}

@end

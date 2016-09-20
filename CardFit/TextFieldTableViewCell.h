//
//  TextFieldTableViewCell.h
//  CardFit
//
//  Created by Braden Gray on 9/12/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldTableViewCellDelegate <NSObject>

@required
//Tells delegate textfield changed values
- (void)tableViewCell:(UITableViewCell *)cell changedTextField:(UITextField *)textField;

@end

@interface TextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, assign) id<TextFieldTableViewCellDelegate>delegate; //Sets delegate

@property (nonatomic, strong) NSString *titleText; //Holds text value for label

- (void)textFieldText:(NSString *)text withNumberPad:(BOOL)numberPad; //Sets the text and keyboard for the textField
- (void)setTextFieldTag:(NSInteger)tag; //Sets the tag for the textfield

@end

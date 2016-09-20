//
//  DetailSettingsDataController.h
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsDataController.h"
#import "TextFieldTableViewCell.h"

@interface DetailSettingsController : SettingsDataController <TextFieldTableViewCellDelegate>

//Required For Data
//Data is created for this object when the selected indexPath is set
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

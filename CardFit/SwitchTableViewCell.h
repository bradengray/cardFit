//
//  SwitchTableViewCell.h
//  CardFit
//
//  Created by Braden Gray on 9/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchTableViewCellDelegate <NSObject>

@required
- (void)switchChangedValue:(BOOL)value; //Tells delegate that switch value changed

@end

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SwitchTableViewCellDelegate>delegate; //sets delegate

- (void)setSwitchValue:(BOOL)on; //Sets switch value

@end

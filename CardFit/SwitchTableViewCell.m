//
//  SwitchTableViewCell.m
//  CardFit
//
//  Created by Braden Gray on 9/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch; //Switch object

@end

@implementation SwitchTableViewCell

//Called when switch touchec
- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (self.delegate) {
        [self.delegate switchChangedValue:sender.on];
    }
}

#pragma mark - Abstract Methods

//Sets switch value
- (void)setSwitchValue:(BOOL)on { //Abstract
    self.mySwitch.on = on;
}


@end

//
//  GameSettingsDetailTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsTVC.h"
#import "SettingsCell.h"

//@protocol GameSettingsDelegate <NSObject>

//@required
//- (void)settingsChanged:(SettingsCell *)settingsCell; //Called by delegate when settings are changed
//
//@end

@interface GameSettingsDetailTVC : SettingsTVC

//@property (nonatomic, weak) id<GameSettingsDelegate> delegate; //Sets delegate

//Required for detailed settings. The cellBool is used to determine the keyboard that should be used. A value of Yes will return a numberpad. Also uses title and settingsDetailCells.
@property (nonatomic, strong) SettingsCell *settingsCell;

@end

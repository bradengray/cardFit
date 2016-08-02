//
//  GameSettingsDetailTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsTVC.h"
#import "SettingsCell.h"

@protocol GameSettingsDelegate <NSObject>

@required
- (void)settingsChanged:(SettingsCell *)settingsCell; //Called by delegate when settings are changed

@end

@interface GameSettingsDetailTVC : SettingsTVC

@property (nonatomic, weak) id<GameSettingsDelegate> delegate; //Sets delegate
@property (nonatomic, strong) SettingsCell *settingsCell;
//@property (nonatomic, strong) NSDictionary *settingsDetailDictionary; //Settings dictionary

@end

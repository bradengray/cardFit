//
//  GameSettingsDetailTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsTVC.h"

@protocol GameSettingsDelegate <NSObject>

@required
- (void)settingsChanged:(NSDictionary *)dictionary;

@end

@interface GameSettingsDetailTVC : SettingsTVC

@property (nonatomic, weak) id<GameSettingsDelegate> delegate;
@property (nonatomic, strong) NSDictionary *settingsDetailDictionary;

@end

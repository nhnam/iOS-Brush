//
//  SettingsViewController.h
//  Brush
//
//  Created by Jeff Merola on 10/21/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *musicSetting;
@property (weak, nonatomic) IBOutlet UISwitch *soundEffectsSetting;
@property (weak, nonatomic) IBOutlet UISwitch *gameCenterSetting;

@end

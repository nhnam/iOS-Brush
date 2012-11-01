//
//  SettingsViewController.m
//  Brush
//
//  Created by Jeff Merola on 10/21/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Controller for the settings popover screen

#import "SettingsViewController.h"
#import "SimpleAudioEngine.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize musicSetting = _musicSetting;
@synthesize soundEffectsSetting = _soundEffectsSetting;
@synthesize gameCenterSetting = _gameCenterSetting;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// On dismissal of the settings popover, this is called.
// Save the individual settings to NSUserDefaults
- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL musicBool = [self.musicSetting isOn];
    BOOL soundEffectsBool = [self.soundEffectsSetting isOn];
    BOOL gameCenterBool = [self.gameCenterSetting isOn];
    
    int music, soundEffects, gameCenter = 0;
    
    if (musicBool) {
        music = 1;
        [defaults setInteger:music forKey:@"musicSetting"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
    } else {
        music = 0;
        [defaults setInteger:music forKey:@"musicSetting"];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    
    if (soundEffectsBool) {
        soundEffects = 1;
        [defaults setInteger:soundEffects forKey:@"soundEffectSetting"];
    } else {
        soundEffects = 0;
        [defaults setInteger:soundEffects forKey:@"soundEffectSetting"];
    }
    
    if (gameCenterBool) {
        gameCenter = 1;
        [defaults setInteger:gameCenter forKey:@"gameCenterSetting"];
    } else {
        gameCenter = 0;
        [defaults setInteger:gameCenter forKey:@"gameCenterSetting"];
    }
    
    [defaults synchronize];
}

// When the settings popover is going to appear,
//  retrieve the user's preferences and set the
//   settings switches to the correct position.
- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int music = [defaults integerForKey:@"musicSetting"];
    int soundEffects = [defaults integerForKey:@"soundEffectSetting"];
    int gameCenter = [defaults integerForKey:@"gameCenterSetting"];
    
    if (music == 1) {
        self.musicSetting.on = YES;
    } else {
        self.musicSetting.on = NO;
    }
    
    if (soundEffects == 1) {
        self.soundEffectsSetting.on = YES;
    } else {
        self.soundEffectsSetting.on = NO;
    }
    
    if (gameCenter == 1) {
        self.gameCenterSetting.on = YES;
    } else {
        self.gameCenterSetting.on = NO;
    }
}

@end

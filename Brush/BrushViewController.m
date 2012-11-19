//
//  BrushViewController.m
//  Brush
//
//  Created by Jeff Merola on 10/19/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

//Controller for the Main Menu

#import "BrushViewController.h"
#import "SceneManager.h"
#import "SimpleAudioEngine.h"

@interface BrushViewController ()

@end

@implementation BrushViewController

// When the app is opened and the initial screen (Main Menu)
//  loads, this method is called.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Begin background music if it is turned on.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"musicSetting"]) [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Happy.caf" loop:YES];
    
    if ([defaults integerForKey:@"soundEffectsSetting"]) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"level-complete.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"brush1.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"brush2.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"button-back.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"button-forward.caf"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

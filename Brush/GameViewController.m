//
//  LevelSelectViewController.m
//  Brush
//
//  Created by Jeff Merola on 10/23/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "GameViewController.h"
#import "ChapterSelect.h"
#import "SceneManager.h"
#import "SimpleAudioEngine.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize cocosView = _cocosView;

- (void)viewDidLoad
{
    [CCGLView class];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int soundEffects = [defaults integerForKey:@"soundEffectSetting"];
    if (soundEffects) [[SimpleAudioEngine sharedEngine] playEffect:@"button-forward.caf"];
    
    // Initialize cocos2d director
    CCDirector *director = [CCDirector sharedDirector];
    director.wantsFullScreenLayout = NO;
    director.projection = kCCDirectorProjection2D;
    director.animationInterval = 1.0 / 60.0;
    director.displayStats = YES;
    [director enableRetinaDisplay:YES];
    director.view = self.cocosView;
    [SceneManager goChapterSelect];
    [director startAnimation];
}

@end

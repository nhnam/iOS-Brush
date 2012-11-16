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

// When a segue is about to occur, this method is called.
// Based on which segue is going to happen, do different things.
// On the level selection segue: retreive the CCDirector and link
//   it to the CCGLView, and then begin animation.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Level Selection Screen Segue"]) {
        //start up cocos2d
        CCDirectorIOS *director = (CCDirectorIOS *)[CCDirector sharedDirector];
        if (director.runningScene == nil) {
            NSArray *array = [(UIViewController *)segue.destinationViewController view].subviews;
            for (int i = 0; i < array.count; i++) {
                UIView *subview = [array objectAtIndex:i];
                if ([subview isKindOfClass:[CCGLView class]]) {
                    director.view = (CCGLView *)subview;
                    break;
                }
            }
            [SceneManager goChapterSelect];
        }
        [director startAnimation];
    } else if ([segue.identifier isEqualToString:@"Settings Screen Segue"]) {
        
    }
}

// When the app is opened and the initial screen (Main Menu)
//  loads, this method is called.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Begin background music if it is turned on.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"musicSetting"]) [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

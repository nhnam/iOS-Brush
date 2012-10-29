//
//  BrushViewController.m
//  temp
//
//  Created by Jeff Merola on 10/19/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "BrushViewController.h"
#import "HelloWorldLayer.h"

@interface BrushViewController ()

@end

@implementation BrushViewController

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
            [director runWithScene:[HelloWorldLayer scene]];
        }
        [director startAnimation];
    } else if ([segue.identifier isEqualToString:@"Settings Screen Segue"]) {
        //obtain settings values from NSUserDefaults
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

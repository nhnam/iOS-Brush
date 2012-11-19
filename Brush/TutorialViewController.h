//
//  TutorialViewController.h
//  Brush
//
//  Created by Jeff Merola on 10/20/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)returnToMainMenu:(UIButton *)sender;

@end




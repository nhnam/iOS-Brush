//
//  LevelSelectViewController.h
//  Brush
//
//  Created by Jeff Merola on 10/23/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelectViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)returnToMainMenu:(UIButton *)sender;

@end

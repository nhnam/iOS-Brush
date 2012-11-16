//
//  BrushData.h
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface BrushData : NSObject {}

@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;
   
-(id)initWithSelectedChapter:(int)selectedChapter
               SelectedLevel:(int)selectedLevel;

@end

//
//  BrushData.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Class to hold chapter and level selection for use
//  in specific chapter and level code.

#import "BrushData.h"

@implementation BrushData  

@synthesize selectedChapter = _selectedChapter;
@synthesize selectedLevel = _selectedLevel;

- (id)initWithSelectedChapter:(int)selectedChapter
                SelectedLevel:(int)selectedLevel
{
    if ((self = [super init])) {
        self.selectedChapter = selectedChapter;
        self.selectedLevel = selectedLevel; 
    }
    return self;
}

@end
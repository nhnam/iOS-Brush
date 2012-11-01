//
//  LevelParser.h
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Levels;

@interface LevelParser : NSObject {}

+ (Levels *)loadLevelsForChapter:(int)chapter;
+ (void)saveData:(Levels *)saveData ForChapter:(int)chapter;

@end
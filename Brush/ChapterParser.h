//
//  ChapterParser.h
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Chapters;

@interface ChapterParser : NSObject {}

+ (Chapters *)loadData;

@end
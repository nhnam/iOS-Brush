//
//  Chapters.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Class to hold the list of all chapters

#import "Chapters.h"

@implementation Chapters

@synthesize chapters = _chapters;

-(id)init
{
    if ((self = [super init])) {
		self.chapters = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
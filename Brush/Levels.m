//
//  Levels.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Class to hold all of the levels.

#import "Levels.h"

@implementation Levels

@synthesize levels = _levels;

-(id)init
{
    if ((self = [super init])) {
		self.levels = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
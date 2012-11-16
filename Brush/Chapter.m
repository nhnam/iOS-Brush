//
//  Chapter.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Class to hold the needed data for each individual chapter

#import "Chapter.h"

@implementation Chapter

@synthesize name = _name;
@synthesize number = _number;

-(id)initWithName:(NSString *)name Number:(int)number 
{
    if ((self = [super init])) {
		self.name = name;
		self.number = number;
    }
    return self;
}

@end
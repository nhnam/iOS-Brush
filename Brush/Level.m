//
//  Level.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Class for each individual level.
// Holds the name, number, unlocked status,
//  number of stars earned, and the level
//   data.

#import "Level.h"

@implementation Level

@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;
@synthesize data = _data;
@synthesize three = _three;
@synthesize two = _two;

-(id)initWithName:(NSString *)name
           Number:(int)number
         Unlocked:(BOOL)unlocked
            Stars:(int)stars
             Data:(NSString *)data
            Three:(int)three
              Two:(int)two
{
    if ((self = [super init])) {
        self.name = name;
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        self.data = data;
        self.three = three;
        self.two = two;
    }
    return self;
}

@end
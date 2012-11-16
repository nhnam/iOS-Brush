//
//  Level.h
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;
@property (nonatomic, copy) NSString *data;
   
-(id)initWithName:(NSString *)name
           Number:(int)number
         Unlocked:(BOOL)unlocked
            Stars:(int)stars
             Data:(NSString *)data;
@end

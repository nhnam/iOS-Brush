//
//  Chapter.h
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject {}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
   
-(id)initWithName:(NSString *)name Number:(int)number;

@end

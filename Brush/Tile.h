//
//  Tile.h
//  Brush
//
//  Created by Jeff Merola on 11/16/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tile : NSObject

// Properties for an individual tile
//  Each has an x and y coordinate, a current and required color, and a sprite to display its image
@property (nonatomic, readonly) int x;
@property (nonatomic, readonly) int y;
@property (nonatomic) float size;
@property (nonatomic) int currentColor;  // 0 is default, 1 is blue, 2 is red, 3 is green
@property (nonatomic, readonly) int requiredColor;
@property (nonatomic, strong) CCSprite *sprite;

- (id)initWithX:(int)posX Y:(int)posY Color:(int)color;
- (BOOL)nearTile:(Tile *)otherTile;
- (void)changeColor;
- (CGPoint)pixPostion;
@end

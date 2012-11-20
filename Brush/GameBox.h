//
//  GameBox.h
//  Brush
//
//  Created by Jeff Merola on 11/16/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Tile.h"

@interface GameBox : NSObject

// Game board has a size, has an array to handle the tiles, a set to handle removing tiles,
//  a CCLayer, and an error tile
@property (nonatomic, readonly) CGSize size;
@property (nonatomic) NSMutableArray *content;
@property (nonatomic) NSMutableSet *readyToRemoveTiles;
@property (nonatomic, strong) CCLayer *layer;
@property (nonatomic) Tile *OutOfBoundsTile;

- (id)initWithSize:(CGSize)size Colors:(NSString *)colors;
- (Tile *)tileAtX:(int)posX Y:(int)posY;
- (BOOL)check;

@end

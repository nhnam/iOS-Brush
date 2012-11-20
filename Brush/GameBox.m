//
//  GameBox.m
//  Brush
//
//  Created by Jeff Merola on 11/16/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "GameBox.h"
#import "Constants.h"

@implementation GameBox
@synthesize size = _size;
@synthesize content = _content;
@synthesize readyToRemoveTiles = _readyToRemoveTiles;
@synthesize layer = _layer;
@synthesize OutOfBoundsTile = _OutOfBoundsTile;

// Initializes the game board with the given size and level data (colors)
- (id)initWithSize:(CGSize)size Colors:(NSString *)colors
{
    self = [super init];
    _size = size;
    self.OutOfBoundsTile = [[Tile alloc] initWithX:-1 Y:-1 Color:-1];
    self.content = [NSMutableArray arrayWithCapacity:self.size.height];
    self.readyToRemoveTiles = [NSMutableSet setWithCapacity:50];
    
    // Creates the tiles with the correct required colors
    for (int y = 0; y < self.size.height; y++) {
        NSMutableArray *rowContent = [NSMutableArray arrayWithCapacity:self.size.width];
        for (int x = 0; x < self.size.width; x++) {
            Tile *tile = [[Tile alloc] initWithX:x Y:y Color:[[colors substringWithRange:NSMakeRange((x+y*self.size.width), 1)] intValue]];
            switch ((int)self.size.width) {
                case 5:
                    tile.size = kTileSize5x5;
                    break;
                case 6:
                    tile.size = kTileSize6x6;
                    break;
                case 7:
                    tile.size= kTileSize7x7;
                    break;
                case 8:
                    tile.size = kTileSize8x8;
                    break;
                case 9:
                    tile.size = kTileSize9x9;
                    break;
                default:
                    tile.size = kTileSize5x5;
                    break;
            }
            [rowContent addObject:tile];
            [self.readyToRemoveTiles addObject:tile];
        }
        [self.content addObject:rowContent];
    }
    return self;
}

// Returns the tiles at the given x-y position
- (Tile *)tileAtX:(int)posX Y:(int)posY
{
    if (posX < 0 || posX > self.size.width || posY < 0 || posY > self.size.height) {
        return self.OutOfBoundsTile;
    } else {
        return [[self.content objectAtIndex:posY] objectAtIndex:posX];
    }
}

// Checks for tiles that are no longer needed and removes them
//  Then sets up the new sprites for the game board
- (BOOL)check
{
    // If no tiles are ready to be removed, just return
    NSArray *objects = [[self.readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	
    // Remove the unneccessary tiles
	int countTile = [objects count];
	for (int i = 0; i < countTile; i++) {
		Tile *tile = [objects objectAtIndex:i];
		tile.currentColor = 0;
		if (tile.sprite) {
			[self.layer removeChild:tile.sprite cleanup:YES];
		}
	}
    
	[self.readyToRemoveTiles removeAllObjects];
    
    // Set up new sprites for tiles
    for (int y = 0; y < self.size.height; y++) {
        for (int x = 0; x < self.size.width; x++) {
            Tile *tile = [self tileAtX:x Y:y];
            CCSprite *tileSprite;
            if (tile.requiredColor == 1) {
                tileSprite = [CCSprite spriteWithFile:@"grey-blue-iPad.png"];
            } else if (tile.requiredColor == 2) {
                tileSprite = [CCSprite spriteWithFile:@"grey-red-iPad.png"];
            } else if (tile.requiredColor == 3) {
                tileSprite = [CCSprite spriteWithFile:@"grey-green-iPad.png"];
            } else if (tile.requiredColor == 9) {
                tileSprite = [CCSprite spriteWithFile:@"grey-x-iPad.png"];
            }
            
            tile.sprite = tileSprite;
            [self.layer addChild:tileSprite];
        }
    }
    
	return YES;
}

@end

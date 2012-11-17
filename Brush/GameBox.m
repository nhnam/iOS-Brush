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
@synthesize first = _first;
@synthesize second = _second;
@synthesize size = _size;
@synthesize content = _content;
@synthesize readyToRemoveTiles = _readyToRemoveTiles;
@synthesize lock = _lock;
@synthesize layer = _layer;
@synthesize OutOfBoundsTile = _OutOfBoundsTile;
@synthesize imgValue = _imgValue;

- (id)initWithSize:(CGSize)size Colors:(NSString *)colors
{
    self = [super init];
    _size = size;
    self.OutOfBoundsTile = [[Tile alloc] initWithX:-1 Y:-1 Color:-1];
    self.content = [NSMutableArray arrayWithCapacity:self.size.height];
    self.readyToRemoveTiles = [NSMutableSet setWithCapacity:50];
    
    for (int y = 0; y < self.size.height; y++) {
        NSMutableArray *rowContent = [NSMutableArray arrayWithCapacity:self.size.width];
        for (int x = 0; x < self.size.width; x++) {
            Tile *tile = [[Tile alloc] initWithX:x Y:y Color:[[colors substringWithRange:NSMakeRange(x+x*y, 1)] intValue]];
            [rowContent addObject:tile];
            [self.readyToRemoveTiles addObject:tile];
        }
        [self.content addObject:rowContent];
    }
    return self;
}

- (Tile *)tileAtX:(int)posX Y:(int)posY
{
    if (posX < 0 || posX > self.size.width || posY < 0 || posY > self.size.height) {
        return self.OutOfBoundsTile;
    } else {
        return [[self.content objectAtIndex:posY] objectAtIndex:posX];
    }
}

- (BOOL)check
{
    NSArray *objects = [[self.readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	
	int countTile = [objects count];
	for (int i = 0; i < countTile; i++) {
		Tile *tile = [objects objectAtIndex:i];
		tile.currentColor = 0;
		if (tile.sprite) {
			[self.layer removeChild:tile.sprite cleanup:YES];
		}
	}
    
	[self.readyToRemoveTiles removeAllObjects];
    
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
            } else {
                tileSprite = [CCSprite spriteWithFile:@"grey-x-iPad.png"];
            }
            
            tile.sprite = tileSprite;
            [self.layer addChild:tileSprite];
        }
    }
    
	return YES;
}

@end

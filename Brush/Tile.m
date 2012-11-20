//
//  Tile.m
//  Brush
//
//  Created by Jeff Merola on 11/16/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "Tile.h"
#import "Constants.h"

// Hidden helper method
@interface Tile()
- (void)updateTile;
@end

@implementation Tile

@synthesize x = _x;
@synthesize y = _y;
@synthesize size = _size;
@synthesize currentColor = _currentColor;
@synthesize requiredColor = _requiredColor;
@synthesize sprite = _sprite;

// Initializer for a tile
//  Sets the tiles position and required color
- (id)initWithX:(int)posX Y:(int)posY Color:(int)color
{
    self = [super init];
    _x = posX;
    _y = posY;
    _requiredColor = color;
    self.size = kTileSize5x5;
    if (self.requiredColor == 9) {
        self.currentColor = 9;
    }
    return self;
}

// Sets the tile's sprite
- (void)setSprite:(CCSprite *)sprite
{
    _sprite = sprite;                       /////// SET SCALE TO MATCH TILE SIZE
    _sprite.scaleX = self.size / _sprite.contentSize.width;
    _sprite.scaleY = self.size / _sprite.contentSize.height;
    _sprite.position = [self pixPostion];
}

// Checks if the tile (self) is adjacent to the given tile (otherTile)
- (BOOL)nearTile:(Tile *)otherTile
{
    return (self.x == otherTile.x && abs(self.y - otherTile.y) == 1) || (self.y == otherTile.y && abs(self.x - otherTile.x) == 1);
}

// Changes the tiles current color
// 0 is default, 1 is blue, 2 is red, 3 is green, 9 is X
- (void)changeColor
{
    self.currentColor = self.currentColor + 1;
    if (self.currentColor == 4) {
        self.currentColor = 1;
    }
    [self updateTile];
}

// Updates the tile's sprite's image based on the current and required colors
- (void)updateTile
{
    if (self.currentColor == 1 && self.requiredColor == 1) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"blue-blue-iPad.png"] texture]];
    } else if (self.currentColor == 1 && self.requiredColor == 2) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"blue-red-iPad.png"] texture]];
    } else if (self.currentColor == 1 && self.requiredColor == 3) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"blue-green-iPad.png"] texture]];
    } else if (self.currentColor == 2 && self.requiredColor == 1) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"red-blue-iPad.png"] texture]];
    } else if (self.currentColor == 2 && self.requiredColor == 2) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"red-red-iPad.png"] texture]];
    } else if (self.currentColor == 2 && self.requiredColor == 3) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"red-green-iPad.png"] texture]];
    } else if (self.currentColor == 3 && self.requiredColor == 1) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"green-blue-iPad.png"] texture]];
    } else if (self.currentColor == 3 && self.requiredColor == 2) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"green-red-iPad.png"] texture]];
    } else if (self.currentColor == 3 && self.requiredColor == 3) {
        [self.sprite setTexture:[[CCSprite spriteWithFile:@"green-green-iPad.png"] texture]];
    }
}

// Converts the tile's x-y position in the game grid to an x-y position on the screen using points
- (CGPoint)pixPostion
{
    return ccp(kStartX + self.x * self.size + self.size / 2.0f, kStartY + self.y * self.size + self.size / 2.0f);
}

@end

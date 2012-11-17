//
//  Tile.m
//  Brush
//
//  Created by Jeff Merola on 11/16/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "Tile.h"
#import "Constants.h"

@interface Tile()
- (void)updateTile;
@end

@implementation Tile

@synthesize x = _x;
@synthesize y = _y;
@synthesize currentColor = _currentColor;
@synthesize requiredColor = _requiredColor;
@synthesize sprite = _sprite;

- (id)initWithX:(int)posX Y:(int)posY Color:(int)color
{
    self = [super init];
    _x = posX;
    _y = posY;
    _requiredColor = color;
    return self;
}

- (void)setSprite:(CCSprite *)sprite
{
    _sprite = sprite;
    _sprite.position = [self pixPostion];
}

- (BOOL)nearTile:(Tile *)otherTile
{
    return (self.x == otherTile.x && abs(self.y - otherTile.y) == 1) || (self.y == otherTile.y && abs(self.x - otherTile.x) == 1);
}

// 0 is default, 1 is blue, 2 is red, 3 is green
- (void)changeColor
{
    self.currentColor = self.currentColor + 1;
    if (self.currentColor == 4) {
        self.currentColor = 1;
    }
    [self updateTile];
}

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

- (CGPoint)pixPostion
{
    return ccp(kStartX + self.x * kTileSize + kTileSize / 2.0f, kStartY + self.y * kTileSize + kTileSize / 2.0f);
}

@end

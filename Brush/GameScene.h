//
//  GameScene.h
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
#import "GameBox.h"

@interface GameScene : CCLayer {}

// Properties for the game scene
// The box is the game board, currentTile is the tile the player is on,
//   the numberOfMoves is the total number of moves the player has made,
//   and the player is the sprite for the player avatar
@property (nonatomic, strong) GameBox *box;
@property (nonatomic, strong) Tile *currentTile;
@property (nonatomic) int numberOfMoves;
@property (nonatomic, strong) CCSprite *player;

- (void)moveToTile:(Tile *)tile;
- (BOOL)levelComplete;
@end

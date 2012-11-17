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

@property (nonatomic, strong) GameBox *box;
@property (nonatomic, strong) Tile *currentTile;
@property (nonatomic) int numberOfMoves;

- (void)moveToTile:(Tile *)tile;
- (BOOL)levelComplete;
@end

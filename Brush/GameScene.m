//
//  GameScene.m
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Game scene ( note: not yet finished )

#import "GameScene.h"
#import "BrushData.h"
#import "BrushDataParser.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"

@implementation GameScene  

@synthesize box = _box;
@synthesize currentTile = _currentTile;
@synthesize numberOfMoves = _numberOfMoves;
@synthesize player = _player;

- (void)onBack: (id) sender
{
    [SceneManager goLevelSelect];
}

- (void)addBackButton
{
    CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPad.png"
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
    goBack.scale = 0.75;
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];

    back.position = ccp(64, 64);
        
    [self addChild: back];
}

- (void)movePlayerToTile:(Tile *)tile
{
    //animations to move to tiles position
    float duration = 0.5;
    CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:[tile pixPostion]];
    [self.player runAction:move];
}

- (void)moveToTile:(Tile *)tile
{
    NSLog(@"moving to tile: %d, %d",tile.x, tile.y);
    [self movePlayerToTile:tile];
    [tile changeColor];
    self.currentTile = tile;
    if ([self levelComplete]) {
        //call win screen
    }
}

- (BOOL)levelComplete
{
    BOOL complete = YES;
    
    for (int y = 0; y < self.box.size.height; y++) {
        for (int x = 0; x < self.box.size.width; x++) {
            Tile *tile = [[self.box.content objectAtIndex:y] objectAtIndex:x];
            if (tile.currentColor != tile.requiredColor) {
                complete = NO;
            }
        }
    }
    
    return complete;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (self.currentTile.x == (location.x - kStartX)/kTileSize && self.currentTile.y == (location.y - kStartY)/kTileSize) {
        self.currentTile = nil;
        return;
    }
    
    int x = (location.x - kStartX)/kTileSize;
    int y = (location.y - kStartY)/kTileSize;
    
    Tile *tile = [self.box tileAtX:x Y:y];
    if (tile.x >= 0 && tile.y >= 0) {
        if ([self.currentTile nearTile:tile]) {
            [self.box setLock:YES];
            [self moveToTile:tile];
        }
    }
}

- (id)init {
    
    if( (self=[super init])) {        
        int gameBoardWidth = 0;
        int gameBoardHeight = 0;
        
        NSString *data;
        BrushData *brushData = [BrushDataParser loadData];
        
        int selectedChapter = brushData.selectedChapter;
        int selectedLevel = brushData.selectedLevel;
        
        Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        for (Level *level in levels.levels) {
            if (level.number == selectedLevel) {
                data = [NSString stringWithFormat:@"%@", level.data];
                if ([data length] == 25) {
                    gameBoardHeight = 5;
                    gameBoardWidth = 5;
                } else if ([data length] == 36) {
                    gameBoardHeight = 6;
                    gameBoardWidth = 6;
                } else if ([data length] == 49) {
                    gameBoardHeight = 7;
                    gameBoardWidth = 7;
                } else if ([data length] == 64) {
                    gameBoardHeight = 8;
                    gameBoardWidth = 8;
                } else if ([data length] == 81) {
                    gameBoardHeight = 9;
                    gameBoardWidth = 9;
                } else {
                    NSLog(@"ERROR: Incorrect level specifications!");
                }
                break;
            }
        }
        
        self.box = [[GameBox alloc] initWithSize:CGSizeMake(gameBoardWidth, gameBoardHeight) Colors:data];
        self.box.layer = self;
        self.box.lock = YES;
        [self.box check];
        
        self.currentTile = [self.box tileAtX:0 Y:0];
        self.player = [CCSprite spriteWithFile:@"Sprite-iPad-hd.png"];
        self.player.position = [self.currentTile pixPostion];
        [self.box.layer addChild:self.player z:4];
        
        self.numberOfMoves = 0;
        
        [self addBackButton];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

@end

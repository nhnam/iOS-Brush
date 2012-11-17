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

- (void)moveToTile:(Tile *)tile
{
    
}

- (BOOL)levelComplete
{
    return YES;
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
        
        [self addBackButton];
    }
    return self;
}

@end

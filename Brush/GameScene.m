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

- (void)addScoreLabel
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Moves: 0" fontName:@"Arial" fontSize:36];
    scoreLabel.position = CGPointMake(screenSize.width/2,screenSize.height);
    scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
    scoreLabel.color = ccc3(175, 207, 219);
    [self addChild:scoreLabel z:1 tag:10];
}

- (void)addInstructionsForLevel:(NSString *)data
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *sprite;
    
    if ([data rangeOfString:@"3"].location != NSNotFound) {
        sprite = [CCSprite spriteWithFile:@"instructions3-iPad.png"];
    } else if ([data rangeOfString:@"2"].location != NSNotFound) {
        sprite = [CCSprite spriteWithFile:@"instructions2-iPad.png"];
    } else {
        sprite = [CCSprite spriteWithFile:@"instructions1-iPad.png"];
    }
    
    sprite.position = CGPointMake(screenSize.width / 2, kStartY / 2);
    [self addChild:sprite z:1 tag:9];
}

- (int)calculateStarsForChapter:(int)selectedChapter Level:(int)selectedLevel Moves:(int)moves
{
    Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
    int maximumMovesForThreeStars = 0;
    int maximumMovesForTwoStars = 0;
    
    for (Level *level in levels.levels) {
        if (level.number == selectedLevel) {
            maximumMovesForThreeStars = level.three;
            maximumMovesForTwoStars = level.two;
            
            if (moves <= maximumMovesForThreeStars) {
                return 3;
            } else if (moves <= maximumMovesForTwoStars) {
                return 2;
            } else {
                return 1;
            }
        }
    }
    return 0;
}

- (void)returnToLevels
{
    
}

- (void)youWin
{
    NSLog(@"You win!");
    
    int chapter, level;
    BrushData *data = [BrushDataParser loadData];
    chapter = data.selectedChapter;
    level = data.selectedLevel;
    int stars = [self calculateStarsForChapter:chapter Level:level Moves:self.numberOfMoves];
    
    Levels *levels = [LevelParser loadLevelsForChapter:chapter];
    
    for (int i = 0; i < levels.levels.count; i++) {
        if ([[levels.levels objectAtIndex:i] number] == level) {
            [[levels.levels objectAtIndex:i] setStars:stars];
            break;
        }
    }
    
    for (int i = 0; i < levels.levels.count; i++) {
        if ([[levels.levels objectAtIndex:i] number] == level + 1) {
            [[levels.levels objectAtIndex:i] setUnlocked:YES]; 
            break;
        } else if (level == levels.levels.count) {
            Levels *nextChapterLevels = [LevelParser loadLevelsForChapter:chapter + 1];
            [[nextChapterLevels.levels objectAtIndex:0] setUnlocked:YES];
            [LevelParser saveData:nextChapterLevels ForChapter:chapter + 1];
            break;
        }
    }

    [LevelParser saveData:levels ForChapter:chapter];
    
    ccColor4B c = {100,100,0,100};
    WinScene *winScene = [[WinScene alloc] initWithColor:c Moves:self.numberOfMoves Stars:stars];
    [self.parent addChild:winScene z:10 tag:99];
}

- (void)animatePlayerToTile:(Tile *)tile
{
    //animations to move player to tiles position
    float duration = 0.5;
    CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:[tile pixPostion]];
    [self.player runAction:move];
}

- (void)moveToTile:(Tile *)tile
{
    if (tile.requiredColor == 1 || tile.requiredColor == 2 || tile.requiredColor == 3) {
        NSLog(@"moving to tile: %d, %d",tile.x, tile.y);
        [self animatePlayerToTile:tile];
        [tile changeColor];
        self.currentTile = tile;
        self.numberOfMoves++;
        CCLabelTTF *scoreLabel = (CCLabelTTF *)[self getChildByTag:10];
        [scoreLabel setString:[NSString stringWithFormat:@"Moves: %d",self.numberOfMoves]];
        if ([self levelComplete]) {
            self.isTouchEnabled = NO;
            [self youWin];
        }
    }
}

- (BOOL)levelComplete
{
    BOOL complete = YES;
    
    for (int y = 0; y < self.box.size.height; y++) {
        for (int x = 0; x < self.box.size.width; x++) {
            Tile *tile = [[self.box.content objectAtIndex:y] objectAtIndex:x];
            if (tile.currentColor != tile.requiredColor && tile.requiredColor != 9) {
                NSLog(@"%d,%d  %d,%d",x,y,tile.requiredColor, tile.currentColor);
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
        NSLog(@"Current Tile now nil.");
        self.currentTile = nil;
        return;
    }
    
    if (location.y < (kStartY) || location.y > (kStartY + (kTileSize * self.box.size.height))) {
        return;
    }
    
    if (location.x < (kStartX) || location.x > (kStartX + (kTileSize * self.box.size.width)))  {
        return;
    }
    
    int x = (location.x - kStartX)/kTileSize;
    int y = (location.y - kStartY)/kTileSize;

    Tile *tile = [self.box tileAtX:x Y:y];
    if (tile.x >= 0 && tile.y >= 0) {
        if ([self.currentTile nearTile:tile]) {
            [self moveToTile:tile];
        }
    }
}

- (id)init
{    
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
                    NSLog(@"Using default level...");
                    data = @"1111111111111111111111111";
                    gameBoardHeight = 5;
                    gameBoardWidth = 5;
                }
                break;
            }
        }
        
        self.box = [[GameBox alloc] initWithSize:CGSizeMake(gameBoardWidth, gameBoardHeight) Colors:data];
        self.box.layer = self;
        [self.box check];
        
        self.currentTile = [self.box tileAtX:0 Y:0];
        self.player = [CCSprite spriteWithFile:@"sprite-left-iPad.png"];
        self.player.position = [self.currentTile pixPostion];
        [[self.box tileAtX:0 Y:0] changeColor];
        [self.box.layer addChild:self.player z:4];
        
        self.numberOfMoves = 0;
        
        [self addBackButton];
        [self addScoreLabel];
        [self addInstructionsForLevel:data];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

@end

//
//  GameScene.m
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Game scene

#import "GameScene.h"
#import "BrushData.h"
#import "BrushDataParser.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "SimpleAudioEngine.h"

@implementation GameScene  

@synthesize box = _box;
@synthesize currentTile = _currentTile;
@synthesize numberOfMoves = _numberOfMoves;
@synthesize player = _player;

// On pressing the back arrow button, this method is called
// It plays a sound effect and then returns to the level selection screen
- (void)onBack: (id) sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int soundEffects = [defaults integerForKey:@"soundEffectSetting"];
    if (soundEffects) [[SimpleAudioEngine sharedEngine] playEffect:@"button-back.caf"];
    
    [SceneManager goLevelSelect];
}

// This method adds the back arrow button to the scene
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

// This method adds the score label to the scene
- (void)addScoreLabel
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // Create the label
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Moves: 0" fontName:@"Arial" fontSize:36];
    
    // Position the label and set it's color
    scoreLabel.position = CGPointMake(screenSize.width/2,screenSize.height);
    scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
    scoreLabel.color = ccc3(175, 207, 219);
    
    // Add the label
    [self addChild:scoreLabel z:1 tag:10];
}

// Adds the tile info image at the bottom of the game screen
- (void)addInstructionsForLevel:(NSString *)data
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *sprite = [CCSprite spriteWithFile:@"instructions-iPad.png"];
    
    // Position the image and add it
    sprite.position = CGPointMake(screenSize.width / 2, kStartY / 2);
    [self addChild:sprite z:1 tag:9];
}

// Calculates the number of stars that should be awarded for the given level based on the
//  number of moves the player has made
- (int)calculateStarsForChapter:(int)selectedChapter Level:(int)selectedLevel Moves:(int)moves
{
    // Read in the information for the star calculation from the XML file
    Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
    int maximumMovesForThreeStars = 0;
    int maximumMovesForTwoStars = 0;
    
    // Perform the calculation
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

// This method is called upon successful level completion
- (void)youWin
{
    NSLog(@"You win!");
    
    // Play the winning sound effect
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int soundEffects = [defaults integerForKey:@"soundEffectSetting"];
    if (soundEffects) [[SimpleAudioEngine sharedEngine] playEffect:@"level-complete.caf"];
    
    // Calculate the awarded stars for the current level
    int chapter, level;
    BrushData *data = [BrushDataParser loadData];
    chapter = data.selectedChapter;
    level = data.selectedLevel;
    int stars = [self calculateStarsForChapter:chapter Level:level Moves:self.numberOfMoves];
    
    Levels *levels = [LevelParser loadLevelsForChapter:chapter];
    
    // Update the stars data from the XML file
    for (int i = 0; i < levels.levels.count; i++) {
        if ([[levels.levels objectAtIndex:i] number] == level) {
            [[levels.levels objectAtIndex:i] setStars:stars];
            break;
        }
    }
    
    // Unlock the next level
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

    // Save the updated data
    [LevelParser saveData:levels ForChapter:chapter];
    
    // Create the win screen and overlay it over the game screen
    ccColor4B c = {180,180,180,100};
    WinScene *winScene = [[WinScene alloc] initWithColor:c Moves:self.numberOfMoves Stars:stars];
    [self.parent addChild:winScene z:10 tag:99];
}

// This method handles the animation of the player avatar
- (void)animatePlayerToTile:(Tile *)tile
{
    // Play the movement sound effect
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int soundEffects = [defaults integerForKey:@"soundEffectSetting"];
    if (soundEffects) {
        int x = arc4random() % 2;
        if (x == 0) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"brush1.caf"];
        } else if (x == 1) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"brush2.caf"];
        }
    }
    
    // Perform animations to move player to tiles position
    float duration = 0.5;
    CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:[tile pixPostion]];
    [self.player runAction:move];
}

// Performs all necessary actions to move to a new tile
//  - animates the player avatar to the new tile
//  - changes the tile's color
//  - updates the current tile and the number of moves
//  - checks if the level has been successfully completed
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

// Checks to see if the level has been successfully completed by comparing every
//  tile's required color to it's current color
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

- (float)getTileSize
{
    switch ((int)self.box.size.width) {
        case 5:
            return kTileSize5x5;
            break;
        case 6:
            return kTileSize6x6;
            break;
        case 7:
            return kTileSize7x7;
            break;
        case 8:
            return kTileSize8x8;
            break;
        case 9:
            return kTileSize9x9;
            break;
        default:
            return kTileSize5x5;
            break;
    }
}

// Cocos2d method for registering touches
// Used to perform actions based on the user's gestures
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    float tileSize = [self getTileSize];
    
    // If the user taps on the same tile, return so as to not crash
    if (self.currentTile.x == (location.x - kStartX)/tileSize && self.currentTile.y == (location.y - kStartY)/tileSize) {
        return;
    }
    
    // If the user taps outside of the game board, return so as to not crash
    if (location.y < (kStartY) || location.y > (kStartY + (tileSize * self.box.size.height))) {
        return;
    }
    
    // If the user taps outside of the game board, return so as to not crash
    if (location.x < (kStartX) || location.x > (kStartX + (tileSize * self.box.size.width)))  {
        return;
    }
    
    int x = (location.x - kStartX)/tileSize;
    int y = (location.y - kStartY)/tileSize;
    
    // If the user taps on an adjacent tile, move to that tile
    Tile *tile = [self.box tileAtX:x Y:y];
    if (tile.x >= 0 && tile.y >= 0) {
        if ([self.currentTile nearTile:tile]) {
            [self moveToTile:tile];
        }
    }
}

// Initializer for the game screen. Called by cocos2d when the screen is going to appear
- (id)init
{    
    if( (self=[super init])) {
        int gameBoardWidth = 0;
        int gameBoardHeight = 0;
        
        // Read in required game data
        NSString *data;
        BrushData *brushData = [BrushDataParser loadData];
        
        int selectedChapter = brushData.selectedChapter;
        int selectedLevel = brushData.selectedLevel;
        
        Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        // Set game board width and height based on level information
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
                    // If the level is not implemented correctly, use default level information
                    NSLog(@"ERROR: Incorrect level specifications!");
                    NSLog(@"Using default level...");
                    data = @"1111111111111111111111111";
                    gameBoardHeight = 5;
                    gameBoardWidth = 5;
                }
                break;
            }
        }
        
        // Create the game board
        self.box = [[GameBox alloc] initWithSize:CGSizeMake(gameBoardWidth, gameBoardHeight) Colors:data];
        self.box.layer = self;
        [self.box check];
        
        float tileSize = [self getTileSize];
        
        // Set the properties for the game screen (current tile, player, number of moves)
        self.currentTile = [self.box tileAtX:0 Y:0];
        self.player = [CCSprite spriteWithFile:@"sprite-left-iPad.png"];
        self.player.scaleX = tileSize / self.player.contentSize.width;
        self.player.scaleY = tileSize / self.player.contentSize.height;
        self.player.position = [self.currentTile pixPostion];
        [[self.box tileAtX:0 Y:0] changeColor];
        [self.box.layer addChild:self.player z:4];
        
        self.numberOfMoves = 0;
        
        // Add the back button, score label, and tile info image
        [self addBackButton];
        [self addScoreLabel];
        [self addInstructionsForLevel:data];
        
        // Allow touch recognition
        self.isTouchEnabled = YES;
    }
    return self;
}

@end

//
//  LevelSelect.m
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Level selection scene

#import "LevelSelect.h"
#import "Level.h"
#import "Levels.h"
#import "LevelParser.h"
#import "BrushData.h"
#import "BrushDataParser.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"

@implementation LevelSelect  

// Pressing the back button sends you back
//  to the chapter selection page.
- (void)onBack:(id)sender
{
    [SceneManager goChapterSelect];
}

// Adds the back button to the scene
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

// When a level is selected
- (void)onPlay:(CCMenuItemImage *)sender
{
    int selectedLevel = sender.tag;
    
    // Load the game information
    BrushData *brushData = [BrushDataParser loadData];
    brushData.selectedLevel = selectedLevel;
    [BrushDataParser saveData:brushData];
    
    // Go to the level scene
    [SceneManager goGameScene];
}

// Initialization for the level selection scene
- (id)init
{
    if((self=[super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        int smallFont = screenSize.height / 15;
        
        // Load the game data
        BrushData *brushData = [BrushDataParser loadData];
        int selectedChapter = brushData.selectedChapter;
        
        // Load the chapter data
        NSString *selectedChapterName = nil;
        Chapters *selectedChapters = [ChapterParser loadData];
        
        // Find the chapter name
        for (Chapter *chapter in selectedChapters.chapters) {
            if ([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter) {
                CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
                selectedChapterName = chapter.name;
            }
        }
        
        // Create a new menu
        CCMenu *levelMenu = [CCMenu menuWithItems: nil];
        NSMutableArray *overlay = [NSMutableArray new];
        
        // Load the correct levels from the selected chapter
        Levels *selectedLevels = [LevelParser loadLevelsForChapter:brushData.selectedChapter];
        
        // Do individual level initializations
        for (Level *level in selectedLevels.levels) {
            NSString *normal = [NSString stringWithFormat:@"%@-Normal-iPad.png", selectedChapterName];
            NSString *selected = [NSString stringWithFormat:@"%@-Selected-iPad.png", selectedChapterName];
            
            // Create the level image
            CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:normal selectedImage:selected target:self selector:@selector(onPlay:)];
            [item setTag:level.number];
            [item setIsEnabled:level.unlocked];
            [levelMenu addChild:item];
            
            // If the level is locked, overlay the lock, otherwise overlay the stars
            if (!level.unlocked) {
                NSString *overlayImage = [NSString stringWithFormat:@"Locked-iPad.png"];
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            } else {
                NSString *stars = [[NSNumber numberWithInt:level.stars] stringValue];
                NSString *overlayImage = [NSString stringWithFormat:@"%@Star-Normal-iPad.png", stars];
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }
        }
        
        // Align the levels in a 4x4 grid within the menu
        [levelMenu alignItemsInColumns:
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         nil];
        
        // Position the menu and add it to the scene
        CGPoint newPosition = levelMenu.position;
        newPosition.y = newPosition.y + (newPosition.y / 10);
        [levelMenu setPosition:newPosition];
        
        [self addChild:levelMenu z:-3];
        
        CCLayer *overlays = [[CCLayer alloc] init];
        CCLayer *labels = [[CCLayer alloc] init];
        
        // Position the overlays over the correct levels
        for (CCMenuItem *item in levelMenu.children) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", item.tag] fontName:@"Marker Felt" fontSize:smallFont];
            [label setAnchorPoint:item.anchorPoint];
            [label setPosition:item.position];
            [labels addChild:label];
            
            for (CCSprite *overlaySprite in overlay) {
                if (overlaySprite.tag == item.tag) {
                    [overlaySprite setAnchorPoint:item.anchorPoint];
                    [overlaySprite setPosition:item.position];
                    [overlays addChild:overlaySprite];
                }
            }
        }
        
        [overlays setAnchorPoint:levelMenu.anchorPoint];
        [labels setAnchorPoint:levelMenu.anchorPoint];
        [overlays setPosition:levelMenu.position];
        [labels setPosition:levelMenu.position];
        [self addChild:overlays];
        [self addChild:labels];
        
        [self addBackButton];
    }
    return self;
}

@end

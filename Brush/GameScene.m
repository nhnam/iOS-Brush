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

- (void)onBack: (id) sender
{
    [SceneManager goLevelSelect];
}

- (void)addBackButton
{
    CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"BackArrow.png"
                                                         selectedImage:@"BackArrow.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];

    back.position = ccp(64, 64);
        
    [self addChild: back];
}

- (id)init {
    
    if( (self=[super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        int fontSize = screenSize.height / 25;
        
        BrushData *brushData = [BrushDataParser loadData];
        
        int selectedChapter = brushData.selectedChapter;
        int selectedLevel = brushData.selectedLevel;
        
        Levels *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        for (Level *level in levels.levels) {
            if (level.number == selectedLevel) {
                NSString *data = [NSString stringWithFormat:@"%@", level.data];
                
                CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                       fontName:@"Marker Felt"
                                                       fontSize:fontSize];
                label.position = ccp( screenSize.width/2, screenSize.height/2);
                
                [self addChild:label z:0];
            }
        }
        [self addBackButton];
    }
    return self;
}

@end

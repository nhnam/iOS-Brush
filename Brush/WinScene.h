//
//  WinScene.h
//  Brush
//
//  Created by Jeff Merola on 11/17/12.
//  Copyright 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "SceneManager.h"

// Enumeration type used for tagging the different layers in the win screen
typedef enum
{
    WinSceneINVALID = 0,
    WinSceneBackground,
    WinSceneLabel,
    WinSceneStars,
    WinSceneMenu,
    WinSceneMAX,
} WinSceneTags;

@interface WinScene : CCLayerColor {}

@property (nonatomic) CCSprite *background;

- (id)initWithColor:(ccColor4B)color Moves:(int)moves Stars:(int)stars;

@end

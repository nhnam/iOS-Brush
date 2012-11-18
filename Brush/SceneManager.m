//
//  SceneManager.m
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Wrapper class for managing cocos2d scenes and layers

#import "SceneManager.h"

@interface SceneManager ()

+ (void)go: (CCLayer *)layer;
+ (CCScene *)wrap: (CCLayer *)layer;

@end

@implementation SceneManager

// Goes to the chapter scene
+ (void)goChapterSelect
{
    [SceneManager go:[ChapterSelect node]];
}

// Goes to the level scene
+ (void)goLevelSelect
{
    [SceneManager go:[LevelSelect node]];
}

// Goes to the game scene
+ (void)goGameScene
{
    [SceneManager go:[GameScene node]];
}

// Goes to the specified layer's scene.
// If the CCDirector is currently running
//  a scene, it will replace it, otherwise
//   it will call runWithScene: which should
//    not be used to replace an already running
//     scene.
+ (void)go:(CCLayer *)layer
{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene:newScene];
    } else {
        [director runWithScene:newScene];
    }
}

// Wraps the given layer in a new scene.
+ (CCScene *)wrap:(CCLayer *)layer
{
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end

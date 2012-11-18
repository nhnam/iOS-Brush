//
//  SceneManager.h
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChapterSelect.h"
#import "LevelSelect.h"
#import "GameScene.h"
#import "WinScene.h"

@interface SceneManager : NSObject {}

+(void) goChapterSelect;
+(void) goLevelSelect;
+(void) goGameScene;

@end

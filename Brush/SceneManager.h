#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChapterSelect.h"
#import "LevelSelect.h"
#import "GameScene.h"

@interface SceneManager : NSObject {}

+(void) goChapterSelect;
+(void) goLevelSelect;
+(void) goGameScene;

@end

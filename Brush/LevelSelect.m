//
//  LevelSelect.m
//  

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

- (void)onBack:(id)sender
{
    [SceneManager goChapterSelect];
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

- (void)onPlay:(CCMenuItemImage *)sender
{
    int selectedLevel = sender.tag;
    
    BrushData *brushData = [BrushDataParser loadData];
    brushData.selectedLevel = selectedLevel;
    [BrushDataParser saveData:brushData];
    
    [SceneManager goGameScene];
}

- (id)init
{
    if((self=[super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        int smallFont = screenSize.height / 15;
        
        BrushData *brushData = [BrushDataParser loadData];
        int selectedChapter = brushData.selectedChapter;
        
        NSString *selectedChapterName = nil;
        Chapters *selectedChapters = [ChapterParser loadData];
        
        for (Chapter *chapter in selectedChapters.chapters) {
            if ([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter) {
                CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
                selectedChapterName = chapter.name;
            }
        }
        
        CCMenu *levelMenu = [CCMenu menuWithItems: nil];
        NSMutableArray *overlay = [NSMutableArray new];
        
        Levels *selectedLevels = [LevelParser loadLevelsForChapter:brushData.selectedChapter];
        
        for (Level *level in selectedLevels.levels) {
            NSString *normal = [NSString stringWithFormat:@"%@-Normal-iPad.png", selectedChapterName];
            NSString *selected = [NSString stringWithFormat:@"%@-Selected-iPad.png", selectedChapterName];
            
            CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:normal selectedImage:selected target:self selector:@selector(onPlay:)];
            [item setTag:level.number];
            [item setIsEnabled:level.unlocked];
            [levelMenu addChild:item];
            
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
        
        [levelMenu alignItemsInColumns:
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         [NSNumber numberWithInt:4],
         nil];
        
        CGPoint newPosition = levelMenu.position;
        newPosition.y = newPosition.y + (newPosition.y / 10);
        [levelMenu setPosition:newPosition];
        
        [self addChild:levelMenu z:-3];
        
        CCLayer *overlays = [[CCLayer alloc] init];
        CCLayer *labels = [[CCLayer alloc] init];
        
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

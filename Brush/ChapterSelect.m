//
//  ChapterSelect.m
//  

#import "ChapterSelect.h"  
#import "BrushData.h"
#import "BrushDataParser.h"
#import "CCScrollLayer.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"

@implementation ChapterSelect

- (void)onBack:(id)sender
{
    //implement delegation protocol to return to main menu
}

- (void)onSelectChapter:(CCMenuItemImage *)sender
{
    BrushData *brushData = [BrushDataParser loadData];
    [brushData setSelectedChapter:sender.tag];
    [BrushDataParser saveData:brushData];
    [SceneManager goLevelSelect];
}

- (CCLayer *)layerWithChapterName:(NSString *)chapterName
                    chapterNumber:(int)chapterNumber
                       screenSize:(CGSize)screenSize
{
    CCLayer *layer = [[CCLayer alloc] init];
    
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"StickyNote-iPad.png"
                                                    selectedImage:@"StickyNote-iPad.png"
                                                           target:self
                                                         selector:@selector(onSelectChapter:)];
    
    image.tag = chapterNumber;
    CCMenu *menu = [CCMenu menuWithItems:image, nil];
    [menu alignItemsVertically];
    [layer addChild:menu];
    
    int largeFont = [CCDirector sharedDirector].winSize.height / 11;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Marker Felt" fontSize:largeFont];
    layerLabel.position = ccp(screenSize.width / 2, screenSize.height / 2 + 10);
    layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95, 58, 0);
    [layer addChild:layerLabel];
    
    return layer;
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

- (id)init
{
    if( (self=[super init])) {
                
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        NSMutableArray *layers = [NSMutableArray new];
        
        Chapters *chapters = [ChapterParser loadData];
        
        for (Chapter *chapter in chapters.chapters) {
            CCLayer *layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:230];
        
        BrushData *brushData = [BrushDataParser loadData];
        [scroller selectPage:(brushData.selectedChapter - 1)];
        
        [self addChild:scroller];
        [self addBackButton];
    }
    return self;
}

@end

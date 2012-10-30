//
//  ChapterSelect.m
//  

#import "ChapterSelect.h"  
#import "BrushData.h"
#import "BrushDataParser.h"
#import "CCScrollLayer.h"

@implementation ChapterSelect

- (void)onBack:(id)sender
{
    //implement delegation protocol to return to main menu
}

- (void)onSelectChapter:(CCMenuItemImage *)sender
{
    //CCLOG(@"writing the selected stage to BrushData.xml as %i", sender.tag);
    //BrushData *brushData = [BrushDataParser loadData];
    //[brushData setSelectedChapter:sender.tag];
    //[BrushDataParser saveData:brushData];
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
        
        CCLayer *chapterOne = [self layerWithChapterName:@"One" chapterNumber:1 screenSize:screenSize];
        CCLayer *chapterTwo = [self layerWithChapterName:@"Two" chapterNumber:2 screenSize:screenSize];
        
        [layers addObject:chapterOne];
        [layers addObject:chapterTwo];
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:230];
        
        //load selectedPage from selectedStage
        //[scroller selectPage:(BrushData.selectedStage - 1)];
        [self addChild:scroller];
        [self addBackButton];
    }
    return self;
}

@end

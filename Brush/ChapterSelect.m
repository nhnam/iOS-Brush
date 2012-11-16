//
//  ChapterSelect.m
//  Brush
//
//  Created by Jeff Merola on 10/28/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Chapter select scene

#import "BrushAppDelegate.h"
#import "ChapterSelect.h"  
#import "BrushData.h"
#import "BrushDataParser.h"
#import "CCScrollLayer.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"

@implementation ChapterSelect

// Needs to send user back to the main menu.
// Need to implement delegate and protocol
//  to transition back from the CCGLView to
//   the UIKit views.  Also must pause CCDirector's
//    animation.
- (void)onBack:(id)sender
{
    //BrushAppDelegate *app = (BrushAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //implement delegation protocol to return to main menu
}

// On tapping a chapter, save the selected chapter data.
- (void)onSelectChapter:(CCMenuItemImage *)sender
{
    BrushData *brushData = [BrushDataParser loadData];
    [brushData setSelectedChapter:sender.tag];
    [BrushDataParser saveData:brushData];
    [SceneManager goLevelSelect];
}

// Creates a layer with the given name and number
- (CCLayer *)layerWithChapterName:(NSString *)chapterName
                    chapterNumber:(int)chapterNumber
                       screenSize:(CGSize)screenSize
{
    CCLayer *layer = [[CCLayer alloc] init];
    
    // Creates the menu items from the specified images.
    CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"StickyNote-iPad.png"
                                                    selectedImage:@"StickyNote-iPad.png"
                                                           target:self
                                                         selector:@selector(onSelectChapter:)];
    
    // Set the menu item properties and create the menu
    image.tag = chapterNumber;
    CCMenu *menu = [CCMenu menuWithItems:image, nil];
    [menu alignItemsVertically];
    [layer addChild:menu];
    
    // Set the label of the chapter to be the chapter name
    int largeFont = [CCDirector sharedDirector].winSize.height / 11;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Marker Felt" fontSize:largeFont];
    layerLabel.position = ccp(screenSize.width / 2, screenSize.height / 2 + 10);
    layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95, 58, 0);
    [layer addChild:layerLabel];
    
    return layer;
}

// Adds the back button to the scene.
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

// Initialization for the chapter scene
- (id)init
{
    if( (self=[super init])) {
                
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        NSMutableArray *layers = [NSMutableArray new];
        
        // Load the chapter data
        Chapters *chapters = [ChapterParser loadData];
        
        // Create layers for each chapter
        for (Chapter *chapter in chapters.chapters) {
            CCLayer *layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        // Instantiate the CCScrollLayer with the created layers
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:230];
        
        // Load the game data, and set the selected page to the selected chapter
        BrushData *brushData = [BrushDataParser loadData];
        [scroller selectPage:(brushData.selectedChapter - 1)];
        
        [self addChild:scroller];
        [self addBackButton];
    }
    return self;
}

@end

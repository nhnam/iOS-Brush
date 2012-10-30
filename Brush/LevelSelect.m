//
//  LevelSelect.m
//  

#import "LevelSelect.h"

@implementation LevelSelect  
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goChapterSelect];
}

- (void)addBackButton {

    if (self.iPad) {
        
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPad.png" 
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPhone.png" 
                                                         selectedImage:@"Arrow-Selected-iPhone.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back];        
    }
}

- (id)init {
    
    if( (self=[super init])) {
        
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / 9;
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Level Select"    
                                               fontName:@"Marker Felt" 
                                               fontSize:largeFont];  
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height/2);  
        
        // Add label to this scene
		[self addChild:label z:0]; 

        //  Put a 'back' button in the scene
        [self addBackButton];   

    }
    return self;
}

@end

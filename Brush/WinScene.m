//
//  WinScene.m
//  Brush
//
//  Created by Jeff Merola on 11/17/12.
//  Copyright 2012 SDD_Team. All rights reserved.
//

#import "WinScene.h"


@implementation WinScene

@synthesize background = _background;

// This method is called when the user presses the levels button on the win screen
//  Returns the user to the level selection screen
- (void)onSelectLevels:(id)sender
{
    NSLog(@"Levels Pressed.");
    [SceneManager goLevelSelect];
}

// This method is called when the user presses the twitter button on the win screen
//  Currently not implemented
- (void)onSelectTwitter:(id)sender
{
    NSLog(@"Twitter Pressed.");
}

// This method is called when the user presses the facebook button on the win screen
//  Currently not implemented
- (void)onSelectFacebook:(id)sender
{
    NSLog(@"Facebook Pressed.");
}

// Empty method used for padding the win screen menu with empty space
//  Shortcoming of cocos2d CCMenu class
- (void)dummyMethod:(id)sender {}

// Initializer for the win screen
- (id)initWithColor:(ccColor4B)color Moves:(int)moves Stars:(int)stars
{
    if (self == [super initWithColor:color]) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Background image
        self.background = [CCSprite spriteWithFile:@"win-scene-iPad.png"];
        self.background.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.background.position = ccp(screenSize.width/2, screenSize.height / (5.0f/3.0f));
        [self addChild:self.background z:WinSceneBackground tag:WinSceneBackground];
        
        // Score label
        CCLabelTTF *finalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You completed the\n level in %d moves!",moves] fontName:@"Arial" fontSize:36];
        finalScore.anchorPoint = ccp(0.5f, 0.0f);
        finalScore.position = self.background.position;
        [self addChild:finalScore z:WinSceneLabel tag:WinSceneLabel];
        
        // Stars image
        CCSprite *awardedStars = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%dStar-Normal-iPad.png", stars]];
        awardedStars.anchorPoint = ccp(0.7f, 0.4f);
        awardedStars.position = self.background.position;
        awardedStars.scale = 2.0f;
        [self addChild:awardedStars z:WinSceneStars tag:WinSceneStars];
        
        // Menu
        CCMenuItemImage *levelsImage = [CCMenuItemImage itemWithNormalImage:@"levels-iPad.png"
                                                              selectedImage:@"levels-iPad.png"
                                                                     target:self
                                                                   selector:@selector(onSelectLevels:)];

        CCMenuItemImage *twitterImage = [CCMenuItemImage itemWithNormalImage:@"twitter-iPad.png"
                                                              selectedImage:@"twitter-iPad.png"
                                                                     target:self
                                                                   selector:@selector(onSelectTwitter:)];
        
        CCMenuItemImage *facebookImage = [CCMenuItemImage itemWithNormalImage:@"facebook-iPad.png"
                                                              selectedImage:@"facebook-iPad.png"
                                                                     target:self
                                                                   selector:@selector(onSelectFacebook:)];
        
        CCMenuItemImage *spacer = [CCMenuItemImage itemWithNormalImage:@"menu-spacer-iPad.png"
                                                         selectedImage:@"menu-spacer-iPad.png"
                                                                target:self
                                                              selector:@selector(dummyMethod:)];
        
        CCMenu *menu = [CCMenu menuWithItems:levelsImage, spacer, twitterImage, facebookImage, nil];
        [menu alignItemsHorizontally];
        menu.anchorPoint = CGPointMake(0.5f, 0.0f);
        menu.position = ccp(self.background.position.x, self.background.position.y - self.background.contentSize.height/3 - 20);
        [self addChild:menu z:WinSceneMenu tag:WinSceneMenu];
    }
    return self;
}

@end

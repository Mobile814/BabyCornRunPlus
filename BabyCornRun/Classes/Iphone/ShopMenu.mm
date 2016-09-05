//
//  ShopMenu.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopMenu.h"
#import "MainMenu.h"
#import "globals.h"
#import "GameOver.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation ShopMenu

+(id)scene:(bool)mainmenu
{
    isFromMain = mainmenu;
    CCScene *scene =[CCScene node];
    ShopMenu *layer =[ShopMenu node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;       
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"pausebg.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *shopMsg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop3.png"]];
        shopMsg.anchorPoint = ccp(0.0, 1.0);
        shopMsg.position = ccp (183, screenSize.height-10);
        [self addChild:shopMsg z:0];
        
        CCSprite *lives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"lives.png"]];
        lives.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        lives.position = ccp (10, screenSize.height-96);
#else
        lives.position = ccp (60, screenSize.height-96);
#endif
        
        [self addChild:lives z:0];
        
        CCSprite *revive = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"revive.png"]];
        revive.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        revive.position = ccp (164, screenSize.height-100);
#else
        revive.position = ccp (268, screenSize.height-100);
#endif
        [self addChild:revive z:0];
 
#ifdef FREE_VERSION
        CCSprite *removeads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"removeads.png"]];
        removeads.anchorPoint = ccp(0.0, 1.0);
        removeads.position = ccp (309, screenSize.height-88);
        [self addChild:removeads z:0];
#endif
        
        isProgressBuy = false;
        
        buyLives = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy.png"]]
                                                           target:self
                                                         selector:@selector(buyLives:)];
#ifdef FREE_VERSION
        buyLives.position = ccp(-157, -121);
#else
        buyLives.position = ccp(-97, -121);
#endif
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool buy10lives = [prefs boolForKey:@"buy10lives"];
        
        disableBuyLives = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff.png"]];
        disableBuyLives.anchorPoint = ccp(0.0, 1.0);
        
#ifdef FREE_VERSION
        disableBuyLives.position = ccp (53.5, screenSize.height-256);
#else
        disableBuyLives.position = ccp (113.5, screenSize.height-256);
#endif
        [self addChild:disableBuyLives z:11];
        
        if (buy10lives) {
            buyLives.isEnabled = false;
            disableBuyLives.visible = YES;
        }
        else {
            disableBuyLives.visible = NO;
        }
        
        CCMenuItem *buy1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy1.png"]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy1.png"]]
                                                                target:self
                                                              selector:@selector(buy1Life:)];
#ifdef FREE_VERSION
        buy1.position = ccp(-36, -121);
#else
        buy1.position = ccp(68, -121);
#endif
        
        CCMenuItem *buy3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy3.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"buy3.png"]]
                                                               target:self
                                                             selector:@selector(buy3Life:)];
        
#ifdef FREE_VERSION
        buy3.position = ccp(36, -117);
#else
        buy3.position = ccp(140, -117);
#endif
                
#ifdef FREE_VERSION
        removeAds = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"remove.png"]]
                                                               target:self
                                                             selector:@selector(removeAds:)];
        removeAds.position = ccp(149, -117);
        bool isRemoveAds = [prefs boolForKey:@"removeads"];
        
        disableRemoveAds = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff.png"]];
        disableRemoveAds.anchorPoint = ccp(0.0, 1.0);
        disableRemoveAds.position = ccp (359.5, screenSize.height-252);
        [self addChild:disableRemoveAds z:11];
        
        if (isRemoveAds) {
            removeAds.isEnabled = false;
            disableRemoveAds.visible = YES;
        }
        else {
            disableRemoveAds.visible = NO;
        }
#endif
        
        CCMenuItem *back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"back.png"]]
                                                     selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"back.png"]]
                                                             target:self
                                                           selector:@selector(backToPrev:)];
        back.position = ccp(-195, 127);
        
        bool isRated = [prefs boolForKey:@"rateapp"];
        
#ifdef FREE_VERSION
        if (!isRated) {
            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                                               target:self
                                                             selector:@selector(goToAppRate:)];
            rate.position = ccp(148, 130);
            
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, rate, nil];

        }
        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, removeAds, back, nil];
        }
#else
        if (!isRated) {
            rate = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                           selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"rate.png"]]
                                                   target:self
                                                 selector:@selector(goToAppRate:)];
            rate.position = ccp(148, 130);
            
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, rate, nil];
            
        }
        else {
            menu = [CCMenu menuWithItems: buyLives, buy1, buy3, back, nil];
        }
#endif
        
        [self addChild: menu];

    }
    
    return self;
}

- (void) buyLives: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool buy10lives = [prefs boolForKey:@"buy10lives"];
    if (!buy10lives && !isProgressBuy) {
         isProgressBuy = true;
         [[AppDelegate get] buyIAPitem:kTagStartWith10Lives];
    }
}

- (void) buy1Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (!isProgressBuy) {
        isProgressBuy = true;
        [[AppDelegate get] buyIAPitem:kTagBuy1Revive];
    }
}

- (void) buy3Life: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (!isProgressBuy) {
        isProgressBuy = true;
        [[AppDelegate get] buyIAPitem:kTagBuy3Revives];
    }    
}

#ifdef FREE_VERSION
- (void) removeAds: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool isRemoved = [prefs boolForKey:@"removeads"];
    
    if (!isRemoved && !isProgressBuy) {
        isProgressBuy = true;
        [[AppDelegate get] buyIAPitem:kTagRemoveAds];
    }
}
#endif

- (void) goToAppRate: (id) sender
{
#ifdef FREE_VERSION
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/cfreereview"]];
#else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/cplusreview"]];
#endif
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:true forKey:@"rateapp"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController checkAchievements:kTagRateCorn];
    
    if (rate) {
        rate.visible = NO;
    }
    revivesLeft += 3;
}

- (void) backToPrev: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (isFromMain) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOver scene]] ];
    }
    
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end

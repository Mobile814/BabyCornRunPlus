//
//  HowToPlayLayer.m
//  BabyCornRun
//
//  Created by Kang Yong on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayLayer.h"
#import "globals.h"
#import "FullLayer.h"
#import "AppDelegate.h"

@implementation HowToPlayLayer

+(id)scene
{
    CCScene *scene =[CCScene node];
    HowToPlayLayer *layer =[HowToPlayLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"background.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *howto = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"howto.png"]];
        howto.anchorPoint = ccp(0.5, 0.5);
        howto.position = ccp (240, 160);
        [self addChild:howto z:0];
        
        
        CCMenuItem *close = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"close.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"close.png"]]
                                                               target:self
                                                             selector:@selector(goToPlay:)];
        close.position = ccp(165, 105);
                
        menu = [CCMenu menuWithItems: close, nil];
        [self addChild: menu z:10];
        
    }
    
    return self;
}


- (void) goToPlay: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer scene]] ];
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end

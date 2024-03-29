//
//  FullLayer.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FullLayer.h"
#import "HudLayer.h"
#import "GameLayer.h"
#import "globals.h"

@implementation FullLayer
+(id)scene
{
    CCScene *scene=[CCScene node];
    FullLayer *layer=[FullLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super init])
    {
        isGrounded = false;
        runMeters = 0;
        isPlayerRunning = true;
        additionalSpeed = 0;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        bool buy10lives = [prefs boolForKey:@"buy10lives"];
        
        if (buy10lives) {
            lifesLeft = 10;
        }
        else {
#ifdef FREE_VERSION
            lifesLeft = 3;
#else
            lifesLeft = 6;
#endif
        }
        
        //revivesLeft = 10;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"bg1.png"]]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        loading = [[CCLabelTTF alloc] initWithString:@"Loading..." dimensions:CGSizeMake(150, 40)
                                                       alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:32.0f];
        loading.position = ccp(240.0,145.0);
        loading.color = ccBLACK;
        [self addChild:loading z:0];
                
        GameLayer *gameLayer = [[GameLayer alloc] init];
        [self addChild:gameLayer z:0];
        [gameLayer release];
        
    }
    return self;
}

- (void)addHudLayer {
    loading.visible = NO;
    HudLayer *hudlayer=[[HudLayer alloc] init];
    [self addChild:hudlayer z: 1];
    [hudlayer release];
}

- (void)pauseSchedulerAndActionsRecursive:(CCNode *)node {
    printf("tryingtopausein full");   
    [node pauseSchedulerAndActions];
    for (CCNode *child in [node children]) {
        [self pauseSchedulerAndActionsRecursive:child];
    }
}

- (void)resumeSchedulerAndActionsRecursive:(CCNode *)node {
    [node resumeSchedulerAndActions];
    for (CCNode *child in [node children]) {
        [self resumeSchedulerAndActionsRecursive:child];
    }
}  

-(void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
    
}
@end

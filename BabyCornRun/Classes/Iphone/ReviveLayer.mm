//
//  ReviveLayer.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReviveLayer.h"
#import "globals.h"
#import "FullLayer.h"
#import "GameLayer.h"
#import "AppDelegate.h"

@implementation ReviveLayer

+(id)scene
{
    CCScene *scene =[CCScene node];
    ReviveLayer *layer =[ReviveLayer node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if(self=[super init])
    {
        self.isTouchEnabled=YES;
        
        life = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"heart.png"]];
        life.anchorPoint=ccp(0.0,0.0);
        life.position=ccp(410.0,0.0);
        [self addChild:life]; 
        
        timerCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d", 2] dimensions:CGSizeMake(50, 30)
                                           alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:20.0f];
        timerCnt.visible = NO;
        timerCnt.position = ccp(468.0,55.0);
        timerCnt.color = ccBLACK;
        [self addChild:timerCnt];
        
        reviveCnt = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"x%d", revivesLeft] dimensions:CGSizeMake(50, 30)
                                            alignment:UITextAlignmentLeft fontName:@"Palatino" fontSize:16.0f];
        reviveCnt.position = ccp(475.0,10.0);
        reviveCnt.color = ccBLACK;
        [self addChild:reviveCnt];
        
        revivesLeft--;
        
        [self schedule:@selector(countRevive) interval:0.01f];
        
    }
    
    return self;
}

-(void)countRevive 
{
    if (!isPlayerRunning) {
        timerCnt.visible = YES;
        [timerCnt setString:[NSString stringWithFormat:@"%d", (countTime2+50)/100]];
    }
    
}

-(void) ccTouchesEnded:(NSSet *)touch withEvent:(UIEvent *)event

{
    NSSet *allTouches= [event allTouches];
    
    for (UITouch * touch in allTouches)
    {
        
        if(touch.phase==UITouchPhaseEnded)
        {        
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location]; 
            CGRect revive = CGRectMake(410, 0, 76, 60);
            
            if (CGRectContainsPoint(revive, location) && isPaused)
            {
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"revive.mp3"];
                
                isPaused=false;
                isPlayerRunning = true;
                [self.parent resumeSchedulerAndActionsRecursive:self.parent];
                [self.parent removeChild:self cleanup:YES];
            }
        }
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

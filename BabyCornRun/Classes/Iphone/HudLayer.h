//
//  HudLayer.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    CCSprite *pauseButton;
    int runMeter;
    CCLabelTTF *scoreCnt;
    CCLabelTTF *lifeCnt;
}

+(id)scene;
-(void)updateLifes;
-(void)countScore;

@end

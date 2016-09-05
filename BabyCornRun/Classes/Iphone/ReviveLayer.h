//
//  PauseMenu.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface ReviveLayer : CCLayer {
    
    CCSprite *life;
    CCLabelTTF *timerCnt;  
    CCLabelTTF *reviveCnt; 
}
+(id)scene;
@end

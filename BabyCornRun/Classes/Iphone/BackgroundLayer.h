//
//  BackgroundLayer.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum {
    kTagCloud1 = 0,
    kTagCloud2 = 1,
    kTagCloud3 = 2,
    kTagCloud4 = 3,
    kTagCloud5 = 4,    
};

@interface BackgroundLayer : CCLayer {
    
    CCSprite *cloud1;
    CCSprite *cloud2;
    CCSprite *cloud3;
    CCSprite *cloud4;
    CCSprite *cloud5;
}

+(id)scene;
-(void)updateWithPlayerPosition :(CGPoint) lastPosition :(CGPoint) currentPosition;
@end


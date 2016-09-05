//
//  FullLayer_ipad.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FullLayer_ipad : CCLayer {
    CCLabelTTF *loading;
}
+(id)scene;
-(void)addHudLayer_ipad;
-(void)pauseSchedulerAndActionsRecursive:(CCNode *)node;
-(void)resumeSchedulerAndActionsRecursive:(CCNode *)node;
@end

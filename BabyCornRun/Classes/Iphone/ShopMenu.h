//
//  PauseMenu.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopMenu : CCLayer {
    
    CCMenu *menu;    
    CCMenuItem *rate;
    CCMenuItem *buyLives;
#ifdef FREE_VERSION
    CCMenuItem *removeAds;
    CCSprite *disableRemoveAds;
#endif
    
    CCSprite *disableBuyLives;
}
+(id)scene:(bool)mainmenu;
@end

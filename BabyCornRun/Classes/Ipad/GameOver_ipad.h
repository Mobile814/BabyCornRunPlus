//
//  GameOver_ipad.h
//  babycornrun
//
//  Created by Teodor Rotaru on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globals.h"

#ifdef FREE_VERSION
#import "AdWhirlDelegateProtocol.h"
#import "RootViewController.h"
#endif

#ifdef FREE_VERSION
@interface GameOver_ipad : CCLayer <AdWhirlDelegate>
#else
@interface GameOver_ipad : CCLayer
#endif
{
    CCMenu *menu;
    CGSize screenSize;
    
#ifdef FREE_VERSION
    AdWhirlView *adView;
    RootViewController *viewController;
    
    CCSprite *adsbox;
    CCSprite *noads;
    bool removeads;
    
#endif
    
}

#ifdef FREE_VERSION
@property(nonatomic,retain) AdWhirlView *adView;
#endif

+(CCScene *) scene;

@property (nonatomic, retain) CCLabelTTF *bestscoreLabel;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;

@end

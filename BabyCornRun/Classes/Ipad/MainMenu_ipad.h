//
//  MainMenu_ipad.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
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
@interface MainMenu_ipad : CCLayer <AdWhirlDelegate>
#else
@interface MainMenu_ipad : CCLayer
#endif
{

    CCMenu *menu;
    CCSprite *backSoundoff;
    CCSprite *effectSoundoff;
    
    UIView *NagView;
    NSMutableArray *nagArray;
    
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
-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag;
-(void)AddNagScreen;

@end

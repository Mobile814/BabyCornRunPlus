//
//  AppDelegate.h
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"
#import "StoreObserver.h"
#import "RevMobAds.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, StoreObserverProtocol,SKProductsRequestDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    SimpleAudioEngine *m_pSoundEngine;
    
    //IAP
    UIAlertView			*loadingView;
    SKProduct          *m_productItem;
    NSString           *selectedIdentifier;
    BOOL NagScreen;
}

@property(readwrite)BOOL NagScreen;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int m_nbgvol;
@property (nonatomic, assign) int m_neffvol;
@property (readwrite, retain)  SimpleAudioEngine *m_pSoundEngine;
@property (nonatomic, retain) RootViewController *viewController;
@property (nonatomic, retain) SKProduct          *m_productItem;

+(AppDelegate*) get;
- (void) twitterCallback;
- (void)buyIAPitem:(int)buyType;

@end

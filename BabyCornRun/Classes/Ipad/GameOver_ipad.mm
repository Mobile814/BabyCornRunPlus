//
//  GameOver_ipad.m
//  babycornrun
//
//  Created by Teodor Rotaru on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOver_ipad.h"
#import "cocos2d.h"
#import "FullLayer_ipad.h"
#import "globals.h"
#import "MainMenu_ipad.h"
#import "ShopMenu_ipad.h"
#import "AppDelegate.h"
#import "RootViewController.h"

#ifdef FREE_VERSION
#import "AdWhirlView.h"
#endif

@implementation GameOver_ipad

#ifdef FREE_VERSION
@synthesize adView;
#endif

+(CCScene *) scene
{	CCScene *scene = [CCScene node];
	CCLayer *layer = [GameOver_ipad node];
	[scene addChild: layer];
	return scene;
}

@synthesize bestscoreLabel;
@synthesize scoreLabel;

-(id) init
{

	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
        
        screenSize = [CCDirector sharedDirector].winSize;
                
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"bg1-ipad.png"]]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
        
        CCSprite *bottom = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"ground_007-hd.png"]]];
        bottom.anchorPoint = ccp(0.0, 1.0);
        bottom.position = ccp (-80, 183);
        [self addChild:bottom z:0];
        
        isProgressBuy = false;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
#ifdef FREE_VERSION
        removeads = [prefs boolForKey:@"removeads"];
        
        if (!removeads) {
            adsbox = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"box-hd.png"]];
            adsbox.anchorPoint = ccp(0.0, 1.0);
            adsbox.position = ccp (765, screenSize.height+6);
            [self addChild:adsbox z:0];
            
            noads = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"support-hd.png"]];
            noads.anchorPoint = ccp(0.0, 1.0);
            noads.position = ccp (770, screenSize.height+6);
            [self addChild:noads z:0];
            
            adsbox.visible = NO;
            noads.visible = NO;
        }
#endif
        
        CCSprite *bestScoreLbl = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"bestscore-hd.png"]]];
        bestScoreLbl.anchorPoint = ccp(0.0, 1.0);
        bestScoreLbl.position = ccp (20, screenSize.height-20);
        [self addChild:bestScoreLbl z:0];
        
        CCSprite *score = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"score-hd.png"]]];
        score.anchorPoint = ccp(0.0, 1.0);
        score.position = ccp (340, screenSize.height-142);
        [self addChild:score z:0];
                
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", runMeters] dimensions:CGSizeMake(200, 100) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:56];
        scoreLabel.color = ccBLACK;
        scoreLabel.position = ccp( 564, screenSize.height-196);
    
        [self addChild:scoreLabel];
        
        if (runMeters > bestScore) {
            bestScore = runMeters;
            CCSprite *highscore = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"hiscore-hd.png"]]];
            highscore.anchorPoint = ccp(0.0, 1.0);
            highscore.position = ccp (632, screenSize.height-110);
            [self addChild:highscore z:0];
            
            RootViewController *rootViewController = [AppDelegate get].viewController;
            [rootViewController submitScore:bestScore];
            
            int type = 0;
            if (bestScore > 2000000)
                type = kTagNumber1Crop;
            else if (bestScore > 999999)
                type = kTagKernelYesSir;
            else if (bestScore > 666666)
                type = kTagAmaizing;
            else if (bestScore > 333333)
                type = kTagAvoidHarvest;
            else if (bestScore > 55555)
                type = kTagPopMarathon;
            else if (bestScore > 25555)
                type = kTagHalfMarathon;
            
            if (type > 0) {
                [rootViewController checkAchievements:type];
            }
        }
        
        [prefs setInteger:bestScore forKey:@"bestscore"];
        
        bestscoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", bestScore] dimensions:CGSizeMake(200, 100) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:56];
        bestscoreLabel.color = ccBLACK;
        bestscoreLabel.position = ccp( 340, screenSize.height-80);
        [self addChild:bestscoreLabel];
        
        CCMenuItem *playAgain = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"playagain-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"playagain-hd.png"]]
                                                           target:self
                                                         selector:@selector(startGame:)];
        
        playAgain.position = ccp(0, -160);
        
        CCMenuItem *mainmenu = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainmenu1-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"mainmenu1-hd.png"]]
                                                               target:self
                                                             selector:@selector(goToMenu:)];
        mainmenu.position = ccp(-110, -60);
        
        CCMenuItem *shop = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop2-hd.png"]]
                                                       selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop2-hd.png"]]
                                                               target:self
                                                             selector:@selector(openShop:)];
        shop.position = ccp(110, -60);
        
        CCMenuItem *facebook = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"fbicon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"fbicon-hd.png"]]
                                                           target:self
                                                         selector:@selector(goToFacebook:)];
        facebook.position = ccp(-100, 40);
        
        CCMenuItem *twitter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ticon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ticon-hd.png"]]
                                                           target:self
                                                         selector:@selector(goToTwitter:)];
        twitter.position = ccp(0, 40);
        
        CCMenuItem *gamecenter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                           target:self
                                                         selector:@selector(openGameCenter:)];
        gamecenter.position = ccp(100, 40);
        
        menu = [CCMenu menuWithItems: playAgain, mainmenu, shop, facebook, twitter, gamecenter, nil];
        [self addChild: menu z:5];
        
        
#ifdef FREE_VERSION
        removeads = [prefs boolForKey:@"removeads"];
        
        if (!removeads) {
            [self schedule:@selector(checkRemoveAds:) interval:1.0];
        }
#endif
        
    }
    
    return self;
}

#ifdef FREE_VERSION
-(void) checkRemoveAds: (ccTime) delta
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    removeads = [prefs boolForKey:@"removeads"];
    
    if (removeads) {
        if (adView) {
            //Remove adView from superView
            [adView removeFromSuperview];
            //Replace adView's view with "nil"
            [adView replaceBannerViewWith:nil];
            //Tell AdWhirl to stop requesting Ads
            [adView ignoreNewAdRequests];
            //Set adView delegate to "nil"
            [adView setDelegate:nil];
            //Release adView
            [adView release];
            //set adView to "nil"
            adView = nil;
        }
        
        adsbox.visible = NO;
        noads.visible = NO;
        [self unschedule:@selector(checkRemoveAds:)];
    }
}
#endif

- (void) startGame: (id) sender
{

    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer_ipad scene]] ];
}

- (void) goToMenu: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu_ipad scene]] ];
}

- (void) openShop: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ShopMenu_ipad scene:false]] ];
}

- (void) goToFacebook: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[AppDelegate get].viewController facebookCallback];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController checkAchievements:kTagPostCorn];
}

- (void) goToTwitter: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[AppDelegate get] twitterCallback];
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController checkAchievements:kTagTweetCorn];
}

- (void) openGameCenter: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController showLeaderboard];
}

#ifdef FREE_VERSION
//These are the methods for the AdWhirl Delegate, you have to implement them
#pragma mark AdWhirlDelegate methods

- (void)adWhirlWillPresentFullScreenModal {
    //It's recommended to invoke whatever you're using as a "Pause Menu" so your
    //game won't keep running while the user is "playing" with the Ad (for example, iAds)
    //[self yourPauseMenu];
}

- (void)adWhirlDidDismissFullScreenModal {
    //Once the user closes the Ad he'll want to return to the game and continue where
    //he left it
    //[self resumeGame];
}

- (NSString *)adWhirlApplicationKey {
    //Here you have to enter your AdWhirl SDK key
    if (!removeads)
        return @"97ba09ae3ac849bcb8f0cc6c2b953840";
    else 
        return @"";    
}

- (UIViewController *)viewControllerForPresentingModalView {
    //Remember that UIViewController we created in the Game.h file? AdMob will use it.
    //If you want to use "return self;" instead, AdMob will cancel the Ad requests.
    return viewController;
}

// Resize the Ad
-(void)adjustAdSize {
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    // Get the actual Ad size
    CGSize adSize = [adView actualAdSize];
    // Create a new frame so we can assign the actual size
    CGRect newFrame = adView.frame;
    // Set the height
    newFrame.size.height = adSize.height;
    // Set the width
    // In theory you could use the Ad's actual size but as most of them are smaller than
    // the screen size (480 in landscape mode), they will be positioned to the left. If
    // you want to keep them on the left, replace "screenSize.width" with "adSize.width"
    newFrame.size.width = screenSize.width;
    // Position the frame
    newFrame.origin.x = (self.adView.bounds.size.width - adSize.width)/2;
    // Some Ads have different height and we want them to be positioned at the bottom
    // of the screen so we set our frame's position to the screen height minus the
    // Ad height
    newFrame.origin.y = (screenSize.height - adSize.height);
    // Assign the new frame to the current one
    adView.frame = newFrame;
    // Apply animations
    [UIView commitAnimations];
}

-(void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    //This is a little trick I'm using... on my game I created a CCMenu with an image to promote
    //my own paid game so this way I can guarantee that there will always be an Ad on-screen
    //even if there's no internet connection... it's up to you if you want to implement this or not.
    
    /////[self removeChild:adBanner cleanup:YES];
    
    //In case your game is in Landscape mode, set the interface orientation to that
    //of your game (actually, UIInterfaceOrientationLandscapeLeft and UIInterfaceOrientationLandscapeRight
    //will have the same effect on the ad... i.e. iAd). If your game is in Portrait mode, comment
    //the following line
    [self.adView rotateToOrientation:UIInterfaceOrientationLandscapeLeft];
    //Different networks have different Ad sizes, we want our Ad to display in it's right size so
    //we're invoking the method to resize the Ad
    
    [self adjustAdSize];
    
    if (adsbox)
        adsbox.visible = YES;
    if (noads)
        noads.visible = YES;    
    
}

-(void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
    //The code to show my own Ad banner again
}

-(void)onEnter {
    
    //Let's allocate the viewController (it's the same RootViewController as declared
    //in our AppDelegate; will be used for the Ads)
    
    viewController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] viewController];
    
    //viewController = [AppDelegate get].viewController;
    
    //Assign the AdWhirl Delegate to our adView
    self.adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
    //Set auto-resizing mask
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    //This isn't really needed but also it makes no harm. It just retrieves the configuration
    //from adwhirl.com so it knows what Ad networks to use
    [adView updateAdWhirlConfig];
    //Get the actual size for the requested Ad
    CGSize adSize = [adView actualAdSize];
    //
    //Set the position; remember that we are using 4 values (in this order): X, Y, Width, Height
    //You can comment this line if your game is in portrait mode and you want your Ad on the top
    //if you want the Ad in other position (portrait or landscape), use the following code,
    //for this example, the Ad will be positioned in the bottom+center of the screen
    //(in landscape mode):
    //Same explanation as the one in the method "adjustAdSize" for the Ad's width
    self.adView.frame = CGRectMake(0,screenSize.height-adSize.height,screenSize.width,adSize.height);
    
    //
    //NOTE:
    //screenSize = [[CCDirector sharedDirector] winSize];
    //adSize.height = the height of the requested Ad
    //
    //Trying to keep everything inside the Ad bounds
    self.adView.clipsToBounds = YES;
    //Adding the adView (used for our Ads) to our viewController
    [viewController.view addSubview:adView];
    //Bring our view to front
    [viewController.view bringSubviewToFront:adView];
    
    [super onEnter];
}

-(void)onExit {
    //There's something weird about AdWhirl because setting the adView delegate
    //to "nil" doesn't stops the Ad requests and also it doesn't remove the adView
    //from superView; do the following to remove AdWhirl from your scene.
    //
    //If adView exists, remove everything
    if (adView) {
        //Remove adView from superView
        [adView removeFromSuperview];
        //Replace adView's view with "nil"
        [adView replaceBannerViewWith:nil];
        //Tell AdWhirl to stop requesting Ads
        [adView ignoreNewAdRequests];
        //Set adView delegate to "nil"
        [adView setDelegate:nil];
        //Release adView
        [adView release];
        //set adView to "nil"
        adView = nil;
    }
    [super onExit];
}
#endif

-(void) ccTouchesEnded:(NSSet *)touch withEvent:(UIEvent *)event

{
    NSSet *allTouches= [event allTouches];
    
    for (UITouch * touch in allTouches)
    {
        
        if(touch.phase==UITouchPhaseEnded)
        {        
            CGPoint location = [touch locationInView:[touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location]; 
            
#ifdef FREE_VERSION
            CGRect remove = CGRectMake(765, screenSize.height-88, 265, 88);
            if (CGRectContainsPoint(remove, location))
            {
                if (effectsoundOn)
                    [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                bool isRemoved = [prefs boolForKey:@"removeads"];
                
                if (!isRemoved && !isProgressBuy) {
                    isProgressBuy = true;
                    [[AppDelegate get] buyIAPitem:kTagRemoveAds];
                }
                
            }
#endif
        }
    }
}


- (void) dealloc
{
#ifdef FREE_VERSION
    //Remove the adView controller
    self.adView.delegate = nil;
    self.adView = nil;
#endif
    
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end

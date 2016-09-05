//
//  MainMenu_ipad.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu_ipad.h"
#import "FullLayer_ipad.h"
#import "ShopMenu_ipad.h"
#import "MainBackLayer_ipad.h"
#import "InfoviewController.h"
#import "NewsviewController.h"
#import "AppDelegate.h"
#import "HowToPlayLayer_ipad.h"
#import "Reachability.h"
#import "ImageLoadClass.h"
#import "xmlparser.h"
#import "RootViewController.h"

#ifdef FREE_VERSION
#import "AdWhirlView.h"
#endif

@implementation MainMenu_ipad

#ifdef FREE_VERSION
@synthesize adView;
#endif

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenu_ipad *layer = [MainMenu_ipad node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        self.isTouchEnabled = YES;
        
        if ([AppDelegate get].NagScreen) 
        {
            [self AddNagScreen];
            [AppDelegate get].NagScreen=FALSE;
        }
        
        screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg1-ipad.png"]];
        background.anchorPoint = ccp(0.0, 1.0);
        background.position = ccp (0, screenSize.height);
        [self addChild:background z:0];
                        
        CCSprite *logo = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"logo1-hd.png"]];
        logo.anchorPoint = ccp(0.0, 1.0);
        logo.position = ccp (0, screenSize.height);
        [self addChild:logo z:0];
        
        isProgressBuy= false;

#ifdef FREE_VERSION
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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


        //placeholder music
        if (backSoundOn)
            [[AppDelegate get].m_pSoundEngine playBackgroundMusic:@"gameplay.mp3"];
        
        
        CCMenuItem *play = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"play-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"play-hd.png"]]
                                                           target:self
                                                         selector:@selector(startGame:)];
        play.position = ccp(390, 90);
        
        CCMenuItem *moreGames = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"more-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"more-hd.png"]]
                                                           target:self
                                                         selector:@selector(openMoreApps:)];
        moreGames.position = ccp(390, -50);
        
        CCMenuItem *news = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"news-hd.png"]]
                                                        selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"news-hd.png"]]
                                                                target:self
                                                              selector:@selector(openNews:)];
        news.position = ccp(230, 60);
        
        CCMenuItem *shop = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop1-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"shop1-hd.png"]]
                                                           target:self
                                                         selector:@selector(openShop:)];
        shop.position = ccp(230, -60);
        
        CCMenuItem *achievements = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"achievements-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"achievements-hd.png"]]
                                                           target:self
                                                         selector:@selector(openAchievements:)];
        achievements.position = ccp(110, -170);
        
        CCMenuItem *gamecenter = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"gicon-hd.png"]]
                                                           target:self
                                                         selector:@selector(openGameCenter:)];
        gamecenter.position = ccp(210, -170);
        
        CCMenuItem *bsoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"bsoundon-hd.png"]]
                                                           target:self
                                                         selector:@selector(switchBackSound:)];
        bsoundon.position = ccp(310, -170);
        
        backSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        backSoundoff.anchorPoint = ccp(0.0, 1.0);
        backSoundoff.position = ccp (753.5, screenSize.height-504);
        if (backSoundOn)
            backSoundoff.visible = NO;
        [self addChild:backSoundoff z:11];
        
        CCMenuItem *ssoundon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                   selectedSprite:[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"ssoundon-hd.png"]]
                                                           target:self
                                                         selector:@selector(switchEffectSound:)];
        ssoundon.position = ccp(420, -170);
        
        effectSoundoff = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"soundoff-hd.png"]];
        effectSoundoff.anchorPoint = ccp(0.0, 1.0);
        effectSoundoff.position = ccp (873.5, screenSize.height-504);
        if (effectsoundOn)
            effectSoundoff.visible = NO;
        [self addChild:effectSoundoff z:11];
        
        menu = [CCMenu menuWithItems: play, moreGames, news, shop, achievements, gamecenter, bsoundon, ssoundon, nil];
        [self addChild: menu z:10];
        
        MainBackLayer_ipad *mainbacklayer=[[MainBackLayer_ipad alloc] init];
        [self addChild:mainbacklayer z:5];
        [mainbacklayer release];  
        
        [[AppDelegate get].viewController authenticate];
        
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

    if (!shownHowToPlay) {
        shownHowToPlay = true;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HowToPlayLayer_ipad scene]] ];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FullLayer_ipad scene]] ];
    }
}

- (void) openMoreApps: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    InfoviewController   *movetoview= [[InfoviewController alloc]initWithNibName:@"InfoviewController_ipad" bundle:nil];
    [[[CCDirector sharedDirector]openGLView]addSubview:movetoview.view];
}

- (void) openNews: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    NewsviewController   *movetoview= [[NewsviewController alloc]initWithNibName:@"NewsviewController_ipad" bundle:nil];
    [[[CCDirector sharedDirector]openGLView]addSubview:movetoview.view];
}

- (void) openShop: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ShopMenu_ipad scene:true]] ];
}


- (void) openAchievements: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    
    [rootViewController showAchievements];
}

- (void) openGameCenter: (id) sender
{    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    RootViewController *rootViewController = [AppDelegate get].viewController;
    [rootViewController showLeaderboard];
}

- (void) switchBackSound: (id) sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if(backSoundOn)
    {   
        backSoundOn = false;
        backSoundoff.visible = YES;
        if ([[AppDelegate get].m_pSoundEngine isBackgroundMusicPlaying])
            [[AppDelegate get].m_pSoundEngine pauseBackgroundMusic];
        
    }
    else
    {
        backSoundOn = true;
        backSoundoff.visible = NO;
        [[AppDelegate get].m_pSoundEngine resumeBackgroundMusic];  
    }
}

- (void) switchEffectSound: (id) sender
{
    [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    if (effectsoundOn) {
        effectsoundOn = false;
        effectSoundoff.visible = YES;
    }
    else {
        effectsoundOn = true;
        effectSoundoff.visible = NO;
    }
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

-(void)AddNagScreen
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"   message:@"BabyCornRun requires an Internet connection.\nMake sure connection is available."
                                delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
    } 
    else
    {
        [self performSelectorInBackground:@selector(ProcessStart) withObject:nil];
    }
}

-(void)ProcessStart
{
    //    [INDICATOR  startAnimating];
    NSURL *url=[NSURL URLWithString:@"http://nsquareit.com/application/iphone/news.php"];
    NSXMLParser *rssparser=[[NSXMLParser alloc] initWithContentsOfURL:url];
	xmlparser *parser=[[xmlparser alloc]initXMLParser];
	[parser setClassName:@"result"    withRootName:@"root" tagNumber:100];
	[rssparser setDelegate:parser];
	[rssparser parse];
    [rssparser release];
    [parser release];
    //	[delegate setData:@"" items:parser.Items Tag:parser.tagValue];
    [self setData:@"" items:parser.nag Tag:parser.tagValue];   
}
-(void)ProcessComplete
{
    //    [INDICATOR  stopAnimating];
    if ([nagArray count]>0)
    {
        NagView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
        NagView.backgroundColor=[UIColor grayColor];
        NagView.alpha=0.9;
        NSDictionary *Dict;
        Dict=[nagArray objectAtIndex:0];
        ImageLoadClass* asyncImage;
        CGRect frame;

        frame.size.width=864; frame.size.height=688;
        frame.origin.x=80; frame.origin.y=40;

        asyncImage = [[[ImageLoadClass alloc] initWithFrame:frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url =[NSURL URLWithString:[Dict objectForKey:@"image"]];
        NSLog(@"%@",url);
        [asyncImage loadImageFromURL:url];
        asyncImage.backgroundColor =[UIColor clearColor];
        [NagView addSubview:asyncImage];
        
        UIButton *HowTo=[UIButton buttonWithType:UIButtonTypeCustom];
        HowTo.frame= frame;
        [HowTo addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [NagView addSubview:HowTo];
        UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame= CGRectMake(900, screenSize.height - 754, 80, 80);
        [cancel setBackgroundImage:[UIImage imageNamed:@"cancelbutton.png"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [NagView addSubview:cancel];
        [NagView bringSubviewToFront:cancel];
        [[[CCDirector sharedDirector]openGLView]addSubview:NagView];
    }
}

- (void)tapBtn:(id)sender
{
    NSDictionary *Dict;
    Dict=[nagArray objectAtIndex:0];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [Dict objectForKey:@"NAGurl"] ]];
}
- (void)cancelBtnClicked:(id)sender
{
    [NagView removeFromSuperview];
}

-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag
{   
    if (tag==100) 
    {
        nagArray=items;
        [self performSelectorOnMainThread:@selector(ProcessComplete) withObject:nil waitUntilDone:NO];
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
    
    [NagView removeFromSuperview];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
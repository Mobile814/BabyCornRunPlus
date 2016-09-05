//
//  AppDelegate.m
//  babycornrun
//
//  Created by Jiang Yong on 3/1/2012.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "LoadingLayer.h"
#import "LoadingLayer_ipad.h"
#import "RootViewController.h"
#import "globals.h"
#import "AddThis.h"

@implementation AppDelegate

@synthesize window;
@synthesize m_pSoundEngine, m_nbgvol, m_neffvol, NagScreen, m_productItem;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
		CC_ENABLE_DEFAULT_GL_STATES();
		CCDirector *director = [CCDirector sharedDirector];
		CGSize size = [director winSize];
		CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
		sprite.position = ccp(size.width/2, size.height/2);
		sprite.rotation = -90;
		[sprite visit];
		[[director openGLView] swapBuffers];
		CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    //Addthis
    [AddThisSDK setAddThisPubId:@"jimmyonapp@gmail.com"];
    [AddThisSDK setAddThisApplicationId:@"ra-4f56c2223e699ca7"];
    
    //in-app purchases
    StoreObserver *observer = [[StoreObserver alloc] init];
    observer.delegate = self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert];
    
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
    
    revivesLeft = 0;
    shownHowToPlay = false;  
    m_neffvol = m_nbgvol = 50;
    backSoundOn = true;
    effectsoundOn = true;
    isFirstMain = true;
    NagScreen=TRUE;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        ptm_ratio = 64;
    else
        ptm_ratio = 32;
    
	
	//sound
	m_pSoundEngine = [SimpleAudioEngine sharedEngine];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
	
	// Run the intro Scene
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[CCDirector sharedDirector] runWithScene: [LoadingLayer_ipad scene]];
    else
       [[CCDirector sharedDirector] runWithScene: [LoadingLayer scene]];
}

-(void)checkPushMessageForUrl:(NSString*)message{
    
    NSArray *comp = [message componentsSeparatedByString:@"www"];
    if ([comp count] > 1) {
        NSString *url = [NSString stringWithFormat:@"http://www%@", [comp objectAtIndex:1]];
        NSLog(@"opening URL: %@", url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"fail to register remote push notification: %@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
     //Urban Airship push
     // Convert the token to a hex string and make sure it's all caps
     NSMutableString *tokenString = [NSMutableString stringWithString:[[deviceToken description] uppercaseString]];
     [tokenString replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0, tokenString.length)];
     [tokenString replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0, tokenString.length)];
     [tokenString replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, tokenString.length)];
     
     // Make the NSURL for the question for
     NSString *urlFormat = @"https://go.urbanairship.com/api/device_tokens/%@";
     NSURL *registrationURL = [NSURL URLWithString:[NSString stringWithFormat:urlFormat, tokenString]];
     
     // Make the registration question for
     NSMutableURLRequest *registrationRequest = [[NSMutableURLRequest alloc] initWithURL:registrationURL];
     [registrationRequest setHTTPMethod:@"PUT"];
     
     // Fire it off
     NSURLConnection *connection = [NSURLConnection connectionWithRequest:registrationRequest delegate:self];
     [connection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    // Check for previous failures
    if ([challenge previousFailureCount] > 0) {
        // We've already tried - a touch is incorrect with our credentials
        NSLog(@"Urban Airship credentials invalid");
        return;
    }

    // Send our Urban Airship credentials
    
    //developement
//#ifdef FREE_VERSION
//    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"0Krjx31tQAGfgs2PzFCVhQ"/*App Key*/
//                                                                     password:@"C-QA7G7QR9GAJ_dcU6Fm3Q"/*App Secret*/
//                                                                  persistence:NSURLCredentialPersistenceNone];
//#else
//    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"ZLz3g5J_TXyH5vahXW-95A"/*App Key*/
//                                                                     password:@"Zr328s7ERC-oK8efYQehsQ"/*App Secret*/
//                                                                  persistence:NSURLCredentialPersistenceNone];
//#endif

    //production
#ifdef FREE_VERSION
    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"Lpmn2n4jSgCvlG_vI5lDDw"/*App Key*/
                                                                     password:@"uClBCWCxR9i0VOEHlY261w"/*App Secret*/
                                                                  persistence:NSURLCredentialPersistenceNone];
#else
    NSURLCredential *airshipCredentials = [NSURLCredential credentialWithUser:@"kYFz3KfsRR2SH-SO_By_KQ"/*App Key*/
                                                                     password:@"crvzAd77SBq8eiyqcCndgg"/*App Secret*/
                                                                  persistence:NSURLCredentialPersistenceNone];
#endif
    
    
    [[challenge sender] useCredential:airshipCredentials forAuthenticationChallenge:challenge];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"%@", returnString); 
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    NSString *revMobId = @"4fe4cffb1c43a5000c0003ba";
    [RevMobAds showFullscreenAdWithAppID:revMobId withViewController:self.viewController];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) twitterCallback {
    
    [AddThisSDK shareURL:nil withService:@"twitter" title:@"Baby Corn Run"
             description:[NSString stringWithFormat:@"I just scored (%d) in BabyCornRun. Try this game free and beat my high score! Check out the game at: http://bit.ly/babycornrunfree", runMeters]];
}


- (void)buyIAPitem:(int)buyType
{
	if (![SKPaymentQueue canMakePayments]){	
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
															message:@"inApp purchase Disabled"
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		return;
	}
    
    
    enum {
        kTagStartWith10Lives = 1,
        kTagBuy1Revive = 2,
        kTagBuy3Revives = 3,
        kTagRemoveAds = 4,
    };
    
    selectedIdentifier = nil;
    switch (buyType) {
        case kTagStartWith10Lives:
            selectedIdentifier = K_STORE_GEMS_1;
            break;
        case kTagBuy1Revive:
            selectedIdentifier = K_STORE_GEMS_2;
            break;
        case kTagBuy3Revives:
            selectedIdentifier = K_STORE_GEMS_3;
            break;
        case kTagRemoveAds:
            selectedIdentifier = K_STORE_GEMS_4;
            break;
        default:
            break;
    }
	
    if (selectedIdentifier) {
        SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:selectedIdentifier]];
        request.delegate = self;
        [request start];
    }

}

-(void)transactionDidError:(NSError*)error{
    isProgressBuy = false;
	[loadingView dismissWithClickedButtonIndex:0 animated:NO];
    
    if (error.code != SKErrorPaymentCancelled)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:[error localizedDescription]
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

-(void)transactionDidFinish:(NSString*)transactionIdentifier{
        
    NSLog(@"transactionDidFinish");
    isProgressBuy = false;
	[loadingView dismissWithClickedButtonIndex:0 animated:NO];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                        message:@"Purchase successful. Enjoy!"
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"[ IN APP PURCHASE] request error: %@", [error localizedDescription]);
	[loadingView dismissWithClickedButtonIndex:0 animated:NO];
}


- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = [[NSArray alloc] initWithArray:response.products];
    for(int i=0;i<[myProduct count];i++)        
    {
        SKProduct *product = [myProduct objectAtIndex:i];
        NSLog(@"Name: %@ - Price: %f",[product localizedTitle],[[product price] doubleValue]);      
        NSLog(@"Product identifier: %@", [product productIdentifier]);
        if ([[product productIdentifier] isEqualToString:selectedIdentifier]){
            m_productItem = product;
        }
    }       
    
    for(NSString *invalidProduct in response.invalidProductIdentifiers)
        NSLog(@"Problem in iTunes connect configuration for product: %@", invalidProduct);
    
    SKPayment *payment;
    payment = [SKPayment paymentWithProduct:m_productItem];
    NSLog(@"purchase - %@", selectedIdentifier);            
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
	
	loadingView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	
	UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
	[loadingView addSubview:actInd];
	[actInd startAnimating];
	[actInd release];	
	
    
	UILabel *l = [[UILabel alloc]init];
	l.frame = CGRectMake(100, -25, 210, 100);
	l.text = @"Please wait...";
	l.font = [UIFont fontWithName:@"Helvetica" size:16];	
	l.textColor = [UIColor whiteColor];
	l.shadowColor = [UIColor blackColor];
	l.shadowOffset = CGSizeMake(1.0, 1.0);
	l.backgroundColor = [UIColor clearColor];
	[loadingView addSubview:l];		
	[l release];
    
	[loadingView show];
    
    
    [request autorelease];
    [myProduct release];
}



+(AppDelegate*) get {
	return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
    
    [SimpleAudioEngine end];
	[m_pSoundEngine release];
    
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end

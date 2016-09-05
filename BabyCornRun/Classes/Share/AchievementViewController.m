//
//  AchievementViewController.m
//  SecretLabEscape


#import "AchievementViewController.h"
#import "AppDelegate.h"
#import "GameOverviewController.h"
#import "SimpleAudioEngine.h"
@implementation AchievementViewController

@synthesize Unlock1;
@synthesize Unlock2;
@synthesize Unlock3;
@synthesize Unlock4;
@synthesize Unlock5;
@synthesize Unlock6;
@synthesize Unlock7;
@synthesize Unlock8;
@synthesize Unlock9;
@synthesize Unlock10;
@synthesize Unlock11;
@synthesize Unlock12;
@synthesize Unlock13;
@synthesize Unlock14;
@synthesize Unlock15;
@synthesize ScrollView;
@synthesize ViewTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    App=[[UIApplication sharedApplication]delegate];
    if ( App.fromPauseview||ViewTag==3) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            ScrollView.frame=CGRectMake(0, 170, 1024, 768);
            self.view.frame=CGRectMake(1024,0,1024,768);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(  self.view.frame,-1024,0);
            [UIView commitAnimations];
            ScrollView.contentSize=CGSizeMake(1024, 3100);
        }
        else
        {
            ScrollView.frame=CGRectMake(0,60, 480, 480);
            self.view.frame=CGRectMake(480,0,480,320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(  self.view.frame,-480,0);
            [UIView commitAnimations];
            ScrollView.contentSize=CGSizeMake(480, 1750);
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            ScrollView.frame=CGRectMake(0, 170, 1024, 768);
            self.view.frame=CGRectMake(0,768,1024,768);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(  self.view.frame,0,-768);
            [UIView commitAnimations];
            ScrollView.contentSize=CGSizeMake(1024, 3100);
        }
        else
        {
            ScrollView.frame=CGRectMake(0,60, 480, 480);
            self.view.frame=CGRectMake(0,320,480,320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(  self.view.frame,0,-320);
            [UIView commitAnimations];
            ScrollView.contentSize=CGSizeMake(480, 1750);
        }
    }
    [self.view addSubview:ScrollView];
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement1"]) {
        Unlock1.image=[UIImage imageNamed:@"Unlock.png"];
    }
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement2"]) {
        Unlock2.image=[UIImage imageNamed:@"Unlock.png"];
    }    
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement3"]) {
        Unlock3.image=[UIImage imageNamed:@"Unlock.png"];
    }    
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement4"]) {
        Unlock4.image=[UIImage imageNamed:@"Unlock.png"];
    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement5"]) {
        Unlock5.image=[UIImage imageNamed:@"Unlock.png"];
    }    
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement6"]) {
        Unlock6.image=[UIImage imageNamed:@"Unlock.png"];
    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement7"]) {
        Unlock7.image=[UIImage imageNamed:@"Unlock.png"];
    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement8"]) {
        Unlock8.image=[UIImage imageNamed:@"Unlock.png"];
    }  
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement9"]) {
        Unlock9.image=[UIImage imageNamed:@"Unlock.png"];
    } 
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement10"]) {
        Unlock10.image=[UIImage imageNamed:@"Unlock.png"];
    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement11"]) {
        Unlock11.image=[UIImage imageNamed:@"Unlock.png"];
    } 
//    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement12"]) {
//        Unlock12.image=[UIImage imageNamed:@"Unlock.png"];
//    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement13"]) {
        Unlock13.image=[UIImage imageNamed:@"Unlock.png"];
    }
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement14"]) {
        Unlock14.image=[UIImage imageNamed:@"Unlock.png"];
    }   
    if ([[NSUserDefaults standardUserDefaults ]boolForKey:@"Achievement15"]) {
        Unlock15.image=[UIImage imageNamed:@"Unlock.png"];
    }
}

- (void)viewDidUnload
{
    [self setUnlock1:nil];
    [self setUnlock2:nil];
    [self setUnlock3:nil];
    [self setUnlock4:nil];
    [self setUnlock5:nil];
    [self setUnlock6:nil];
    [self setUnlock7:nil];
    [self setUnlock8:nil];
    [self setUnlock9:nil];
    [self setUnlock10:nil];
    [self setUnlock11:nil];
    [self setUnlock12:nil];
    [self setUnlock13:nil];
    [self setUnlock14:nil];
    [self setUnlock15:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
 
        return  UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc {
    [Unlock1 release];
    [Unlock2 release];
    [Unlock3 release];
    [Unlock4 release];
    [Unlock5 release];
    [Unlock6 release];
    [Unlock7 release];
    [Unlock8 release];
    [Unlock9 release];
    [Unlock10 release];
    [Unlock11 release];
    [Unlock12 release];
    [Unlock13 release];
    [Unlock14 release];
    [Unlock15 release];
    [ScrollView release];
    [super dealloc];
}
- (IBAction)BackBtnClicked:(id)sender 
{
    if (App.Sound==TRUE) 
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"buttonclick.mp3"];
    }
    if (App.fromGameoverview || App.fromPauseview    )
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        { 
            if (App.fromPauseview) {
                //                PauseViewController *PauseView  = [[PauseViewController alloc] initWithNibName:@"PauseViewController_ipad"  bundle:nil];
                //                PauseView.view.backgroundColor=[UIColor clearColor];
                //                [[[CCDirector sharedDirector] openGLView] addSubview:PauseView.view];
            }
            else
            {
                GameOverviewController *GameoverView  = [[GameOverviewController alloc] initWithNibName:@"GameOverviewController_ipad"  bundle:nil];
                GameoverView.view.backgroundColor=[UIColor clearColor];
                [[[CCDirector sharedDirector] openGLView] addSubview:GameoverView.view];
            }
            self.view.frame=CGRectMake(0,0,1024,768);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,1024,0);
            [UIView commitAnimations];
        }
        else
        {
            if (App.fromPauseview) {
                //                PauseViewController *PauseView  = [[PauseViewController alloc] initWithNibName:@"PauseViewController"  bundle:nil];
                //                PauseView.view.backgroundColor=[UIColor clearColor];
                //                [[[CCDirector sharedDirector] openGLView] addSubview:PauseView.view];
            }
            else{
                GameOverviewController *GameoverView  = [[GameOverviewController alloc] initWithNibName:@"GameOverviewController"  bundle:nil];
                GameoverView.view.backgroundColor=[UIColor clearColor];
                [[[CCDirector sharedDirector] openGLView] addSubview:GameoverView.view];
            }
            self.view.frame=CGRectMake(0,0,480,320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,480,0);
            [UIView commitAnimations];
        }
    } 
    
    else if(ViewTag==3)
    {
        App.FromBottomTab=FALSE;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            SecretHideOutView *SecretView  = [[SecretHideOutView alloc] initWithNibName:@"SecretHideOutView_ipad"  bundle:nil];
            SecretView.view.backgroundColor=[UIColor clearColor];
            [[[CCDirector sharedDirector] openGLView] addSubview:SecretView.view];
            self.view.frame=CGRectMake(0,0,1024,768);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,1024,0);
            [UIView commitAnimations];
        }
        else
        {
            SecretHideOutView *SecretView  = [[SecretHideOutView alloc] initWithNibName:@"SecretHideOutView"  bundle:nil];
            SecretView.view.backgroundColor=[UIColor clearColor];
            [[[CCDirector sharedDirector] openGLView] addSubview:SecretView.view];
            self.view.frame=CGRectMake(0,0,480,320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,480,0);
            [UIView commitAnimations];
        }
    }

    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.view.frame=CGRectMake(0,0,1024,768);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,0,768);
            [UIView commitAnimations];
        }
        else
        {
            self.view.frame=CGRectMake(0,0,480,320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animFinished1:finished:context:)];
            [UIView setAnimationDuration:0.5];
            self.view.frame=CGRectOffset(self.view.frame,0,320);
            [UIView commitAnimations];
        }
    }
}
- (void)animFinished1:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [self.view removeFromSuperview];   
}
-(IBAction)AchivementBtnClicked:(id)sender
{
    [self showAchievements];
}
- (void) showAchievements
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        myViewController = [[UIViewController alloc] init];
        
        // Add the temporary UIViewController to the main OpenGL view
        [[[[CCDirector sharedDirector] openGLView] window] addSubview:myViewController.view];
        
        // Tell UIViewController to present the leaderboard
        [myViewController presentModalViewController:achievements animated:YES];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    //    [viewController dismissModalViewControllerAnimated: YES];
    //    [viewController release];
//    [myViewController.view removeFromSuperview];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [myViewController  dismissModalViewControllerAnimated:YES];
        [myViewController.view removeFromSuperview];
    }
    else
    {
        [viewController.view removeFromSuperview];
    }
}
@end

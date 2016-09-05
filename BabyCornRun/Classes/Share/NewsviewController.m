//
//  NewsviewController.m
//  SecretLabEscape


#import "NewsviewController.h"
#import "ImageLoadClass.h"
#import "xmlparser.h"
#import "Reachability.h"
#import "globals.h"
#import "AppDelegate.h"

@implementation NewsviewController
@synthesize INDICATOR;

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
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"   message:@"SecretLabEscape requires an Internet connection.\nMake sure connection is available."
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
    [INDICATOR  startAnimating];
    NSURL *url=[NSURL URLWithString:@"http://nsquareit.com/application/iphone/news.php?app=2"];
    NSXMLParser *rssparser=[[NSXMLParser alloc] initWithContentsOfURL:url];
	xmlparser *parser=[[xmlparser alloc]initXMLParser];
	[parser setClassName:@"result"    withRootName:@"root" tagNumber:100];
	[rssparser setDelegate:parser];
	[rssparser parse];
    [rssparser release];
    [parser release];
    //	[delegate setData:@"" items:parser.Items Tag:parser.tagValue];
    [self setData:@"" items:parser.Items Tag:parser.tagValue];   
}
-(void)ProcessComplete
{
    [INDICATOR  stopAnimating];
    if ([newsArray count]>0) {
        
        NSDictionary *Dict;
        Dict=[newsArray objectAtIndex:0];
        ImageLoadClass* asyncImage;
        CGRect frame;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            frame.size.width=1024; frame.size.height=768;
            frame.origin.x=0; frame.origin.y=0;
        }
        else
        {
            frame.size.width=480; frame.size.height=320;
            frame.origin.x=0; frame.origin.y=0;
        }
        asyncImage = [[[ImageLoadClass alloc] initWithFrame:frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url =[NSURL URLWithString:[Dict objectForKey:@"bigimage"]];
        NSLog(@"%@",url);
        [asyncImage loadImageFromURL:url];
        asyncImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:asyncImage];
        UIButton *HowTo=[UIButton buttonWithType:UIButtonTypeCustom];
        HowTo.frame= frame;
        [HowTo addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:HowTo];
        
    }
    //    [HowTo setImage:[UIImage imageNamed:@"HowTo.png"]forState:UIControlStateNormal];
    [self.view bringSubviewToFront:backbtn];
    
    
}
- (IBAction)tapBtn:(id)sender
{
    NSDictionary *Dict;
    if ([newsArray count]>0) 
    {
        Dict=[newsArray objectAtIndex:0];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [Dict objectForKey:@"url"] ]];
    }
    
}
- (IBAction)BackBtnClicked:(id)sender
{
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"button.mp3"];
    
    [self.view removeFromSuperview];
}

-(void)setData:(NSString *)message items:(NSMutableArray *)items Tag:(int)tag
{   
    if (tag==100) 
    {
        newsArray=items;
        [self performSelectorOnMainThread:@selector(ProcessComplete) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)viewDidUnload
{
    [self setINDICATOR:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    else {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}
- (void)dealloc {
    [INDICATOR release];
    [super dealloc];
}
@end

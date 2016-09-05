//
//  InfoviewController.m
//  SecretLabEscape

#import "InfoviewController.h"
#import "xmlparser.h"
#import "ImageLoadClass.h"
#import "Reachability.h"
#import "globals.h"
#import "AppDelegate.h"

@implementation InfoviewController
@synthesize infoTbl;
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
    dicsetImages =[[NSMutableDictionary alloc]init];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];

    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"   message:@"SecretLabEscape requires an Internet connection.\nMake sure connection is available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
    } 
    else
    {
        [self performSelectorInBackground:@selector(ProcessStart) withObject:nil];
    }
    infoTbl.backgroundView=nil;
    infoTbl.backgroundColor=[UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated    
{
    [infoTbl reloadData];   
}

-(void)ProcessStart
{
    [INDICATOR  startAnimating];
    NSURL *url=[NSURL URLWithString:@"http://nsquareit.com/application/iphone/app.php?app=2"];
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
    [infoTbl  reloadData];
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ProcessStart) userInfo:nil repeats:YES];
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
        infoArray=items;
        for (int i=0; i<[infoArray count]; i++) {
            NSDictionary *Dict;
            Dict=[infoArray objectAtIndex:i];
            NSURL* url =[NSURL URLWithString:[Dict objectForKey:@"image"]];
            [dicsetImages setObject:url forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self performSelectorOnMainThread:@selector(ProcessComplete) withObject:nil waitUntilDone:NO];
    }
    
}
- (IBAction)RefreshBtnClicked:(id)sender
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"   message:@"SecretLabEscape requires an Internet connection.\nMake sure connection is available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
    } 
    else
    {
        [dicsetImages removeAllObjects];
        [self performSelectorInBackground:@selector(ProcessStart) withObject:nil];
    }
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;   
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [infoArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"ImageCell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *Dict;
    Dict=[infoArray objectAtIndex:indexPath.row];
    ImageLoadClass* asyncImage;
    CGRect frame;
    frame.size.width=70; frame.size.height=70;
    frame.origin.x=20; frame.origin.y=2;
    UILabel *TitleLbl;
    UILabel *DescriptionLbl;
    if([dicsetImages objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]])
    {
        [[cell.contentView viewWithTag:999]removeFromSuperview];
        [[cell.contentView viewWithTag:888]removeFromSuperview];;
        [[cell.contentView viewWithTag:777]removeFromSuperview];;

        NSURL* url =[NSURL URLWithString:[Dict objectForKey:@"image"]];
//        [dicsetImages setObject:url forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
        NSLog(@"%@",url);
        asyncImage = [[[ImageLoadClass alloc] initWithFrame:frame] autorelease];
        asyncImage.tag = 999;
        [asyncImage loadImageFromURL:url];
        cell.autoresizesSubviews=YES;
        asyncImage.backgroundColor =[UIColor clearColor];
        [cell.contentView addSubview:asyncImage];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            TitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(140, 2, 400, 30 )];
            TitleLbl.tag=888;
            [TitleLbl setText:[Dict objectForKey:@"title"]];
            //            [TitleLbl setFont:[UIFont fontWithName:@"Arial" size:18]];
            [TitleLbl setFont:[UIFont boldSystemFontOfSize:22]];
            [cell.contentView addSubview:TitleLbl];
            TitleLbl.backgroundColor=[UIColor clearColor];
            [TitleLbl release];
            DescriptionLbl=[[UILabel alloc]initWithFrame:CGRectMake(140, 40, 800, 40)];
            DescriptionLbl.tag=777;
            [DescriptionLbl setText:[Dict objectForKey:@"description"]];
            [DescriptionLbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            DescriptionLbl.numberOfLines=2;
            [cell.contentView addSubview:DescriptionLbl];
            DescriptionLbl.backgroundColor=[UIColor    clearColor];
            [DescriptionLbl  release];
        }
        else
        {
            TitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 2, 320, 20 )];
            TitleLbl.tag=888;
            [TitleLbl setText:[Dict objectForKey:@"title"]];
            [TitleLbl setFont:[UIFont boldSystemFontOfSize:18]];
            [cell.contentView addSubview:TitleLbl];
            TitleLbl.backgroundColor=[UIColor clearColor];
            [TitleLbl release];
            DescriptionLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 320, 40)];
            DescriptionLbl.tag=777;
            [DescriptionLbl setText:[Dict objectForKey:@"description"]];
            [DescriptionLbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            DescriptionLbl.numberOfLines=2;
            [cell.contentView addSubview:DescriptionLbl];
            DescriptionLbl.backgroundColor=[UIColor    clearColor];
            [DescriptionLbl  release];
        }

    }

    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];

             cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row%2==0)
        {
            cell.backgroundColor=[UIColor grayColor];
        }
        else
        {
            cell.backgroundColor=[UIColor darkGrayColor];
        }
        NSURL* url =[NSURL URLWithString:[Dict objectForKey:@"image"]];
        //        [dicsetImages setObject:url forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
        NSLog(@"%@",url);
        asyncImage = [[[ImageLoadClass alloc] initWithFrame:frame] autorelease];
        asyncImage.tag = 999;
        [asyncImage loadImageFromURL:url];
        cell.autoresizesSubviews=YES;
        asyncImage.backgroundColor =[UIColor clearColor];
        [cell.contentView addSubview:asyncImage];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            TitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(140, 2, 400, 30 )];
            TitleLbl.tag=888;
            [TitleLbl setText:[Dict objectForKey:@"title"]];
            //            [TitleLbl setFont:[UIFont fontWithName:@"Arial" size:18]];
            [TitleLbl setFont:[UIFont boldSystemFontOfSize:22]];
            [cell.contentView addSubview:TitleLbl];
            TitleLbl.backgroundColor=[UIColor clearColor];
            [TitleLbl release];
            DescriptionLbl=[[UILabel alloc]initWithFrame:CGRectMake(140, 40, 800, 40)];
            DescriptionLbl.tag=777;
            [DescriptionLbl setText:[Dict objectForKey:@"description"]];
            [DescriptionLbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            DescriptionLbl.numberOfLines=2;
            [cell.contentView addSubview:DescriptionLbl];
            DescriptionLbl.backgroundColor=[UIColor    clearColor];
            [DescriptionLbl  release];
        }
        else
        {
            TitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 2, 320, 20 )];
            TitleLbl.tag=888;
            [TitleLbl setText:[Dict objectForKey:@"title"]];
            [TitleLbl setFont:[UIFont boldSystemFontOfSize:18]];
            [cell.contentView addSubview:TitleLbl];
            TitleLbl.backgroundColor=[UIColor clearColor];
            [TitleLbl release];
            DescriptionLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 320, 40)];
            DescriptionLbl.tag=777;
            [DescriptionLbl setText:[Dict objectForKey:@"description"]];
            [DescriptionLbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            DescriptionLbl.numberOfLines=2;
            [cell.contentView addSubview:DescriptionLbl];
            DescriptionLbl.backgroundColor=[UIColor    clearColor];
            [DescriptionLbl  release];
        }

    } 
    else 
    {
    }

    //    cell.textLabel.text=[Dict objectForKey:@"title"];
    //    cell.detailTextLabel.text=[Dict objectForKey:@"description"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [infoTbl reloadData];   
    NSDictionary *Dict;
    Dict=[infoArray objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [Dict objectForKey:@"url"] ]];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

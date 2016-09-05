//
//  ImageLoadClass.m
//  iEditor
//
//  Created by iMobDev Technologies on 04/07/11.
//  Copyright 2011 Mehul Darji. All rights reserved.
//

#import "ImageLoadClass.h"


@implementation ImageLoadClass
- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [super dealloc];
}


- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(402, 314, 60, 60)];
    else
        progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(185, 125, 30, 30)];
    
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self addSubview:progress];
    [progress startAnimating];

	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	[connection release];
	connection=nil;
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
//    [self  getRoundCornerOfImage:[UIImage imageWithData:data]];
	//make an image view for the image
    self.backgroundColor=[UIColor clearColor];
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleToFill;
   // self.autoresizesSubviews=YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
    [progress   stopAnimating];
    [progress setHidesWhenStopped:YES];
    
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

@end

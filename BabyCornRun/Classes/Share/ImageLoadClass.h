//
//  ImageLoadClass.h
//  iEditor
//
//  Created by iMobDev Technologies on 04/07/11.
//  Copyright 2011 Mehul Darji. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageLoadClass : UIView {
    NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	UIActivityIndicatorView *progress;
}

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@end

//
//  ReviewsAlert.m
//  PrayersReference
//
//  Created by Radu Cojocaru on 02.02.2010.
//  Copyright 2010 Surgeworks. All rights reserved.
//

#import "ReviewsAlert.h"


@implementation ReviewsAlert

+ (void)showReviewsAlert {
	ReviewsAlert *reviewsAlert = [[ReviewsAlert alloc] init];
	[reviewsAlert showReviewsAlert];
}
+(void) showAlertWithoutTime{
	ReviewsAlert *reviewsAlert = [[ReviewsAlert alloc] init];
	[reviewsAlert showAlert];
}
- (void)showReviewsAlert 
{
	// Set start date
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"reviewsAlertStartDate"] == NULL) {
		NSLog(@"no start date");
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"reviewsAlertStartDate"];
	}
	
	// Check if reviews alert was not banned ("Don't ask again")
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"reviewsAlertBanned"] == YES) {
		NSLog(@"reviews alert banned");
		return;
	}
	
	// Check if user already reviewed the app
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userDidRate"] == YES) {
		NSLog(@"user did rate");
		return;
	}
	
	// Check if enough time has passed
	//int daysToWait = (3600 * 24) * 10; // 10 days
    int daysToWait=(3600 * 24)*10;
	if ([[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"reviewsAlertStartDate"]] < daysToWait) {
		NSLog(@"not enough time");
		return;
	}
	
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle: @"Help Support!" 
														 message: @"Please rate this game on the app store with 5 stars so we can keep the free updates coming." 
														delegate: self 
											   cancelButtonTitle: @"Remind me later" 
											   otherButtonTitles: @"Rate it Now", nil] autorelease];
	[alertView show];
}
-(void) showAlert{
    
	// Set start date
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"reviewsAlertStartDate"] == NULL) {
		NSLog(@"no start date");
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"reviewsAlertStartDate"];
	}
	
	// Check if reviews alert was not banned ("Don't ask again")
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"reviewsAlertBanned"] == YES) {
		NSLog(@"reviews alert banned");
		return;
	}
	
	// Check if user already reviewed the app
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userDidRate"] == YES) {
		NSLog(@"user did rate");
		return;
	}
	
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle: @"Help Support!" 
                                                         message: @"Please rate this game on the appstore so we can keep the free updates coming." 
                                                        delegate: self 
                                               cancelButtonTitle: @"Rate it Now" 
                                               otherButtonTitles: @"No Thanks", nil] autorelease];
    [alertView show];

	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        // Go to the AppStore
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userDidRate"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/slreview"]];
        //		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=360405766&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
	}
    else if (buttonIndex == 1) { 
        // Don't ask again
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reviewsAlertBanned"];
	}
	else if (buttonIndex == 2) {
        // Cancel. Reset date
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"reviewsAlertStartDate"];
	}

}

@end

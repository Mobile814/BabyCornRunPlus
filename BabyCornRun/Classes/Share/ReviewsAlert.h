//
//  ReviewsAlert.h
//  PrayersReference
//
//  Created by Radu Cojocaru on 02.02.2010.
//  Copyright 2010 Surgeworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReviewsAlert : NSObject <UIAlertViewDelegate>{
    
    
}

+ (void)showReviewsAlert;
- (void)showReviewsAlert;

+(void) showAlertWithoutTime;
-(void) showAlert;
@end

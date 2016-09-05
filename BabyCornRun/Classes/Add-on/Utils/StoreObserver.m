//
//  MyStoreObserver.m
//  PDFReader
//
//  Created by Alexander Rudenko on 12/2/09.
//  Copyright 2009 r3apps.com. All rights reserved.
//

#import "StoreObserver.h"
#import "AppDelegate.h"
#import "globals.h"

@implementation StoreObserver
@synthesize delegate;

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
		NSLog(@"transaction.error: %@", [transaction.error localizedDescription]);

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	[delegate transactionDidError:transaction.error];
}

-(void)recordTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"recordTransaction: %@", [transaction.error localizedDescription]);
}


-(void)provideContent:(NSString *)identifier{
	NSLog(@"provideContent: %@", identifier);
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction{
	NSLog(@"purchased: %@", transaction.payment.productIdentifier);
    isProgressBuy = false;
    
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"purchase.mp3"];
    
	if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_1]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:true forKey:@"buy10lives"];
    }
    else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_2]){
        revivesLeft += 1;
	}
	else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_3]){	
        revivesLeft += 3;
	}
    else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_4]){		
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:true forKey:@"removeads"];
	}

	NSLog(@"Transaction Finished");
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [delegate transactionDidFinish:transaction.payment.productIdentifier];

}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
	NSLog(@"Transaction Restored");
    isProgressBuy = false;
    if (effectsoundOn)
        [[AppDelegate get].m_pSoundEngine playEffect:@"purchase.mp3"];
    
	if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_1]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:true forKey:@"buy10lives"];
    }
    else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_2]){		
        revivesLeft += 1;
	}
	else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_3]){		
        revivesLeft += 3;
	}
    else if([transaction.payment.productIdentifier isEqualToString:K_STORE_GEMS_4]){		
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:true forKey:@"removeads"];
	}

    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}
@end

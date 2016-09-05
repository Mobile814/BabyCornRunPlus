//
//  MyStoreObserver.h
//  PDFReader
//
//  Created by Alexander Rudenko on 12/2/09.
//  Copyright 2009 r3apps.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#ifdef FREE_VERSION
#define K_STORE_GEMS_1 @"Start_with_10_lives"
#define K_STORE_GEMS_2 @"Buy_1_revive"
#define K_STORE_GEMS_3 @"Buy_3_revives"
#define K_STORE_GEMS_4 @"Remove_the_ads"
#else
#define K_STORE_GEMS_1 @"Start_with_10_lives_Plus"
#define K_STORE_GEMS_2 @"Buy_1_revive_Plus"
#define K_STORE_GEMS_3 @"Buy_3_revives_Plus"
#define K_STORE_GEMS_4 @"Remove_the_ads_Plus"
#endif

@protocol StoreObserverProtocol <NSObject>
	-(void)transactionDidFinish:(NSString*)transactionIdentifier;
	-(void)transactionDidError:(NSError*)error;
@end


@interface StoreObserver : NSObject <SKPaymentTransactionObserver> {
	id <StoreObserverProtocol> delegate;	
}

@property (nonatomic, assign) id <StoreObserverProtocol> delegate;

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
@end


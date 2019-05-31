//
//  StoreManager.h
//  MKSync
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 MK Inc. All rights reserved.
//  mugunthkumar.com

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

#define IAP_GROUP1		@"AthlenXPurchase.Group1"
#define IAP_GROUP2		@"AthlenXPurchase.Group2"
#define IAP_FULLVERSION	@"AthlenXPurchase.FullVersion"

@protocol MKStoreManagerDelegate;

@interface MKStoreManager : NSObject <SKProductsRequestDelegate>
{
	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;
	
	BOOL m_perchasedGroup1;
	BOOL m_perchasedGroup2;
	BOOL m_perchasedFullVersion;
	
	id<MKStoreManagerDelegate> m_delegate;
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

@property (nonatomic, readwrite) BOOL purchasedGroup1;
@property (nonatomic, readwrite) BOOL purchasedGroup2;
@property (nonatomic, readwrite) BOOL purchasedFullVersion;

@property (nonatomic, strong) id<MKStoreManagerDelegate> delegate;

+ (MKStoreManager*) sharedManager;

- (void) perchaseWithProductID:(NSString*)productID;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent: (NSString*) productIdentifier;
- (void) restoreAllPurchases;

@end

@protocol MKStoreManagerDelegate <NSObject>

- (void) mkStoreManagerSuccessed:(MKStoreManager *)storeManager productID:(NSString *)productID;

@end

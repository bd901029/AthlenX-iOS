//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"
#import "AthleanXAppDelegate.h"

MKStoreManager* g_sharedStoreManager = nil;

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize purchasedGroup1 = m_perchasedGroup1, purchasedGroup2 = m_perchasedGroup2, purchasedFullVersion = m_perchasedFullVersion;
@synthesize delegate = m_delegate;

+ (MKStoreManager*) sharedManager
{
	if ( !g_sharedStoreManager )
	{
		g_sharedStoreManager = [[MKStoreManager alloc] init];
	}
	
	return g_sharedStoreManager;
}

- (id) init
{
	if ( self = [super init] )
	{
		self.purchasableObjects = [[NSMutableArray alloc] init];
		[self requestProductData];
		
		[self loadPurchases];
		self.storeObserver = [[MKStoreObserver alloc] init];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self.storeObserver];
	}
	
	return self;
}

- (void) dealloc
{
//	[g_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:IAP_GROUP1, IAP_GROUP2, IAP_FULLVERSION, nil]]; // add any other product here
	request.delegate = self;
	[request start];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
		
	// populate your UI Controls here
	for (int i = 0; i < [purchasableObjects count]; i++)
	{
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@", [product localizedTitle], [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) perchaseWithProductID:(NSString*)productID
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning"
														message:@"You are not authorized to purchase from AppStore"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil] autorelease];
		[alert show];
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase"
													message:messageToBeShown
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void) provideContent: (NSString*) productIdentifier
{
	if ([productIdentifier isEqualToString:IAP_GROUP1])
	{
		self.purchasedGroup1 = YES;
	}
	else if ([productIdentifier isEqualToString:IAP_GROUP2])
	{
		self.purchasedGroup2 = YES;
	}
	else if ([productIdentifier isEqualToString:IAP_FULLVERSION])
	{
		self.purchasedFullVersion = YES;
	}
	
	[self updatePurchases];
	
	if ( self.delegate )
		[self.delegate mkStoreManagerSuccessed:self productID:productIdentifier];
}

- (void) restoreAllPurchases
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) loadPurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	self.purchasedGroup1 = [userDefaults boolForKey:IAP_GROUP1];
	self.purchasedGroup2 = [userDefaults boolForKey:IAP_GROUP2];
	self.purchasedFullVersion = [userDefaults boolForKey:IAP_FULLVERSION];
}

- (void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:self.purchasedGroup1 forKey:IAP_GROUP1];
	[userDefaults setBool:self.purchasedGroup2 forKey:IAP_GROUP2];
	[userDefaults setBool:self.purchasedFullVersion forKey:IAP_FULLVERSION];
	[userDefaults synchronize];
}

@end

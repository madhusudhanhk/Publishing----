//
//  IAPHelper.h
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"
#import "ASIHTTPRequest.h"
#import "PBStoreViewController.h"
#import "PBDataCommunicator.h"
#import "PBConstants.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

#define kSharedSecret      @"cfdbadc59c674f2c99d9cf77ea5e904b"

@interface PBInAppHandler : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
//    PBStoreViewController * issue;
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

+ (PBInAppHandler *) sharedHandler;

- (void) getPurchasedProductsList: (NSArray *)inIssues; // Should be called during FIRST LAUNCH OF APPLICATION
- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;

@end

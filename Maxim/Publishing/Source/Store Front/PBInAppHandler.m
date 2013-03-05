//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "PBInAppHandler.h"
#import "PBIssue.h"
#import "JSON.h"

@implementation PBInAppHandler
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

+ (PBInAppHandler *) sharedHandler; {
    static PBInAppHandler * sharedHandler = nil;
    if(!sharedHandler) sharedHandler = [PBInAppHandler new];
    return sharedHandler;
}


- (void) getPurchasedProductsList: (NSArray *)inIssues {
    // Iterate through inIssues and place product info request

    NSMutableSet * productIds = [NSMutableSet set];
    
    for ( PBIssue * issue in inIssues) {
        [productIds addObject: [issue productId]];
    }

    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers: productIds] autorelease];
    _request.delegate = [PBInAppHandler sharedHandler];
    [_request performSelector: @selector(start) withObject: nil afterDelay: 0.2f];
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                PBLog(@"Previously purchased: %@", productIdentifier);
            }
            PBLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
                        
    }
    return self;
}

- (void)requestProducts {
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error  
{
   /*
    NSString *messageString = [error localizedDescription];
    NSString *moreString = [error localizedFailureReason] ?
    [error localizedFailureReason] :
    NSLocalizedString(@"Try again.", nil);
    messageString = [NSString stringWithFormat:@"%@. %@", messageString, moreString];
 
    PBLog(@"%@", messageString);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Request couldn't be processed. Try again Later." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
	[alertView show];
	[alertView release];
*/
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results..."); 
    PBLog(@"%@", response);
//    self.products = response.products;
    self.request = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}


- (void)recordTransaction:(SKPaymentTransaction *)transaction 
{
    NSString * receipt = [[[NSString alloc] initWithData:transaction.transactionReceipt
                                              encoding:NSUTF8StringEncoding]autorelease];
    PBLog(@"Receipt which is to be send to the server is %@",receipt);

    NSURL * url = [NSURL URLWithString: kBaseURL];
    PBDataCommunicator* request1 = [PBDataCommunicator requestWithURL: url serviceName:kVerifyReceipt];
    [request1 setArguments: [NSArray arrayWithObjects: receipt,  nil]]; 
    PBLog(@"The request given to server is %@", request1);
    [request1 setDelegate: self];
    [request1 startAsynchronous];
  
}

- (void)requestFinished:(PBDataCommunicator *)request
{
    // Use when fetching text data
   NSString *responseString = [request responseString];
    
    // Use when fetching binary data
 //   NSData *responseData = [request responseData];
 //  NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
   // Create a dictionary from the JSON string
    
    PBLog(@"The response string which comes from the server is %@", responseString);
    NSDictionary *json_dict = [[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
    PBLog(@"jsonstring =%@ jsonDict=%@",responseString,json_dict );
  
    BOOL returnValue;
    if ([[json_dict valueForKey:@"status"] intValue] == 0) {
        returnValue = YES;
        NSLog(@"SUCCESS");
      
    } else {
        returnValue = NO;
        NSLog (@"FAILURE");
    }
    
   [json_dict release];


}

- (void)requestFailed:(PBDataCommunicator *)request
{
    NSError *error = [request error];
    PBLog(@"%@", error);
}


- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    
  //  [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    

 //   [self recordTransaction: transaction];
  //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
  
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                PBLog(@"A NEW TRANSACTION SUCCESS");
                NSString* receipt = [[[NSString alloc] initWithData:transaction.transactionReceipt
                                                           encoding:NSUTF8StringEncoding]autorelease];
                
                 PBLog(@"Transaction is %@",receipt);
                [self completeTransaction:transaction];
               
                break;
            case SKPaymentTransactionStateFailed:
                PBLog(@"A NEW TRANSACTION FAILED");
                NSString* receipt1 = [[[NSString alloc] initWithData:transaction.transactionReceipt
                                                           encoding:NSUTF8StringEncoding]autorelease];
                  PBLog(@"A NEW TRANSACTION FAILED .. IT IS %@",receipt1);
                [self failedTransaction:transaction];
               
                break;
            case SKPaymentTransactionStateRestored:
                
                PBLog(@"A NEW TRANSACTION RESTORED .. ");
                NSString* receipt2 = [[[NSString alloc] initWithData:transaction.transactionReceipt
                                                            encoding:NSUTF8StringEncoding]autorelease];
                PBLog(@"A NEW TRANSACTION RESTORED is %@",receipt2);
                [self restoreTransaction:transaction];
              
                
            default:
                break;
        }
    }
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}
- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    PBLog(@"Confirming Buying %@...", productIdentifier);
    SKPayment *payment = [SKPayment paymentWithProductIdentifier: productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}



- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

@end

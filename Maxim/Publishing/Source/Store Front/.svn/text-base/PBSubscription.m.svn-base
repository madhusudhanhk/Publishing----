//
//  PBSubscription.m
//  Publishing
//
//  Created by Nithin Abraham on 25/11/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBSubscription.h"
#import <QuartzCore/QuartzCore.h>

#define k3MonthSubscriptionButtonTag 777
#define k6MonthSubscriptionButtonTag 778
#define k12MonthSubscriptionButtonTag 779

#import "InAppRageIAPHelper.h"

@implementation PBSubscription
@synthesize subscriptionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




-(IBAction)userDidTap3MonthSubscription
{
    PBInAppHandler * p = [[[PBInAppHandler alloc]init]autorelease];
    [p buyProductIdentifier:@"com.picsean.inapprage.7days"];
    
}
-(IBAction)userDidTap6MonthSubscription
{
    PBInAppHandler * p = [[[PBInAppHandler alloc]init]autorelease];
    [p buyProductIdentifier:@"com.picsean.inapprage.7days"];
    
   
    

    
}
-(IBAction)userDidTap1YearSubscription
{
    PBInAppHandler * p = [[[PBInAppHandler alloc]init]autorelease];
    [p buyProductIdentifier:@"com.picsean.inapprage.7days"];
    

    
}
-(IBAction)restoreButtonTapped
{
     [[SKPaymentQueue defaultQueue]  restoreCompletedTransactions];
}


-(IBAction)cancel
{
    
    [self.view performSelector: @selector(removeFromSuperview) withObject: nil afterDelay: 0.2f];
    

}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *productIdentifier = (NSString *) notification.object;
    PBLog(@"Purchased: %@", productIdentifier);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.view performSelector: @selector(removeFromSuperview) withObject: nil afterDelay: 0.2f];

//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UIImage * signInBg = [[UIImage imageNamed: @"btn_normal.png"] stretchableImageWithLeftCapWidth: 355.0f  topCapHeight: 43.0f];
    UIImage * signInBg1 = [[UIImage imageNamed: @"btn_select.png"] stretchableImageWithLeftCapWidth: 355.0f  topCapHeight: 43.0f];
   
    UIButton * button = (UIButton *)[self.view viewWithTag: k3MonthSubscriptionButtonTag];
    [button setBackgroundImage: signInBg forState: UIControlStateNormal];
    [button setBackgroundImage: signInBg1 forState: UIControlStateSelected];
    [button setBackgroundImage: signInBg forState: UIControlStateHighlighted];
    
    
    UIButton * button1 = (UIButton *)[self.view viewWithTag: k6MonthSubscriptionButtonTag];
  
    
    [button1 setBackgroundImage: signInBg forState: UIControlStateNormal];
    [button1 setBackgroundImage: signInBg1 forState: UIControlStateSelected];
    [button1 setBackgroundImage: signInBg forState: UIControlStateHighlighted];
    
    UIButton * button2 = (UIButton *)[self.view viewWithTag: k12MonthSubscriptionButtonTag];
 
    
    [button2 setBackgroundImage: signInBg forState: UIControlStateNormal];
    [button2 setBackgroundImage: signInBg1 forState: UIControlStateSelected];
    [button2 setBackgroundImage: signInBg forState: UIControlStateHighlighted];
    
    UIButton * button3 = (UIButton *)[self.view viewWithTag: 780];
    
    
    [button3 setBackgroundImage: signInBg forState: UIControlStateNormal];
    [button3 setBackgroundImage: signInBg1 forState: UIControlStateSelected];
    [button3 setBackgroundImage: signInBg forState: UIControlStateHighlighted];
    


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

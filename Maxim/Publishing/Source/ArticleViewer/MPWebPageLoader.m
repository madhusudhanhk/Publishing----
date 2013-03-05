    //
//  MPFAQViewController.m
//  Metropolis
//
//  Created by Shuchi Jain  on 14/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MPWebPageLoader.h"


@implementation MPWebPageLoader

@synthesize indicator = _indicator;
@synthesize webView = _webView; 
@synthesize backBarButtonItem	=	_backBarButtonItem;
@synthesize forwardBarButtonItem	=	_forwardBarButtonItem;
@synthesize webURLStr = _webURLStr;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.backBarButtonItem.enabled		=	[self.webView canGoBack];
	self.forwardBarButtonItem.enabled	=	[self.webView canGoForward];

	
	self.indicator.hidesWhenStopped=YES;
	NSURL *webURL = [NSURL URLWithString:self.webURLStr];
	[self.webView loadRequest: [NSURLRequest requestWithURL:webURL]];
}


- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	self.indicator.center = self.view.center;
}

-(IBAction)backButtonTapped:(id)sender
{
	NSLog(@"back button tapped");
		if(self.webView.canGoBack)
	{
		[self.webView goBack];
	}
}

-(IBAction)forwardButtonTapped:(id)sender
{
	if ([self.webView canGoForward])
	{
		[self.webView goForward];
	}
}

-(IBAction)cancelButtonTapped:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
	 
- (void)webViewDidStartLoad:(UIWebView *)webview {
	
		 [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview 
{
	
	self.backBarButtonItem.enabled		=	[self.webView canGoBack];
	self.forwardBarButtonItem.enabled	=	[self.webView canGoForward];
	
	[self.indicator stopAnimating];
}

- (void) webView: (UIWebView *)webview didFailLoadWithError: (NSError *)error {
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
//													message: [error localizedDescription] 
//												   delegate: nil
//										  cancelButtonTitle: nil
//										  otherButtonTitles: @"OK",nil];
//	[alert show];
//	[alert release];
}
	 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	self.webView = nil;
	self.indicator = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[self.webView stopLoading];
	[self.webView setDelegate: nil];
	[self.webURLStr release];
	[self.webView release];
	
	[self.indicator release];
	self.backBarButtonItem = nil;
	self.forwardBarButtonItem= nil;
    [super dealloc];
}


@end

//
//  MPFAQViewController.h
//  Metropolis
//
//  Created by Shuchi Jain  on 14/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MPWebPageLoader : UIViewController {
	
	UIWebView * _webView;
	UIActivityIndicatorView * _indicator;
	UIBarButtonItem *_backBarButtonItem;
	UIBarButtonItem *_forwardBarButtonItem;
	
	NSString * _webURLStr;

}

@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * indicator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, retain) NSString * webURLStr;

-(IBAction)backButtonTapped:(id)sender;
-(IBAction)forwardButtonTapped:(id)sender;
-(IBAction)cancelButtonTapped:(id)sender;
@end

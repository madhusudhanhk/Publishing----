    //
//  FacebookController.m
//  ACKComicStore
//
//  Created by Madhusudhan  HK on 26/09/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "FacebookController.h"
#import "SBJSON.h"
#import "FbGraphFile.h"

@implementation FacebookController
@synthesize loginLbl;
@synthesize fbGraph;
@synthesize feedPostId;
@synthesize tweetTextField;
@synthesize loginbutton;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

#pragma mark - View lifecycle

- (void) dismissController {
    [self dismissModalViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Facebook", nil);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                           target: self action: @selector(dismissController)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)postMeFeedButtonPressed:(id)sender {
	
	if([sender isSelected]){
	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:4];
	
	[variables setObject:self.tweetTextField.text forKey:@"message"];
 	[variables setObject:@" http://www.picsean.com/en_img/picsean_logo.png" forKey:@"link"];
 	//[variables setObject:@"This is the bolded copy next to the image" forKey:@"name"];
 	//[variables setObject:@"This is the plain text copy next to the image.  All work and no play makes Jack a dull boy." forKey:@"description"];
	
	FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"me/feed" withPostVars:variables];
	NSLog(@"postMeFeedButtonPressed:  %@", fb_graph_response.htmlResponse);
	
	//parse our json
	SBJSON *parser = [[SBJSON alloc] init];
	NSDictionary *facebook_response = [parser objectWithString:fb_graph_response.htmlResponse error:nil];	
	[parser release];
	
	//let's save the 'id' Facebook gives us so we can delete it if the user presses the 'delete /me/feed button'
	self.feedPostId = (NSString *)[facebook_response objectForKey:@"id"];
	NSLog(@"feedPostId, %@", feedPostId);
	NSLog(@"Now log into Facebook and look at your profile...");
	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"successfully" message:@"Posted successfully  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self.tweetTextField resignFirstResponder]; 
	}else {
		/*Facebook Application ID*/
		NSString *client_id = @"165102030194084";
		
		//alloc and initalize our FbGraph instance
        FbGraph * graph = [[FbGraph alloc] initWithFbClientID: client_id];
		self.fbGraph = graph;
		
		//begin the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
		[graph release];
	}

	
}
- (void)viewDidAppear:(BOOL)animated {
	
	
	
		//[controller release];
		// [navController release]; 
	/*Facebook Application ID*/
	NSString *client_id = @"165102030194084";
	
	//alloc and initalize our FbGraph instance
    FbGraph * graph = [[FbGraph alloc] initWithFbClientID: client_id];

	self.fbGraph = graph;
	
	//begin the authentication process.....
	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
	
	
	
	/**
	 * OR you may wish to 'anchor' the login UIWebView to a window not at the root of your application...
	 * for example you may wish it to render/display inside a UITabBar view....
	 *
	 * Feel free to try both methods here, simply (un)comment out the appropriate one.....
	 **/
	//	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
    [graph release];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	[tweetTextField release];
	tweetTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[loginLbl release];
	if (feedPostId != nil) {
		[feedPostId release];
	}
	[fbGraph release];
    [super dealloc];
}


- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"successfully logedin " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[loginbutton setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
		//[loginbutton setTitle:@"post" forState:UIControlStateNormal];
		[loginbutton setSelected:YES];
		
		tweetTextField.hidden= NO;
		//NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
		
	}
	
}


@end

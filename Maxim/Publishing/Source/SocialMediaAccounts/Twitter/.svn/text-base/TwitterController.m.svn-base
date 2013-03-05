    //
//  TwitterController.m
//  ACKComicStore
//
//  Created by Madhusudhan  HK on 26/09/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "TwitterController.h"
#import "SA_OAuthTwitterEngine.h"


#define kOAuthConsumerKey				@"YwmhAa5xdrZuwUiC3x1GHw"		 
#define kOAuthConsumerSecret			@"HawRaAlxiEBK7Y7tyC8xDJHvtsuLFWqwOQ9qbqpEZyU"		

@implementation TwitterController
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

#pragma mark Custom Methods

-(IBAction)updateTwitter:(id)sender
{
	if([sender isSelected]){
        //Dismiss Keyboard
        [self.tweetTextField resignFirstResponder];
        
        //Twitter Integration Code Goes Here
        [_engine sendUpdate:[NSString stringWithFormat:@"%@   http://www.picsean.com",tweetTextField.text]];
	}else{
		// Twitter Initialization / Login Code Goes Here
		if(!_engine){  
			_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
			_engine.consumerKey    = kOAuthConsumerKey;  
			_engine.consumerSecret = kOAuthConsumerSecret;  
		}  	
		
		if(![_engine isAuthorized]){  
			UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
			
			if (controller){  
				UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: controller];
				navController.modalPresentationStyle = UIModalPresentationFormSheet;
				[self presentModalViewController: navController animated: YES];
				//[controller release];
                [navController release]; 
			}  
		}else{
			[loginbutton setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
			//[loginbutton setTitle:@"post" forState:UIControlStateNormal];
			[loginbutton setSelected:YES];
			
			tweetTextField.hidden= NO;
		}
	}
    
}


#pragma mark - View lifecycle

- (void) dismissController {
    [self dismissModalViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Twitter", nil);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                           target: self action: @selector(dismissController)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated {
	
	// Twitter Initialization / Login Code Goes Here
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
			UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: controller];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentModalViewController: navController animated: YES];
            //[controller release];
            // [navController release]; 
        }  
    }else{
		[loginbutton setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
		//[loginbutton setTitle:@"post" forState:UIControlStateNormal];
		[loginbutton setSelected:YES];
		
		tweetTextField.hidden= NO;
	}
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
}


- (void)dealloc {
	[_engine release];
	tweetTextField = nil;
    
    [super dealloc];
}


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


@end

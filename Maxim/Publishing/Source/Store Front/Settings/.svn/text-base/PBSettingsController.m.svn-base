//
//  PBSettingsController.m
//  Publishing
//
//  Created by Ganesh S on 10/17/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBSettingsController.h"
#import "PBAboutViewController.h"
#import "PBBookMark.h"

@implementation PBSettingsController

@synthesize delegate = _delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];

    if(self) {        
        _settingsList = [[NSArray alloc] initWithObjects: @"Bookmarks", 
                         @"Feedback", [NSString stringWithFormat: @"About %@", kAppName], nil];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [_settingsList release];
    [super dealloc];
}

- (CGSize) contentSizeForViewInPopover {
    return CGSizeMake(320.0f, [_settingsList count] * 70);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"StorePattern1.png"]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"StorePattern1.png"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_settingsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImageView * bgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"04box.png"]];
        cell.backgroundView = bgView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [bgView release];
    }
    
    cell.textLabel.text = [_settingsList objectAtIndex: indexPath.section];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [PBUtilities titleColor];

    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath: indexPath animated: 1];
    switch (indexPath.section) {
        
        case 0: 
        {
            /* Bookmarks Section */
            
            PBBookMark * bookMarkViewController = [[PBBookMark alloc] initWithNibName: @"PBBookMark" 
                                                                               bundle: nil];
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: bookMarkViewController];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            bookMarkViewController.delegate = _delegate;
            [_delegate presentModalViewController: navController animated: YES];
            [bookMarkViewController release];
            [navController release];
            [_delegate userDidChooseASetting];

            break;
        }
            
        case 1: 
        {
            /* Feedback Section */
        
            [self showPicker];
          //  [_delegate userDidChooseASetting];
           
            break;
        }

        case 2: 
        {
            /* About Section */

            PBAboutViewController * aboutViewController = [[PBAboutViewController alloc] initWithNibName: @"PBAboutViewController" 
                                                                                                  bundle: nil];
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: aboutViewController];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [_delegate presentModalViewController: navController animated: YES];
            [aboutViewController release];
            [navController release];
            [_delegate userDidChooseASetting];

            break;
        }

            
        default: 
        {
            
            break;
        }
    }

}

-(void)showPicker
{
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{                     
			[self displayComposerSheet];
		}
    
		else
		{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have to login first"
                                                            message:@"Want to quit app ?" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
		}
	}
	else
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have to login first" 
                                                        message:@"Want to quit app ?" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
	}
}

#pragma mark alertview

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self launchMailAppOnDevice];
    }
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	picker.visibleViewController.navigationController.navigationBar.tintColor=[UIColor clearColor];
	[picker setSubject:@"Hello from Publishing++ !"];
	    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 	
    
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = @"It is raining in Publishing++!";
	[picker setMessageBody:emailBody isHTML: NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
   
	[self dismissModalViewControllerAnimated:YES];
    [_delegate userDidChooseASetting];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com&subject=Hello from Publishing++!";
	NSString *body = @"&body=It is raining in Publishing++!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end

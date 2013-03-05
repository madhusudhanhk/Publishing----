//
//  PBArticleViewer.m
//  Publishing
//
//  Created by Ganesh S on 10/20/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBArticleViewer.h"
#import "FacebookController.h"
#import "TwitterController.h"
#import "PBOrientedTableView.h"
#import "ASIDownloadCache.h"
#import "PBDataCommunicator.h"
#import "ASINetworkQueue.h"
#import "PBArticle.h"
#import "PBIssue.h"
#import "PBArticleView.h"
#import "PBPageView.h"
#import "PBTocView.h"
#import "PBImageViewer.h"
#import "SBJSON.h"
#import "PBWebView.h"
#import "MPWebPageLoader.h"
#import "PBPageView.h"


#define TABLEVIEW_TAG 7832
#define ROTATED_CELL_VIEW_TAG 2348
#define CELL_CONTENT_TAG 2897
#define kWebViewOverlayTag 54978
#define kToolbarTag 87677
#define kWebArticleTag 23867
#define kAdPageTag 3789
#define kArticlePageTag 7723

@interface PBArticleViewer (Private)
- (void) addGestureToView;
- (PBArticle *) currentArticle;
- (void) downlodArticleDataFromArray: (NSArray *)inArticleInfo;
- (void) updateArticleNavigationStack;
- (void) triggerPageAnimation;
@end

#pragma mark -

@implementation PBArticleViewer

@synthesize bookMarkButton, rangeForNote = _rangeForNote;
@synthesize geastuerView, progress;
@synthesize pageDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil 
                           bundle: nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        if(!_queue) _queue = [[ASINetworkQueue alloc] init];
        if(!_pages) _pages = [NSMutableArray new];
        if(!_tocThumbUrlArray) _tocThumbUrlArray = [NSMutableArray new];
        if(!_navigationItems) _navigationItems = [NSMutableArray new];
    }
    
    return self;
}


+ (PBArticleViewer *) sharedInstance; {
    static PBArticleViewer * sharedInstance = nil;
    
    if(nil == sharedInstance)
        sharedInstance = [[PBArticleViewer alloc] initWithNibName: @"PBArticleViewer" bundle: nil];

    return sharedInstance;    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc {
    [_tocController release];
    [geastuerView release];
    [titleView release];
    [_tocThumbUrlArray release];
    [shareButtonItem release];
    [tocButtonItem release];
    [_searchItem release];
    [_tocHolderView release];
    [_searchHolder release];
    [_searchField release];
    [_articleNavigationItem release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [_pageView setTableViewOrientation: ePBTableViewOrientationHorizontal];
    _pageView.orientedTableViewDataSource = self;
    _pageView.delaysContentTouches = YES;
    _pageView.pagingEnabled = YES;
    [self addGestureToView];
    // adding arry to handle noteBook......
    
    [_noteViewHolder addSubview: noteViewContainer];
    noteViewContainer.center = _noteViewHolder.center;
    
      
         
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: YES];

    // hiding tool bar after 5 sec.........
    /*
    [[NSTimer scheduledTimerWithTimeInterval: 4 
                                      target: self 
                                    selector: @selector(hideControls) 
                                    userInfo: nil 
                                     repeats: NO] retain];
     */
    
}

- (void)viewDidUnload
{
    [titleView release];
    titleView = nil;
    [shareButtonItem release];
    shareButtonItem = nil;
    [tocButtonItem release];
    tocButtonItem = nil;
    [_searchItem release];
    _searchItem = nil;
    [_tocHolderView release];
    _tocHolderView = nil;
    [_searchHolder release];
    _searchHolder = nil;
    [_searchField release];
    _searchField = nil;
    [_articleNavigationItem release];
    _articleNavigationItem = nil;
    [super viewDidUnload];
}


- (void) setTitle: (NSString *)title {    
    [titleView setTitle: title forState: UIControlStateNormal];
    titleView.titleLabel.textColor = [PBUtilities titleColor];
    titleView.titleLabel.shadowColor = [PBUtilities titleShadowColor];
    titleView.titleLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size: 17];
    titleView.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
}

- (void) resetDataFields; {
    [[NSFileManager defaultManager] removeItemAtPath: [kNotesPath stringByExpandingTildeInPath] error: nil];
    if(_tocItems) [_tocItems removeAllObjects];
    if(_tocThumbUrlArray)[_tocThumbUrlArray removeAllObjects];
    if(_pages)[_pages removeAllObjects];
    [_pageView reloadData];

    if(_noteArry){
        [_noteArry release];
        _noteArry = nil;
    }
}

#pragma mark - 

- (void) addGestureToView {
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self 
                                                                                                 action: @selector(hideSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 2;  
    singleTapGestureRecognizer.delegate = self;
    
    [_pageView addGestureRecognizer: singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    
}


- (void) hideControls {
    for(UIToolbar *tBar in self.view.subviews) {
        if([tBar isKindOfClass:[UIToolbar class]]) {
            if(![tBar isHidden]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                tBar.alpha=0;
                tBar.hidden=YES;
                [UIView commitAnimations];
                
            } else {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                tBar.alpha=1;
                tBar.hidden=NO;
                [UIView commitAnimations];
            }
        }
    }
    
    [self updateBookMarkButton];    
}

- (void) updateBookMarkButton {     
    
    
    UIButton * bookmarkItem = (UIButton *)[bookMarkButton customView];
    
    NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
    NSMutableArray *  _bookMarkList = [[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]]; 
    
    for(int i = 0 ; i<[_bookMarkList count] ; i ++ ){
        
        NSArray *filtered = [_bookMarkList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(kBookMarkPageNumber == %@)", [NSNumber numberWithInt: row]]]; 
        
        
        
        if([filtered count]==0 ){
            [bookmarkItem setImage: [UIImage imageNamed:@"Bookmark_normal_.png"] forState: UIControlStateNormal];
            
        }else{
            [bookmarkItem setImage: [UIImage imageNamed:@"Bookmark_.png"] forState: UIControlStateNormal];
            
        }
    }    
    
    if([[[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]] count]==0){
        [bookmarkItem setImage: [UIImage imageNamed:@"Bookmark_normal_.png"] forState: UIControlStateNormal];
        
    }
}

-(void)hideNavigationBar{
    
    
    for(UIToolbar *tBar in self.view.subviews) {
        if([tBar isKindOfClass:[UIToolbar class]]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            tBar.alpha=1;
            tBar.hidden=YES;
            [UIView commitAnimations];
            
        }
    }
    
    //[self updateBookMarkButton];
}


/*
-(void)hideNavigationBar
{
   for(UIToolbar *tBar in self.view.subviews) {
        if([tBar isKindOfClass:[UIToolbar class]]) {
                           [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            tBar.alpha=1;
            tBar.hidden=YES;
            [UIView commitAnimations];
        
        }
    }    
}
*/

- (void) hideSingleTap: (UITapGestureRecognizer *)gesture {    

    // hiding toolbar of self.view.subview........
    if([gesture view] == _pageView)
        [self hideControls];
}

#pragma mark - IBActions

- (IBAction) shareButtonClicked:(id)sender
{
	//UIButton *butt=(UIButton *)sender;
    [sender setSelected:YES];
	//NSLog(@"navigation bar tag.....%d",butt.tag);
	//If the actionsheet is visible it is dismissed, if it not visible a new one is created.
	
    if ([popoverActionsheet isVisible]) {
        UIButton * bookmarkItem = (UIButton *)[shareButtonItem customView];
        [bookmarkItem setSelected:NO];

        [popoverActionsheet dismissWithClickedButtonIndex:[popoverActionsheet cancelButtonIndex] animated: YES];
        return;
    }
	
	popoverActionsheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Share on Facebook", @"Share on Twitter",@"Share by Email", nil];
		
	[popoverActionsheet showFromBarButtonItem: shareButtonItem
                                     animated: YES];
	
	//[popoverActionsheet showFromTabBar:bookMarkButton];
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
			[self launchMailAppOnDevice];
		}
	}
	else
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
	
//	[picker setSubject:@"Hello from Publishing++ !"];
			
	// Fill out the email body text
	NSString *emailBody = @"It is raining in Publishing++!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController: picker animated: YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    /*
     message.hidden = NO;
     // Notifies users about errors associated with the interface
     switch (result)
     {
     case MFMailComposeResultCancelled:
     message.text = @"Result: canceled";
     break;
     case MFMailComposeResultSaved:
     message.text = @"Result: saved";
     break;
     case MFMailComposeResultSent:
     message.text = @"Result: sent";
     break;
     case MFMailComposeResultFailed:
     message.text = @"Result: failed";
     break;
     default:
     message.text = @"Result: not sent";
     break;
     }
    */
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - UI Related

/*
- (IBAction) faceBookCall: (id)sender {
    
    UIBarButtonItem *butt=(UIBarButtonItem *)sender;
    if ([_popoverActionsheet isVisible]) {
		
        [_popoverActionsheet dismissWithClickedButtonIndex:[_popoverActionsheet cancelButtonIndex] animated:YES];
        return;
    }
	
	
	_popoverActionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter",@"Share by Email", nil];
	
	 [_popoverActionsheet showFromBarButtonItem:sender animated:YES];
	//[popoverActionsheet showFromRect:butt.frame inView:self.view animated: YES];
	
    
    /*
        // NSLog(@"caling faceBook Api..");
    FacebookController * facebookViewController = [[FacebookController alloc] initWithNibName: @"FacebookController" 
                                                                                       bundle: nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: facebookViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController: navController animated: YES];
    [facebookViewController release];
    [navController release];
    [self dismissModalViewControllerAnimated: 1];*/
//}

/*
- (IBAction) twitterCall: (id)sender {
    //NSLog(@"calling twitter Api..");
    TwitterController * twitterViewController = [[TwitterController alloc] initWithNibName: @"TwitterController" 
                                                                                    bundle: nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: twitterViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController: navController animated: YES];
    [twitterViewController release];
    [navController release];
    [self dismissModalViewControllerAnimated: 1];
    
}*/


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIButton * bookmarkItem = (UIButton *)[shareButtonItem customView];
    [bookmarkItem setSelected:NO];
    if (buttonIndex == [actionSheet cancelButtonIndex]) return;
	
    //add rest of the code for other button indeces
	
	if(buttonIndex==0){
		FacebookController * facebookViewController = [[FacebookController alloc] initWithNibName: @"FacebookController" 
                                                                                           bundle: nil];
		UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: facebookViewController];
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController: navController animated: YES];
		[facebookViewController release];
		[navController release];
		[self dismissModalViewControllerAnimated: 1];
        
	} if(buttonIndex==1){
		TwitterController * twitterViewController = [[TwitterController alloc] initWithNibName: @"TwitterController"
                                                                                        bundle: nil];
		UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: twitterViewController];
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController: navController animated: YES];
		[twitterViewController release];
		[navController release];
		[self dismissModalViewControllerAnimated: 1];
        
	} if(buttonIndex==2) {
        // NSLog(@"share by email.....%d",buttonIndex);
        [self showPicker];
    }
}



#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
//-(void)displayComposerSheet 
//{
//	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	picker.mailComposeDelegate = self;
//	
//	[picker setSubject:@"Hello from Publishing ++ !"];
//	
//    
//	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
//	
//	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];	
//	[picker setBccRecipients:bccRecipients];
//	
//	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"picsean_logo" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
//	
//	// Fill out the email body text
//	NSString *emailBody = @"It is raining in Publishing ++!";
//	[picker setMessageBody:emailBody isHTML:NO];
//	
//	[self presentModalViewController:picker animated:YES];
//    [picker release];
//}
//

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.

- (void) updateArticleNavigationStack
{
    if(_addNavigationItem) {
        
        if([_navigationItems count]) {
            if (![[_navigationItems lastObject] isEqual: [self currentArticle]])
                [_navigationItems addObject: [self currentArticle]];
        }
        
        else {
            [_navigationItems addObject: [self currentArticle]];   
        }
    }
    
    _addNavigationItem = 1;
    
}


- (void) showArticleWithIndex: (NSNumber *)inArticleIndex {
    
    //FIXME: Should be able to find article to be shown based on article-id 
    if([inArticleIndex intValue] < [_pages count]) {
        [_pageView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [inArticleIndex intValue]
                                                              inSection: 0]
                         atScrollPosition: UITableViewScrollPositionNone
                                 animated: NO]; 
       
        
    }

    [self triggerPageAnimation];
}


- (void) showArticleWithIndex: (NSNumber *)inArticleIndex pageNumber:(NSNumber *)inPageNumber {
    
    //FIXME: Should be able to find article to be shown based on article-id 
    if([inArticleIndex intValue] < [_pages count]) {
        [_pageView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [inArticleIndex intValue]
                                                              inSection: 0]
                         atScrollPosition: UITableViewScrollPositionNone
                                 animated: NO]; 
        [((PBArticleView *)[_pageView viewWithTag: kArticlePageTag])scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [inPageNumber intValue]-1
                                                                                                               inSection: 0]
                                                                          atScrollPosition: UITableViewScrollPositionNone
                                                                                  animated: NO];
        
    }
    
    [self triggerPageAnimation];
}

- (IBAction)showSearchField:(id)sender {
    
    if(!_customPopOverHolder) {
        _customPopOverHolder = [[UIButton alloc] initWithFrame: [[self.view window] bounds]];
        _customPopOverHolder.backgroundColor = [UIColor clearColor];
        [_customPopOverHolder addTarget: self action: @selector(dismissCustomPopOver:) forControlEvents: UIControlEventTouchUpInside];        
    }

    _searchField.text = nil;
    
    //    UIImageView * imageView = (UIImageView *)[_tocHolderView viewWithTag: 990];
    [_customPopOverHolder addSubview: _searchHolder];    
    _searchHolder.frame = CGRectMake(436.0f, 40.0f, 330.0f, 96.0f);
    [[self.view window] addSubview: _customPopOverHolder];
    [_customPopOverHolder release];
}

- (IBAction)showHelpField:(id)sender {
    
    
    
    [self.view addSubview:_helpHolder];
    /*
    
    if(!_customPopOverHolder) {
        _customPopOverHolder = [[UIButton alloc] initWithFrame: [[self.view window] bounds]];
        _customPopOverHolder.backgroundColor = [UIColor clearColor];
        [_customPopOverHolder addTarget: self action: @selector(dismissCustomPopOver:) forControlEvents: UIControlEventTouchUpInside];        
    }
    
  //  _searchField.text = nil;
    
    //    UIImageView * imageView = (UIImageView *)[_tocHolderView viewWithTag: 990];
    [_customPopOverHolder addSubview: _helpHolder];    
    _helpHolder.frame = CGRectMake(72.0f, 143.0f, 681.0f, 848.0f);
    [[self.view window] addSubview: _customPopOverHolder];
    [_customPopOverHolder release];*/
}

-(IBAction)removeHelpScreen
{
    [_helpHolder removeFromSuperview];
}

- (IBAction) navigateToPreviousPage: (id)sender {
    
    _addNavigationItem = NO;
    
    if([_navigationItems count])  {
        [self showArticleWithIndex: [NSNumber numberWithInt: [_pages indexOfObject: [_navigationItems lastObject]]]];
        [_navigationItems removeLastObject];
    }
            
    _articleNavigationItem.enabled = [_navigationItems count];    
}

- (void) dismissCustomPopOver: (id)inSender {
     UIButton * bookmarkItem = (UIButton *)[tocButtonItem customView];
    [bookmarkItem setSelected:NO];
    [[_tocHolderView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([_customPopOverHolder superview])
        [_customPopOverHolder removeFromSuperview];
    
    _customPopOverHolder = nil;
}

- (IBAction) tocCall: (id)sender {    
    [sender setSelected:YES];
    if(!_customPopOverHolder) {
        _customPopOverHolder = [[UIButton alloc] initWithFrame: [[self.view window] bounds]];
        _customPopOverHolder.backgroundColor = [UIColor clearColor];
        [_customPopOverHolder addTarget: self action: @selector(dismissCustomPopOver:) 
                       forControlEvents: UIControlEventTouchUpInside];        
    }
    
    if (!_tocController) {
        _tocController = [[PBTocView alloc] initWithNibName: @"PBTocView" bundle: nil];        
    }
    
    _tocController._tocImageArry = _tocThumbUrlArray;
    _tocController.delegate = self;        
     
    UIImageView * imageView = [[UIImageView alloc]initWithFrame: _tocHolderView.bounds];
    
//    UIImageView * imageView = (UIImageView *)[_tocHolderView viewWithTag: 990];
    UIImage * image = [UIImage imageNamed: @"Box.png"];
    imageView.image = [image stretchableImageWithLeftCapWidth: 0.0f topCapHeight: 79.0f];
    [_tocHolderView addSubview: _tocController.view];
    [_tocHolderView addSubview: imageView];
    [imageView release];
    _tocController.view.frame = CGRectMake(10.0f, 62.0f, 307.0f, 426.0f);
    [_customPopOverHolder addSubview: _tocHolderView];    
    CGRect rect = _tocHolderView.frame;
    rect.origin.y = 39.0f;
    _tocHolderView.frame = rect;
    
    [[self.view window] addSubview: _customPopOverHolder];
    [_customPopOverHolder release];
    
    /*
    if(nil == _popOverController) {
        
        PBTocView * tocView = [[PBTocView alloc] initWithNibName: @"PBTocView" bundle: nil];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: tocView];
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:navController];
      // tocView.delegate = self;
        tocView._tocImageArry=_tocThumbUrlArray;
        tocView.delegate = self;        
        _popOverController.delegate = self;
        _popOverController.passthroughViews = nil;
        [_popOverController presentPopoverFromBarButtonItem: tocButtonItem
                                   permittedArrowDirections: UIPopoverArrowDirectionAny 
                                                   animated: YES];
        
        [navController release];
        [tocView release];   
    } 
     */
    /*
    // Show article viewer 
    PBImageViewer * articleViewer = [[PBImageViewer alloc]initWithNibName:@"PBImageViewer" bundle:nil];
    
   // [articleViewer showArticlesForIssue: issue];
    [self.navigationController pushViewController: articleViewer animated: YES];
    [articleViewer release];
     */
    
}


-(IBAction)booMarkClicked:(id)sender{
    
    PBArticle *art;
    NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
    art=[_pages objectAtIndex:row];
    
    NSString *urlString = [art.thumbnailURL absoluteString];
    NSMutableDictionary *newScore = [[NSMutableDictionary alloc] init];
    [newScore setValue: art.title forKey:kBookMarkTitle];
    [newScore setValue: urlString forKey: kBookMarkImageUrl];
    //[newScore setValue: art.articleNumber forKey:kBookMarkPageNumber]; //TODO: replace with article identifier: row => art.articleNumber
    [newScore setValue: [NSNumber numberWithInt: row] forKey: kBookMarkPageNumber];
    [newScore setObject: _issue.editionId forKey: kIssueEditionIdKey];
    
    
    // tack existing BookMark data ......
    NSMutableArray *bookMarkArry ;
    
    if(![[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]]){
        
        bookMarkArry=[[NSMutableArray alloc]init];
        [bookMarkArry addObject:newScore];
        [newScore release];
    }else if([[[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]] count]==0){
        
        bookMarkArry=[[NSMutableArray alloc]init];
        [bookMarkArry addObject:newScore];
        [newScore release];
    }else{
        
        bookMarkArry=[[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]];
        int booMarkCount= [ bookMarkArry count];
        for (int i=0; i<booMarkCount; i++) {
            NSArray *filtered = [bookMarkArry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(kBookMarkPageNumber == %@)",
                                                                           [newScore  objectForKey:kBookMarkPageNumber]]]; 
            
            
            if([filtered count]==0 ){
                NSLog(@"it s not thr ......");
                [bookMarkArry addObject:newScore];
                [newScore release];
                
                break;
            }
            
            if(![filtered count]==0 && [[NSNumber numberWithInt:row] isEqualToNumber: [newScore  objectForKey:kBookMarkPageNumber]]){
                [bookMarkArry removeObject:newScore];
                break;
            }
            
            
        }
    }
    
    
    [bookMarkArry writeToFile:[kBookMarkPath stringByExpandingTildeInPath] atomically: YES];
    [bookMarkArry release];
    [self updateBookMarkButton];
   // [self hideNavigationBar];   
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController; {
    UIButton * bookmarkItem = (UIButton *)[shareButtonItem customView];
    [bookmarkItem setSelected:NO];
    [_popOverController release];
    _popOverController = nil;
}

- (IBAction) popToStoreFront: (id)sender {
    _addNavigationItem = 1;
    [_navigationItems removeAllObjects];
    [self.navigationController popViewControllerAnimated: YES];    
}

- (PBArticle *) currentArticle {
    NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
    return (row < [_pages count]) ? [_pages objectAtIndex: row] : nil;
}


- (void) updateArticleNavigation
{
    _articleNavigationItem.enabled = ( 0 != [_navigationItems count]);    
    PBLog(@"Items count = %d, status %d",[_navigationItems count], _articleNavigationItem.enabled);    
}


- (void) updateTitle {
    
//    UIToolbar * toolBar = (UIToolbar *)[[self view] viewWithTag: kToolbarTag];
//    NSMutableArray * toolBarItems = [NSMutableArray arrayWithArray: toolBar.items];
    UITextField * textField =  (UITextField *)_searchItem.customView;

    [textField setText: nil];
//    if([self currentArticle].type == ePBArticleTypeWebArticle) {
//        if(![toolBarItems indexOfObject: _searchItem])
//            [toolBarItems addObject: _searchItem];
//    }
//    else {
//        [toolBarItems removeObject: _searchItem];        
//    }
//    
//    [toolBar setItems: toolBarItems animated: 1];
    
    if([[_pageView visibleCells] count]) {
        self.title = [[self currentArticle] title];
    }    

    [self performSelector: @selector(updateArticleNavigation) 
               withObject: nil 
               afterDelay: 0.1f];
//    [self showPageHiglights];
}



- (void) showPageHiglights {
    
    UITableViewCell * currentCell = [[_pageView visibleCells] objectAtIndex: 0];
    PBArticle * article = [self currentArticle];
    
    if(article.type == ePBArticleTypeWebArticle) {
        
        PBWebView * webView = (PBWebView *)[currentCell viewWithTag: kWebArticleTag];
        // tack existing BookMark data ......
        
        NSMutableArray *articleArry = [self articleNotes];
        CGFloat yOffset = 50.0f;
        
        for (NSInteger index = 0; index < [articleArry count]; index++) {
            NSDictionary * selectionInfo = [articleArry objectAtIndex: index];
            if([[selectionInfo objectForKey: @"HighlightType"] intValue] == eNoteType) {
                // Text highlight with note
                
                UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
                [button setImage: [UIImage imageNamed: @"noteicon.png"] forState: UIControlStateNormal];
                [button addTarget: self 
                           action: @selector(showNoteEditor:)
                 forControlEvents:UIControlEventTouchDown];
                button.tag=index;
                [button setTitle: @"09/11/2011" forState: UIControlStateNormal]; //FIXME: @"09/11/2011" => [NSDate date] string representation
                button.frame = CGRectMake(700, yOffset, 50.0, 50);
                [webView addSubview: button];
                yOffset += 58.0f;
            }
            
            else {
                // Normal higlight
                [webView highlightRange: [selectionInfo objectForKey: @"TextRange"]];
            }
        }
    }
}

- (void) updateDownloadProgressForArticle: (PBArticle *)inArticle; {
/*
    if([[_pageView visibleCells] count]) {
    
        PBArticle * article = [self currentArticle];
        if((article == inArticle) && (ePBArticleTypeNormal == [article type])) {
            if([[[_pageView visibleCells] objectAtIndex: 0] respondsToSelector: @selector(updateProgressForArticle:)])
                [((PBPageView *)[[_pageView visibleCells] objectAtIndex: 0]) updateProgressForArticle: inArticle];
        }
    }    
 */
}


- (void)fetchURL:(NSURL *)url
{
//	[request setDelegate:nil];
//	[request cancel];
//	[self setRequest:[ASIWebPageRequest requestWithURL:url]];
//    
//	[request setDidFailSelector:@selector(webPageFetchFailed:)];
//	[request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
//	[request setDelegate:self];
//	[request setDownloadProgressDelegate:self];
//	[request setUrlReplacementMode:([replaceURLsSwitch isOn] ? ASIReplaceExternalResourcesWithData : 
//                                    ASIReplaceExternalResourcesWithLocalURLs)];
//	
//	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
//	[request setDownloadCache:[ASIDownloadCache sharedCache]];
//	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
//    
//	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
//	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
//	
//	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders: NO];
//	[request startAsynchronous];
}



#pragma mark - Downloader Related

- (ASIDownloadCache *) downloadCache; {
    return _downloadCache;
}

- (NSString *) cachePathForIssue: (PBIssue *)inIssue {
    return [NSString stringWithFormat: @"%@/%@", [@"~/Documents" stringByExpandingTildeInPath], inIssue.editionId];
}


- (NSString *) articleDetailsFile {
    return [[self cachePathForIssue: _issue] stringByAppendingPathComponent: @"ArticleInfo.plist"];
}

- (BOOL) shouldDownloadArticleList {
    return (NO == [[NSFileManager defaultManager] fileExistsAtPath: [self articleDetailsFile]]);
}



- (void) pauseDownloadForIssue: (PBIssue *)inIssue; {

    if(_issue == inIssue) {
        
        if(_issue.state == eIssueStateDownloading)
            _issue.state = eIssueStatePaused;

        [_queue cancelAllOperations];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kShouldReloadStoreCatalog 
                                                            object: nil];
    }
}

- (void) showArticlesForIssue: (PBIssue *)inIssue {    
    
    BOOL shouldTrigerDownload = NO;
    
    if (!_issue) {
        
        if ((inIssue.state == eIssueStatePaused) || (inIssue.state == eIssueStateDownload) || (inIssue.progress < 1.0f))
            shouldTrigerDownload = YES;

        else 
            {
            
            _issue = inIssue;

            if (inIssue.state == eIssueStateView) {

            }
            else {
                _issue.state = eIssueStateDownloading;
                _progressDelegate = inIssue;
                _issue.prepareForView = (_issue.progress == 0.0f);
            }
            
            [_pages removeAllObjects];
            [_pageView reloadData];
            if(_noteArry) [_noteArry removeAllObjects];
            
            // Handle download based on issue state
            if(!_downloadCache)
                _downloadCache = [[ASIDownloadCache alloc] init];
            
            _downloadCache.storagePath = [self cachePathForIssue: _issue];
            _downloadCache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
            _downloadCache.shouldRespectCacheControlHeaders = NO;  
            
            if ([self shouldDownloadArticleList]) {
                NSURL * url = [NSURL URLWithString: kBaseURL];
                PBDataCommunicator* request = [PBDataCommunicator requestWithURL: url serviceName: kIssueDetailsService];
                [request setArguments: [NSArray arrayWithObjects: kPubId, kMagId, kIssueId,  nil]]; //!-- TODO: @"1" > _issue.editionId
                [request startAsynchronous];
                [request setDelegate: self];
            }
            
            else {
                NSArray * articleInfo = [NSArray arrayWithContentsOfFile: [self articleDetailsFile]];
                [self downlodArticleDataFromArray: articleInfo];
            }
        }            
    }
    
    else if(_issue == inIssue) {
        
        if((_issue.state == eIssueStatePaused) || (_issue.state == eIssueStateDownload)) {
            _issue.state = eIssueStateDownloading;
            shouldTrigerDownload = YES;
        }
    }
    
    else if(_issue && (_issue != inIssue)) {
        
        // Pause current download 
        
        if(_issue.state == eIssueStateDownloading)
            _issue.state = eIssueStatePaused;
        
        shouldTrigerDownload = YES;
    }
    
    
    if(shouldTrigerDownload) {

        [_queue cancelAllOperations];

        _progressDelegate = inIssue;
        _issue = inIssue;
        _issue.state = eIssueStateDownloading;
        [_pages removeAllObjects];
        [_pageView reloadData];
        
        // Handle download based on issue state
        if(!_downloadCache)
            _downloadCache = [[ASIDownloadCache alloc] init];
        
        _downloadCache.storagePath = [self cachePathForIssue: _issue];
        _downloadCache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
        _downloadCache.shouldRespectCacheControlHeaders = NO;  
        
        _issue.prepareForView = (_issue.progress == 0.0f);
        
        if ([self shouldDownloadArticleList]) {
            NSURL * url = [NSURL URLWithString: kBaseURL];
            PBDataCommunicator* request = [PBDataCommunicator requestWithURL: url serviceName: kIssueDetailsService];
            [request setArguments: [NSArray arrayWithObjects: kPubId, kMagId, kIssueId,  nil]]; //!-- TODO: kIssueId > _issue.editionId
            [request startAsynchronous];
            [request setDelegate: self];
        }
        
        else if(_issue.state == eIssueStateView) {
            NSArray * articleInfo = [NSArray arrayWithContentsOfFile: [self articleDetailsFile]];
            [self downlodArticleDataFromArray: articleInfo];
        }
        
        else {
            NSArray * articleInfo = [NSArray arrayWithContentsOfFile: [self articleDetailsFile]];
            [self downlodArticleDataFromArray: articleInfo];
        }
        
    }
    else {
        //FIXME: handle case when no download is required 
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kShouldReloadStoreCatalog 
                                                        object: nil];
    _addNavigationItem = 1;
    [_pageView reloadData];
}

- (void) createNotesArray
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: [kNotesPath stringByExpandingTildeInPath]];
        // tack existing BookMark data ......
        if(fileExists) {

            if(_noteArry) { [_noteArry release]; _noteArry = nil; }
            
            _noteArry=[[NSMutableArray alloc] initWithContentsOfFile:[kNotesPath stringByExpandingTildeInPath]];
//            [_noteArry removeAllObjects];
        }   
        else {
            _noteArry=[[NSMutableArray alloc]init];
        
            for(int i = 0 ; i < [_pages count];i++){
                NSMutableArray * artArry= [[NSMutableArray alloc]init];
                [_noteArry addObject:artArry];
                [artArry release];
            }
        }
        
        [_noteArry writeToFile: [kNotesPath stringByExpandingTildeInPath] atomically: YES];
}
    

- (void) downlodArticleDataFromArray: (NSArray *)inIssueDetails
{
    
//  _queue.showAccurateProgress = YES; // Not preferred for downloading many files with small size
    NSAutoreleasePool * pool = [NSAutoreleasePool new];

    [_queue cancelAllOperations];
    
    [_queue setDownloadProgressDelegate: _issue];
    [_queue setShouldCancelAllRequestsOnFailure: NO];
    [_queue setDelegate: _issue];
    
    
    [_queue setQueueDidFinishSelector: @selector(queueComplete:)];

    for (NSDictionary * articleInfo in inIssueDetails) {
        
        
        PBArticle * article = [[PBArticle alloc] initWithDictionary: articleInfo];  
        
        if(ePBArticleTypeNormal == article.type) {

            for (PBArticlePage * page in [article pages]) {
                [_queue addOperation: [page requestForDownloadingPageContentWithCache: _downloadCache]];
                if ([page overlayDownloadRequests]) {
                    for (ASIHTTPRequest * req in [page overlayDownloadRequests]) {
                        [_queue addOperation: req];
                    }
                }
//                    [_queue addOperations: [page overlayDownloadRequests] waitUntilFinished: NO];
            }

            // Add thumbnail download request to queue
            ASIHTTPRequest  * request = [ASIHTTPRequest requestWithURL: article.thumbnailURL];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            request.downloadCache = [ASIDownloadCache sharedCache];
            [_tocThumbUrlArray addObject:article];
            [_queue addOperation: request];
        }
        
        else if(ePBArticleTypeWebArticle == article.type)  {
                        
            // Add thumbnail download request to queue
            ASIHTTPRequest  * request = [ASIHTTPRequest requestWithURL: article.thumbnailURL];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            request.downloadCache = [ASIDownloadCache sharedCache];
            [_tocThumbUrlArray addObject: article];
            [_queue addOperation: request];
        }
        
        [_pages addObject: article];
    }
    
    [_queue go];    
    [pool drain];    
    
    [self createNotesArray];    
}

- (void) requestFinished: (PBDataCommunicator *)request 
{
    NSDictionary * articleListInfo = [request responseDictionary];
    NSArray * pageList = [[articleListInfo objectForKey: @"result"] objectForKey: @"buckets"];
    PBLog(@"%@", [request responseString]);
    if(pageList) {
        [pageList writeToFile: [self articleDetailsFile] atomically: YES];
        [self downlodArticleDataFromArray: pageList];
    }
}

- (void) requestFailed: (PBDataCommunicator *)request 
{
    
}


#pragma mark - TableView Delegate Methods


- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return  [_pages count];
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath  {
    return self.view.frame.size.width;
}


- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {

    static NSString * imageCellIdentifier = @"PBPageCell";
    static NSString * webCellIdentifier = @"PBWebCell";
    static NSString * webArticleCell = @"PBWebArticle";

    PBArticle * article = [_pages objectAtIndex: indexPath.row];
    UITableViewCell *cell = nil;
    
    if([article type] == ePBArticleTypeNormal) {
        cell = [tableView dequeueReusableCellWithIdentifier: imageCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                           reuseIdentifier: imageCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        PBArticleView * pageView = (PBArticleView *)[cell.contentView viewWithTag: kArticlePageTag];

        if(!pageView) {        
            pageView = [[PBArticleView alloc] initWithFrame: self.view.bounds];
            pageView.pagesList = article.pages;
            [cell.contentView addSubview: pageView];
            pageView.tag = kArticlePageTag;
            pageView.delegate = pageView;
            pageView.dataSource = pageView;
            pageView.backgroundColor = [UIColor whiteColor];
            [pageView release];
        }
        pageView.pagesList = nil;
        [pageView reloadData];
        pageView.pagesList = article.pages;
        [pageView reloadData];
    }
    
    else if ([article type] == ePBArticleTypeAd) {
        cell = [tableView dequeueReusableCellWithIdentifier: webCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                           reuseIdentifier: webCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
       // UIWebView * webView = (UIWebView *)[cell.contentView viewWithTag: 3789];
        
       // if(!webView) {        
           UIWebView * webView = [[UIWebView alloc] initWithFrame: self.view.bounds];
            //[[[webView subviews] lastObject] setScrollingEnabled: NO];
            [cell.contentView addSubview: webView];
            webView.delegate = nil;
            webView.tag = 3789;        
            [webView release];
       // }
        if([webView isLoading]) [webView stopLoading];
        [webView loadHTMLString: @"<html><head></head><body bgcolor=#FFFFFF></body></html>" baseURL: nil];
        webView.delegate = nil;
        [webView loadHTMLString: @"<html><head></head><body bgcolor=#FFFFFF></body></html>" baseURL: nil];
        [webView loadRequest: [NSURLRequest requestWithURL: article.adURL]];
    }
   
    else {
        cell = [tableView dequeueReusableCellWithIdentifier: webArticleCell];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                           reuseIdentifier: webArticleCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [[cell.contentView viewWithTag: kWebArticleTag] removeFromSuperview];
        
//        PBWebView * webView = (PBWebView *)[cell.contentView viewWithTag: kWebArticleTag];
//        if(!webView) {
          PBWebView *  webView = [[PBWebView alloc] initWithFrame: self.view.bounds];
      //    [[[webView subviews] lastObject] setScrollingEnabled: NO];
            [cell.contentView addSubview: webView];
            webView.delegate = self;
            webView._delegate=self;
            webView.tag = kWebArticleTag;
            webView.scalesPageToFit = 1;
            [webView release];
//      }
//      [webView addNoteButton:indexPath.row];
        if([webView isLoading]) [webView stopLoading];
        webView.delegate = self;
        if([webView isLoading]) [webView stopLoading];
        
        if([article offlineContent]) {
//            [webView loadHTMLString: [article offlineContent] baseURL: nil];
            NSURL * url = [NSURL fileURLWithPath: [_downloadCache pathToCachedResponseDataForURL: article.adURL]];
            webView.delegate = self;
            [webView loadRequest: [NSURLRequest requestWithURL: url]];
        }
        else {
            webView.delegate = self;
            [webView loadHTMLString: @"<HTML><BODY><center><div style=\"width:768px; height:1024; margin-top:500px;\"><H4>Loading…</H4><center></div></BODY></HTML>" baseURL: nil];
//            [webView loadRequest: [NSURLRequest requestWithURL: article.adURL]];
        }

    }
    
    [self performSelector: @selector(updateTitle) withObject: nil afterDelay: 0.02f]; 
    
  [self performSelector: @selector(hideNavigationBar) withObject: nil afterDelay: 0]; 
    
    return cell;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
}

- (void) tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath; {
    [self performSelector: @selector(triggerPageAnimation) withObject: nil afterDelay: 0.01];
    
    if([pageDelegate respondsToSelector: @selector(autoplayMethod)]) {
        [pageDelegate autoplayMethod];
    }
}


    

#pragma mark - Scrollview Delegates

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate; {
//    PBLog(@" ");
//}

- (void) triggerPageAnimation {
    
    NSArray * cells = [_pageView visibleCells];
    // NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
   // NSLog(@"visible cell counts in Article View.....%d",row);
    if([cells count]) {
        [(PBArticleView *)[[cells objectAtIndex: 0] viewWithTag: kArticlePageTag] triggerPageAnimation];
    }
}


- (void) scrollViewDidEndDecelerating: (UIScrollView *)scrollView; {
    
    [self updateArticleNavigationStack];
    [self performSelector: @selector(updateArticleNavigation) 
               withObject: nil 
               afterDelay: 0.1f];
     NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
    [self reloadRowAtSection:row];
   
}

- (void)reloadRowAtSection:(int)rowitem {
    NSLog(@"Row item ......%d",rowitem);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowitem inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [_pageView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [indexPaths release];
    
    
}


#pragma mark - UITextField 

- (IBAction) clearTextHighlight:(id)sender {
    
    NSArray * cells = [_pageView visibleCells];
    
    if ([cells count]) {
        PBWebView* webView  = (PBWebView*)[[(UITableViewCell *)[cells objectAtIndex: 0] contentView] viewWithTag: kWebArticleTag];
        [webView removeAllHighlights];
    }    
}

- (void) hilightWebview: (UITextField *)textField {
    
    if ([textField.text length] && [_pageView visibleCells]) {
        
        NSArray * cells = [_pageView visibleCells];
        
        for (UITableViewCell * cell in cells) {
            PBWebView* webView  = (PBWebView*)[[cell contentView] viewWithTag: kWebArticleTag];
            [webView highlightAllOccurencesOfString: textField.text];
        }
    }
    
    else {
        [self clearTextHighlight: nil];
    }
}

- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range 
 replacementString: (NSString *)string; {
    //    [self performSelector: @selector(hilightWebview:) withObject: textField afterDelay: 0.1];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.text != nil) {
        
        if ([textField.text length] && [_pageView visibleCells]) {
            
            NSArray * cells = [_pageView visibleCells];
            for (UITableViewCell * cell in cells) {
                PBWebView* webView  = (PBWebView*)[[cell contentView] viewWithTag: kWebArticleTag];
                [webView highlightAllOccurencesOfString: textField.text];
            }
        }
        else {
            [self clearTextHighlight: nil];
        }
    }
    
    else {
        [self clearTextHighlight: nil];
    }
    
    [textField resignFirstResponder];
    return YES;    
}




#pragma mark PBWebView Delegate 

- (NSMutableArray *) notes {
    if(!_noteArry) {
        _noteArry = [[NSMutableArray alloc]initWithContentsOfFile: [@"~/Documents/NoteBook.plist" stringByExpandingTildeInPath]];
    }
    return _noteArry;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView; {
    if([[[_pageView visibleCells] objectAtIndex: 0] viewWithTag: kWebArticleTag] == webView)
        [self showPageHiglights];
}

- (BOOL) webView: (UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request
  navigationType: (UIWebViewNavigationType)navigationType; {

    if(navigationType == UIWebViewNavigationTypeLinkClicked) {

        if([[[request URL] scheme] isEqualToString: @"mailto"]) {
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
          
            if (mailClass != nil) {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail]) {
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    picker.mailComposeDelegate = self;
                    
                    // Set up recipients
                    [picker setToRecipients: [NSArray arrayWithObject: [[request URL] resourceSpecifier]]];
                    
                    // Fill out the email body text
                    [self presentModalViewController: picker animated: YES];
                    [picker release];
                }
                
                else{
                    [[UIApplication sharedApplication] openURL:[request URL]];
                }
            }
            
            else {
                [[UIApplication sharedApplication] openURL:[request URL]];
            }
            
            return NO;        
        }

        else if([[[request URL] scheme] isEqualToString: @"http"]) {
            
            if([@"picsean.com" isEqualToString: [[request URL] host]]) return YES;

            MPWebPageLoader * webLoader = [[MPWebPageLoader alloc] initWithNibName: @"MPWebViewDisplay" 
                                                                            bundle: nil];
            webLoader.webURLStr = [[request URL] absoluteString];
            [self presentModalViewController: webLoader animated: YES];
            [webLoader release];
            return NO;        
        }
        
        return YES;        
    }
    return YES;
}

- (void) showWebpageWithURL: (NSString *)inURLString; {
    
    MPWebPageLoader * webLoader = [[MPWebPageLoader alloc] initWithNibName: @"MPWebViewDisplay" 
                                                                    bundle: nil];
    webLoader.webURLStr = inURLString;
    [self presentModalViewController: webLoader animated: YES];
    [webLoader release];
}

- (NSMutableArray *) articleNotes {
    NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];
    return  (row < [[self notes] count]) ? [[self notes] objectAtIndex: row] : nil;
}

- (void) saveNotes {
    [[self notes] writeToFile: [@"~/Documents/NoteBook.plist" stringByExpandingTildeInPath] 
                   atomically: YES];
}

- (void) saveHiglightForPage: (NSString *)range {
    
    //PBArticle * article = [self currentArticle];
    
    // tack existing BookMark data ......
    
    NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];

    NSMutableArray *articleArry=  [self articleNotes];
    NSMutableDictionary *newScore = [[NSMutableDictionary alloc] init];
    [newScore setObject:[NSNumber numberWithInt: row] forKey:@"ArticleIndex"];
    [newScore setObject:[NSNumber numberWithInt: eHighlightType] forKey:@"HighlightType"]; 
    [newScore setObject: range forKey: @"TextRange"];
    [articleArry addObject:newScore];
    
    [self saveNotes];
}


- (void) showNoteEditor: (UIButton *)inSender {
    
    _noteInfo = [[self articleNotes] objectAtIndex: [inSender tag]];
    _isNewNote = NO;
 
    noteView.text = [_noteInfo objectForKey: @"Note"];
    [[self.view window] addSubview: _noteViewHolder];    
}


- (IBAction)removeNote:(id)sender {
    
    [noteView resignFirstResponder];
    
    if([[noteView text] length]) {
        
        // Save note required for the selected page
        if(_isNewNote) {
            NSInteger row = [[_pageView indexPathForCell: [[_pageView visibleCells] objectAtIndex: 0]] row];        
            
            NSMutableArray *articleArry=  [self articleNotes];
            NSMutableDictionary *newScore = [[NSMutableDictionary alloc] init];
            [newScore setObject:[NSNumber numberWithInt: row] forKey:@"ArticleIndex"];
            [newScore setObject:[noteView text] forKey: @"Note"];
            [newScore setObject:[NSNumber numberWithInt: eNoteType] forKey:@"HighlightType"]; 
            if(self.rangeForNote)
                [newScore setObject: self.rangeForNote forKey: @"TextRange"];
            [articleArry addObject:newScore];
            [newScore release];

        }
        else {
            [_noteInfo setObject: [noteView text] forKey: @"Note"];
        }        
        
        [self saveNotes];
        [_pageView reloadData];
    }    
    
    if([_noteViewHolder superview])
        [_noteViewHolder removeFromSuperview];
    
}


- (void) showNoteEditorForTextSelection: (NSString *)selectedText {
    noteView.text = @"";
    _isNewNote = YES;
    self.rangeForNote = selectedText;
    [[self.view window] addSubview: _noteViewHolder];    
    [noteView performSelector: @selector(becomeFirstResponder) withObject: nil afterDelay: 0.1f];
}

- (void) showNotePage: (NSString *)selectedText {
    noteView.text = selectedText;
    [[self.view window] addSubview: _noteViewHolder];    
    //[noteView performSelector: @selector(becomeFirstResponder) withObject: nil afterDelay: 0.1f];
}


- (void) dismissPopover {
   
    [_popOverController release];
    _popOverController = nil;

}

- (void) navigateToArticle: (PBArticle *)article {
    
    [self showArticleWithIndex: [NSNumber numberWithInt: [_pages indexOfObject: article]]];
    
    [_popOverController dismissPopoverAnimated: NO];
    [self dismissCustomPopOver:nil];
    
    [self performSelector: @selector(dismissPopover) withObject: nil afterDelay: 0.5f];
    [self updateArticleNavigationStack];
}


@end

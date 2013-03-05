//
//  PublishingViewController.m
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBStoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PBStoreItemCell.h"
#import "ASIDownloadCache.h"
#import "PublishingAppDelegate.h"
#import "PBSettingsController.h"
#import "PBOtherMagazien.h"
#import "PBSignInPage.h"
#import "PBArticleViewer.h"
#import "PBDataCommunicator.h"
#import "PBOrientedTableView.h"
#import "PBIssue.h"
#import "JSON.h"
#import "PBIssuePreviewController.h"
#import "PBInAppHandler.h"
#import "PBSubscription.h"
#import "PBInAppHandler.h"


#define kStoreFrontAdBannerTag 977


@interface PBStoreViewController (Private)
- (void) setupTopBarControls;
- (NSMutableArray *) getCatalogItems;
- (void) handleIssueThumbnailDownload: (NSNotification *)inNotification;
-(void)otherMagzeinDetailToFie:(NSMutableArray *)_otherMagzeinList;
@end

@implementation PBStoreViewController

@synthesize catalogView = _catalogView;
@synthesize hud = _hud;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _availableIssues = [self getCatalogItems];
        if(!_availableIssues) _availableIssues = [NSMutableArray new];
        if(!_otherMagzeinList) _otherMagzeinList = [NSMutableArray new];
    }
    return self;
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self setupTopBarControls];
    
    _downloadCache = [[ASIDownloadCache alloc] init];
    _downloadCache.storagePath = [@"~/Documents" stringByExpandingTildeInPath];
            
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleIssueThumbnailDownload:) 
                                                 name: kShouldReloadStoreCatalog
                                               object: nil];

//    self.catalogView.separatorColor = [UIColor darkTextColor];
    
    
    //in app purchasing changes made below
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(productsLoaded:) 
                                                 name:kProductsLoadedNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(productPurchased:) 
                                                 name:kProductPurchasedNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector: @selector(productPurchaseFailed:) 
                                                 name:kProductPurchaseFailedNotification 
                                               object: nil];

    

        
}

#pragma mark - In App Purchasing

- (void)productsLoaded:(NSNotification *)notification {
    // can load the information from the product identifier to the store front
    //PBLog(@"product identifiers can be displayed" );
 //   PBLog(@"%i",[[InAppRageIAPHelper sharedHelper].products count]);
    
    
}
- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  //  NSString *productIdentifier = (NSString *) notification.object;
    //PBLog(@"Purchased: %@", productIdentifier);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    for (PBIssue *issue in _availableIssues)
        issue.state = eIssueStateDownload;
    [_catalogView reloadData];   
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}



- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_catalogView release];
    _catalogView = nil;
    [_topBar release];
    _topBar = nil;
    [_downloadCache release];
    _downloadCache = nil;
    _signInItem = nil;
    _titleItem = nil;
    [_settingsHolder release];
    _settingsHolder = nil;
    [super viewDidUnload];
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];
    [[UIApplication sharedApplication] setStatusBarHidden: NO withAnimation: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self saveCatalogItems];
    [_otherMagzeinList release];
    [_availableIssues release];
    [_downloadCache release];
    _downloadCache = nil;
    [_catalogView release];
    [_topBar release];
    [_settingsHolder release];
    [super dealloc];
}


#pragma mark - Catalog Loading

- (void) checkForNewIssues; {
    
    NSURL * url = [NSURL URLWithString: kBaseURL];
    PBDataCommunicator* request = [PBDataCommunicator requestWithURL: url serviceName: kCatalogService];
    [request setArguments: [NSArray arrayWithObjects: kPubId, kMagId,  nil]]; 
    
    [request setDelegate: self];
    [request startAsynchronous];
}

- (NSString *) catalogPath {
    return [kCatalogFilePath stringByExpandingTildeInPath];    
}

- (void) saveCatalogItems; {
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (PBIssue *issue in _availableIssues) {
        [array addObject: [issue dictionaryRepresentation]];
    }
    
    [array writeToFile: [self catalogPath] atomically: YES];    
}

- (void) otherMagzeinDetailToFie: (NSMutableArray *)_otherMagzein {
    
    [_otherMagzein writeToFile: [kOtherMagzeinDocumentryPath stringByExpandingTildeInPath]
                    atomically: YES];    
}

- (NSMutableArray *) getCatalogItems {
    
    if(NO == [[NSFileManager defaultManager] fileExistsAtPath: [self catalogPath]]) 
        return nil;
    
    NSArray * array = [NSArray arrayWithContentsOfFile: [self catalogPath]];
    
    NSMutableArray * issueList = [NSMutableArray new];
    for (NSDictionary * dic  in array) {
        PBIssue * issue = [[PBIssue alloc]initWithDictionary: dic];
        [issueList addObject: issue];
        [issue release];
    }
    
    return issueList;
}


#pragma mark - UI Related


- (void) beautifyStoreFrontAdBanner
{
    UIView * aView = [self.catalogView viewWithTag: kStoreFrontAdBannerTag];
    aView.layer.cornerRadius = 12.0f;
    aView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent: 0.37f] CGColor];
//    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    aView.layer.shadowOpacity = 0.55f;
//    aView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    aView.layer.shadowRadius = 1.0f;
//    aView.layer.borderWidth = 1.5f;
}


- (UIBarButtonItem *) buttonItemWithTitle: (NSString *)title 
                                    image: (NSString *)inImageName 
                            selectedImage: (NSString *)inSelectedImage 
                                 selector: (SEL)inSelector {
    
    UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    if(title) {
        [button setTitle: title forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    }
    
    UIImage * image = [UIImage imageNamed: inImageName];
    [button setBackgroundImage: image
                      forState: UIControlStateNormal];
    [button setBackgroundImage: [UIImage imageNamed: inSelectedImage]
                      forState: UIControlStateSelected];
    [button setBackgroundImage: [UIImage imageNamed: inSelectedImage]
                      forState: UIControlStateHighlighted];
    
    [button addTarget: self action: inSelector forControlEvents: UIControlEventTouchUpInside];
    [button sizeToFit];

//    CGRect frame = button.frame;
//    frame.size.height = 31.0f;
//    button.frame = frame;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView: button];
    
    return item;
}

- (UILabel *) labelWithString: (NSString *)inString {
    
    UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 400.0f, 31.0f)];
    label.text = inString;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [PBUtilities titleColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize: 17.0f];
    label.userInteractionEnabled = YES;
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    return label;
}

- (void) setupTopBarControls; {
    
    _signInItem = [self buttonItemWithTitle: nil
                                      image: @"SignIn.png"
                              selectedImage: @"SignIn_Selected.png"
                                   selector: @selector(userDidTapSignInItem:)];
    
    _titleItem = [[UIBarButtonItem alloc] initWithCustomView: [self labelWithString: kAppName]];
    _titleItem.target = nil;
    _titleItem.action = nil;
    
    _subscriptionItem = [self buttonItemWithTitle: nil
                                            image: @"Subscribe_normal (1).png"
                                    selectedImage: @"Subscribe_pressed (1).png"
                                         selector: @selector(showSubscriptionOptions:)];
    

    
//    _otherMagz = [self buttonItemWithTitle: NSLocalizedString( @"Other Magazines", nil)
//                                     image: nil
//                             selectedImage: nil
//                                  selector: @selector(userDidTapViewOtherMagazines:)];
    
    _settingItem = [self buttonItemWithTitle: nil
                                       image: @"setting_normal_.png"
                               selectedImage: @"setting_pressed_.png"
                                    selector: @selector(userDidTapSettings:)];
    
    UIBarButtonItem * flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                        target: nil 
                                                                                        action: nil];
    [_topBar setItems: [NSArray arrayWithObjects:  
                        _subscriptionItem, flexibleSpaceItem, 
                        _titleItem, flexibleSpaceItem, _settingItem, 
                        nil] 
             animated: NO];
    
    
    [flexibleSpaceItem release];
    [_signInItem release];
    [_titleItem release];
//    [_otherMagz release];
    [_settingItem release];
    [_subscriptionItem release];
    
#if __IPHONE_5_0
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 ) {
        [_topBar setBackgroundImage: [UIImage imageNamed: @"ToolBarBg_5.0.png"]
                 forToolbarPosition: UIToolbarPositionTop
                         barMetrics: UIBarMetricsDefault];
        [_topBar setNeedsLayout];        
    }
#endif
    
}

- (void) viewIssue: (id)inSender {
    
    PBIssue * issue = [_availableIssues objectAtIndex: [inSender tag]];
    
    if([issue state] == eIssueStateBuy) {
        // Launch preview screen
        
        PBIssuePreviewController * issuePreviewController = [[PBIssuePreviewController alloc] initWithNibName: @"PBIssuePreviewController" 
                                                                                              bundle: nil];
         issuePreviewController._previewImageUrlArry=issue.issuePreviewArry;
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: issuePreviewController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController: navController animated: YES];
        [issuePreviewController release];
        [navController release];
    }
    
    else {
        // Show article viewer 
        PBArticleViewer * articleViewer = [PBArticleViewer sharedInstance];
        [articleViewer showArticlesForIssue: issue];
        [self.navigationController pushViewController: articleViewer animated: YES];
    }
}


- (void) purchaseOrViewIssue: (id)inSender {
        
    PBIssue * issue = [_availableIssues objectAtIndex: [inSender tag]];

    switch (issue.state) {
            
        case eIssueStateBuy: {
            // Initiate payment process through Apple In-app purchase
            
            /*
            PBInAppHandler * p = [[[PBInAppHandler alloc]init]autorelease];
            [p buyProductIdentifier: [issue productId]];
            self.hud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
//            issue.state = eIssueStateDownload;
            [_catalogView reloadData];
            break;
             */
            issue.state = eIssueStateDownload;
            [_catalogView reloadData];
            break ;
        }

        case eIssueStateDownload: {
            // Initiate download process
            issue.prepareForView = YES;
            PBArticleViewer * articleViewer = [PBArticleViewer sharedInstance];
            [articleViewer showArticlesForIssue: issue];
            issue.state = eIssueStateDownloading;
            [_catalogView reloadData];
            break;
        }
            
        case eIssueStateDownloading: {
            // Pause  
            [[PBArticleViewer sharedInstance] pauseDownloadForIssue: issue];
            break;
        }            
            
        case eIssueStatePaused: {
            // Resume issue download process
            issue.prepareForView = YES;
            PBArticleViewer * articleViewer = [PBArticleViewer sharedInstance];
            [articleViewer showArticlesForIssue: issue];
            issue.state = eIssueStateDownloading;
            [_catalogView reloadData];
            break;
        }
            
        case eIssueStateView: {
            // Archive feature
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle: kAppName
                                                             message: [NSString stringWithFormat: @"Are you sure want to archive the contents of %@, %@-%@ issue", issue.title, issue.month, issue.year]
                                                            delegate: self
                                                   cancelButtonTitle: NSLocalizedString(@"Archive", nil)
                                                   otherButtonTitles: NSLocalizedString(@"Cancel", nil), nil];
            alert.tag = [inSender tag];
            [alert show];
            [alert release];
            break;
        }        
    }

    [self saveCatalogItems];
    /*
    PBArticleViewer * articleViewer = [[PBArticleViewer alloc] initWithNibName: @"PBArticleViewer" bundle: nil];
    [self.navigationController pushViewController: articleViewer animated: YES];
    [articleViewer release];
     */
}


#pragma mark - Toolbar Actions

- (void) userDidTapSignInItem: (id)inSender {
    /* 
     * Present Sign-In or User registration screen 
     * If user is already logged-in, present sign-out, view account options
     */
    
   // PBLog(@"%s", _cmd);
    static PBSignInPage * signController = nil;

    if (!signController) {
         signController = [[PBSignInPage alloc] initWithNibName: @"PBSignInPage" bundle: nil];
    }

    [self.view addSubview: signController.view];

 //   [signController presentLoginScreen];
    
}
- (void)showSubscriptionOptions:(id)inSender {
   // PBLog(@"%s", _cmd);

    static PBSubscription * subscriptionController = nil;
    
    if (!subscriptionController) {
        subscriptionController = [[PBSubscription alloc] initWithNibName: @"PBSubscription" bundle: nil];
    }
    
    [self.view addSubview: subscriptionController.view];
    //  [subscriptionController presentLoginScreen];
    
    
    
}

- (void) userDidTapViewOtherMagazines: (id)inSender {
    /*
     * Show popover with other magazines listed in tableview
     */
    //PBLog(@"%s", _cmd);
    
    if(nil == _popOverController) {
        
        PBOtherMagazien * OtherMagazien = [[PBOtherMagazien alloc] initWithNibName: @"PBOtherMagazien" bundle: nil];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: OtherMagazien];
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:navController];
        // OtherMagazien.delegate = self;
        _popOverController.delegate = self;
        
        _popOverController.passthroughViews = nil;
        [_popOverController presentPopoverFromBarButtonItem: _otherMagz
                                   permittedArrowDirections: UIPopoverArrowDirectionAny 
                                                   animated: YES];
        
        [navController release];
        [OtherMagazien release];   
    }   

    
}

#pragma mark - Settings Related

- (void) bookmark: (PBBookMark *)bookmarkController didChooseBookmarkItem: (NSDictionary *)inDetails {
    
    [inDetails retain];
    [bookmarkController dismissModalViewControllerAnimated: YES];

    for (PBIssue * issue in _availableIssues) {
        if ([[issue editionId] isEqualToString: [inDetails objectForKey: kIssueEditionIdKey]]) {
            PBArticleViewer * articleViewer = [PBArticleViewer sharedInstance];
            [articleViewer showArticlesForIssue: issue];
            [self.navigationController pushViewController: articleViewer animated: NO];
            [articleViewer performSelector: @selector(showArticleWithIndex:) withObject: [inDetails objectForKey: kBookMarkPageNumber]
                                afterDelay: 0.5f];
        }   
    }
    [inDetails release];
}


- (void) dismissCustomPopOver: (id)inSender {
    UIButton * bookmarkItem = (UIButton *)[_settingItem customView];
    [bookmarkItem setSelected:NO];
    [[_settingsHolder subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if([_customPopOverHolder superview])
        [_customPopOverHolder removeFromSuperview];
    
    _customPopOverHolder = nil;
}


- (void) userDidTapSettings: (UIBarButtonItem *)inItem {
    
    /*
     * Show app settings screen as pop over
     */
  //  UIButton * bookmarkItem = (UIButton *)[inItem customView];
  //  [inItem setSelected:YES];
   
    
   // PBLog(@"%s", _cmd);
    
    //    _settingsController
    if(!_customPopOverHolder) {
        _customPopOverHolder = [[UIButton alloc] initWithFrame: [[self.view window] bounds]];
        _customPopOverHolder.backgroundColor = [UIColor clearColor];
        [_customPopOverHolder addTarget: self 
                                 action: @selector(dismissCustomPopOver:) 
                       forControlEvents: UIControlEventTouchUpInside];        
    }
    
    if (!_settingsController) {
        _settingsController = [[PBSettingsController alloc] initWithNibName: @"PBSettingsController" 
                                                                     bundle: nil];        
    }
    
    _settingsController.delegate = self;        
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame: _settingsHolder.bounds];
    
//  UIImageView * imageView = (UIImageView *)[_tocHolderView viewWithTag: 990];
    UIImage * image = [UIImage imageNamed: @"SettingsTVBG.png"];
    imageView.image = [image stretchableImageWithLeftCapWidth: 0.0f topCapHeight: 79.0f];
    [_settingsHolder addSubview: _settingsController.view];
    [_settingsHolder addSubview: imageView];
    [imageView release];
    
    _settingsController.view.frame = CGRectMake(10.0f, 60.0f, 310.0f, 200.0f);
    [_customPopOverHolder addSubview: _settingsHolder];    
    
    _settingsHolder.frame = CGRectMake(436.0f, 58.0f, 330.0f, 280.0f);;
    _settingsHolder.clipsToBounds = 1;
    
    UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake( 10.0f, 25.0f,  290.0f, 31.0f)];
    label.textColor = [PBUtilities titleColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize: 17.0f];
    label.text = NSLocalizedString(@"Settings", nil);
    [_settingsHolder addSubview: label];
    [label release];
    
    [[self.view window] addSubview: _customPopOverHolder];
    [_customPopOverHolder release];

    /*    
    
    if(nil == _popOverController) {
        
        PBSettingsController * settingsController = [[PBSettingsController alloc] initWithNibName: @"PBSettingsController" bundle: nil];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: settingsController];
        _popOverController = [[UIPopoverController alloc] initWithContentViewController:navController];
        settingsController.delegate = self;
        _popOverController.delegate = self;
        _popOverController.passthroughViews = nil;
        [_popOverController presentPopoverFromBarButtonItem: _settingItem
                                   permittedArrowDirections: UIPopoverArrowDirectionAny 
                                                   animated: YES];
        
        [navController release];
        [settingsController release];
    }        
    */
}

- (void) userDidChooseASetting {
    
    [self dismissCustomPopOver: nil];
    [_popOverController dismissPopoverAnimated: 1];
    [_popOverController release];
    _popOverController = nil;
        
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController; {
    [_popOverController release];
    _popOverController = nil;
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger count = [_availableIssues count]/2;
    count += ([_availableIssues count]%2);
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"PBStoreItemCell";
	
    PBStoreItemCell *cell = (PBStoreItemCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PBStoreItemCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass: [UITableViewCell class]]) {
				cell =  (PBStoreItemCell *) currentObject;

				break;
			}
		}
	}
     
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger index = indexPath.row * 2;
    
    if(index < [_availableIssues count]) {
        
        PBIssue * cellData = [_availableIssues objectAtIndex: index];
        [cell setupCellDetailsForFirstItem: cellData];
        [cell.holderView1.buyOrViewButton setTag: index];
        [cell.holderView1.buyOrViewButton addTarget: self 
                                             action: @selector(purchaseOrViewIssue:) 
                                   forControlEvents: UIControlEventTouchUpInside];
        
        [cell.holderView1.viewButton setTag: index];
        [cell.holderView1.viewButton addTarget: self 
                                             action: @selector(viewIssue:) 
                                   forControlEvents: UIControlEventTouchUpInside];

        
        if((index + 1) < [_availableIssues count]) {
            PBIssue * cellData = [_availableIssues objectAtIndex: index+1];;
            [cell setupCellDetailsForSecondItem: cellData];
            [cell.holderView2.buyOrViewButton setTag: index+1];
            [cell.holderView2.buyOrViewButton addTarget: self 
                                                 action: @selector(purchaseOrViewIssue:) 
                                       forControlEvents: UIControlEventTouchUpInside];
            
            [cell.holderView2.viewButton setTag: index+1];
            [cell.holderView2.viewButton addTarget: self 
                                            action: @selector(viewIssue:) 
                                  forControlEvents: UIControlEventTouchUpInside];

        }
        else
            cell.holderView2.hidden = YES;
    }
    
//    cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.17f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    <#NextViewController#> *nextViewController = [[<#NextViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // Configure the new view controller.

    [self.navigationController pushViewController:nextViewController animated:YES];
    [nextViewController release];
     */
}

#pragma mark - ASIHttp Delegates

- (void) requestFinished: (PBDataCommunicator *)request
{
//    NSString *responseString = [request responseString];
  
    NSDictionary * catalogDataAsDict = [[request responseString] JSONValue]; 
    
   // PBLog(@"Response Data %@", catalogDataAsDict);
    
    
    NSDictionary * resultDictionary = [catalogDataAsDict objectForKey: @"result"];

    
    if(_availableIssues) {
        
        NSArray * buckets = [resultDictionary objectForKey: @"buckets"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary * bucketDic in buckets) {
            
            BOOL contains = NO;
            for (PBIssue * issue in _availableIssues) {
                if([[bucketDic objectForKey: kIssueEditionIdKey] isEqualToString: issue.editionId]) {
                    contains = YES;
                }
            }
            
            if(!contains)  {                
                NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary: bucketDic];
                [dictionary setObject: [NSNumber numberWithInt: eIssueStateBuy] forKey: kIssueStateKey];
                [dictionary setObject: [NSNumber numberWithBool: NO] forKey: kIsIssueDownloadPaused];            
                [dictionary setObject: [NSNumber numberWithFloat: 0.0f] forKey: kIssueDownloadProgress];
                PBIssue * issue = [[PBIssue alloc] initWithDictionary: dictionary];
                [array addObject: issue];
                [issue release];
            }
        }
        
        [_availableIssues addObjectsFromArray: array];
    } 
    
    else {
        
        NSMutableArray  * arrry = [[resultDictionary objectForKey: @"buckets"] mutableCopy];
        
        for (NSMutableDictionary * dictionary in arrry) {
            
            [dictionary setObject: [NSNumber numberWithInt: eIssueStateBuy] forKey: kIssueStateKey];
            [dictionary setObject: [NSNumber numberWithBool: NO] forKey: kIsIssueDownloadPaused];            
            [dictionary setObject: [NSNumber numberWithFloat: 0.0f] forKey: kIssueDownloadProgress];            
            PBIssue * issue = [[PBIssue alloc] initWithDictionary: dictionary];
            [_availableIssues addObject: issue];
            [issue release];
        }
        [arrry release];
    }
    
 //   PBLog(@"_availableIssues = %@", _availableIssues);
    
    if(_otherMagzeinList) {
        [_otherMagzeinList addObjectsFromArray: [resultDictionary objectForKey: @"other-magazines"]];        
        [self otherMagzeinDetailToFie:(NSMutableArray *)_otherMagzeinList];
    }  
    
    [self.catalogView reloadData];
    [self saveCatalogItems];    
    [self beautifyStoreFrontAdBanner];
    
    [[PBInAppHandler sharedHandler] getPurchasedProductsList: _availableIssues];
    
    [(PublishingAppDelegate *)[UIApplication sharedApplication].delegate dismissSplashScreen];
}


- (void)requestFailed:(PBDataCommunicator *)request
{
    //NSError *error = [request error];
    [self beautifyStoreFrontAdBanner];
  //  PBLog(@"Could not fetch issues from server.ERROR %@", [error localizedDescription]);
    [(PublishingAppDelegate *)[UIApplication sharedApplication].delegate dismissSplashScreen];
}


#pragma mark - Notification Handling

- (void) handleIssueThumbnailDownload: (NSNotification *)inNotification
{
//    PBIssue * issue = [inNotification object];    
    [self.catalogView reloadData];
}

#pragma mark - UIAlertView Delegate

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex; {

    if([NSLocalizedString(@"Archive", nil) isEqualToString: [alertView buttonTitleAtIndex: buttonIndex]]) {
        // Delete cached content for article
        
        PBIssue * issue = [_availableIssues objectAtIndex: [alertView tag]];
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        BOOL directory = YES;
        NSString * cachePath = [NSString stringWithFormat: @"%@/%@", [@"~/Documents" stringByExpandingTildeInPath], issue.editionId];
        BOOL success = [fileManager fileExistsAtPath: cachePath
                                         isDirectory: &directory];        
        if (success) {
            success = [fileManager removeItemAtPath: cachePath error: nil];
            issue.state = eIssueStateDownload;
            [issue resetProgress];
            [self saveCatalogItems];
            [_catalogView reloadData];
            [[PBArticleViewer sharedInstance] resetDataFields];
            
            if([fileManager fileExistsAtPath:[kBookMarkPath stringByExpandingTildeInPath]]) 
                [fileManager removeItemAtPath: [kBookMarkPath stringByExpandingTildeInPath] error: nil];
            
            //TODO: Delete all bookmark details related to deleted issue
            
            if(success) {
             //   PBLog (@"Deleted cache for issue <%@>", [issue description]);
            }
        }
        
    }
}

@end

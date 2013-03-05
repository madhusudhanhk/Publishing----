//
//  PublishingViewController.h
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBBookMark.h"
#import "MBProgressHUD.h"

@class ASIDownloadCache;
@class PBSettingsController;

@interface PBStoreViewController : UIViewController <UIPopoverControllerDelegate, PBBookMarkDelegate> {
    
    UITableView         *_catalogView;
    IBOutlet UIToolbar  *_topBar;
    
    UIBarButtonItem     * _signInItem, * _titleItem, *_otherMagz, *_settingItem,*_subscriptionItem;    
    NSMutableArray      * _availableIssues;
    NSMutableArray      *_otherMagzeinList;
    UIPopoverController * _popOverController;
    
    ASIDownloadCache    * _downloadCache;
    PBSettingsController * _settingsController;

    IBOutlet UIView *_settingsHolder;
    UIButton * _customPopOverHolder;
    MBProgressHUD *_hud;  // in app change
}

@property (nonatomic, retain) IBOutlet UITableView  *catalogView;
@property (retain) MBProgressHUD *hud;

- (void) checkForNewIssues;

- (void) saveCatalogItems; 
- (void) userDidChooseASetting;

@end

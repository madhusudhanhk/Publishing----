//
//  PBSettingsController.h
//  Publishing
//
//  Created by Ganesh S on 10/17/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MessageUI/MFMailComposeViewController.h>
@interface PBSettingsController : UITableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    NSArray * _settingsList;
    __weak id _delegate;
}

@property (assign) id delegate;
-(void)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end

//
//  PublishingAppDelegate.h
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFileLogger.h"
@class PBStoreViewController;

@interface PublishingAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *_navController;
    UIImageView *_splashScreen;
    DDFileLogger *fileLogger;
     NSMutableData *responseData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PBStoreViewController *viewController;

- (void) dismissSplashScreen;

- (void) saveCatalogItems;
-(void)creatAnalyticsFile;
-(void)checkforupdatedTime;
-(void)checkNetworkReachability;
-(void)postDataToServer;


@end

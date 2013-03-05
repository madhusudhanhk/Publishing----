//
//  PublishingAppDelegate.m
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PublishingAppDelegate.h"
#import "PBStoreViewController.h"
#import "PBArticleViewer.h"
#import "PBInAppHandler.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "Reachability.h"
//#import "UIDevice+IdentifierAddition.h"

#define kAPNSToken @"APNS Token"
#define SHOW_DEVICE_TOKEN 1

@implementation PublishingAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    _navController = [[UINavigationController alloc] initWithRootViewController: self.viewController];
    _navController.navigationBarHidden = YES;
    [self.window addSubview: _navController.view];        
    
    /* Add splash screen to application window */
    _splashScreen = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Default" ofType: @"png"]]];
    [self.window addSubview: _splashScreen];
    _splashScreen.center = CGPointMake(_splashScreen.center.x, _splashScreen.center.y+20);
    [_splashScreen release];
    
    [self.window makeKeyAndVisible]; // Present application window 
    
    [self.viewController performSelector: @selector(checkForNewIssues) 
                              withObject: nil 
                              afterDelay: 1.0f];
    
//    PBInAppHandler  *observer = [[[PBInAppHandler alloc] init]autorelease];
    [[SKPaymentQueue defaultQueue] addTransactionObserver: [PBInAppHandler sharedHandler]];
    
    NSData *devToken = [[NSUserDefaults standardUserDefaults] valueForKey: kAPNSToken];
	
	if (!devToken || [devToken length] == 0) {
		// Haven't gotten devToken yet
		if([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
			//PBLog(@"registerForRemoteNotificationTypes..........................");
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | 
																				   UIRemoteNotificationTypeSound |
																				   UIRemoteNotificationTypeAlert)];
        }
	}
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // we'll also use a file logger
    fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];


    /*
     
     NSLog(@"uniqueIdentifier: %@", [[UIDevice currentDevice] uniqueIdentifier]);
     NSLog(@"name: %@", [[UIDevice currentDevice] name]);
     NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
     NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
     NSLog(@"model: %@", [[UIDevice currentDevice] model]);
     NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
     
     */
    [self creatAnalyticsFile];
    
   
    return YES;
}

-(void)creatAnalyticsFile{
   
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: [kAnalyticsPath  stringByExpandingTildeInPath]];
    
    if(fileExists) {
        
        // file already exists ......
        
    }else{
        
        NSMutableArray * analyticsArry = [[NSMutableArray alloc]init];
        [analyticsArry writeToFile:[kAnalyticsPath  stringByExpandingTildeInPath]  atomically:YES];
        [analyticsArry release];
    }
     
}

- (void) application: (UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)devToken
{
	if (devToken && [devToken length] > 0) {
        
		NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
		NSString *devTokenHex = [devToken description];
		NSLog(@"devTokenHex ===== %@",devTokenHex);
		NSMutableString *token = [NSMutableString stringWithCapacity:64];
        
		for (int i = 0 ; i < [devTokenHex length]; i++) {
			unichar ch = [devTokenHex characterAtIndex:i];
            
			if(!(ch == '<' || ch == '>' || ch==' ')) {
				[token appendString:[NSString stringWithFormat:@"%c", ch]];
            }
        }
		
		[settings setValue:token forKey: kAPNSToken];
		[settings synchronize];
        
#if SHOW_DEVICE_TOKEN
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device Token"
														message:token
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
#endif
        //	[[APNSHandler handler] setDevToken:token];
	}
	
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken THE DEVICE TOKEN IS %@", devToken);
}

- (void) application: (UIApplication *)app didFailToRegisterForRemoteNotificationsWithError: (NSError *)err
{
    NSLog(@"Error in registering to APNS Server. Error: %@", [err localizedDescription]);
}


- (void) application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {    
    
    if(application.applicationState  == UIApplicationStateActive) {
        // Application is foreground.
        // No need not to show the alert, simply upgrade the store catalog in background        
        [self.viewController checkForNewIssues];
        return;
    }
    
    if (userInfo != nil && [userInfo count] > 0) {
        
        /* 
         NSDictionary *aps = [userInfo objectForKey:@"aps"];
         NSObject *alert = [aps valueForKey:@"alert"];
         if (alert) {
            if ([alert isKindOfClass:[NSString class]])
            notification.alertBody = (NSString *)alert;
            else if ([alert isKindOfClass:[NSDictionary class]]) {
                notification.alertBody = [(NSDictionary *)alert objectForKey:@"body"]; 
            }
         }
         notification.badgeNumber = [(NSNumber *)[aps valueForKey:@"badge"] intValue];
         notification.soundFile=[aps objectForKey:@"sound"];
        */

        // [[APNSHandler handler] processNotification:[APNSHandler notificationWithUserInfo:userInfo didLaunchApplication: NO]];
    }

}

- (void) application:(UIApplication *)application didReceiveLocalNotification: (UILocalNotification *)notification {
    // We are not implementing local notification for current version
}



- (void) dismissSplashScreen {
    
    if([_splashScreen superview]) {
    
        // Removing splash screen with fade animation
        [UIView animateWithDuration: 1.0f
                              delay: 0.1f
                            options: UIViewAnimationCurveLinear
                         animations:^{	
                             _splashScreen.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) { [_splashScreen removeFromSuperview]; _splashScreen = nil;}];   
    }
}

- (void) saveCatalogItems; {
    [self.viewController saveCatalogItems];
}
- (void)checkforupdatedTime {	
        
    NSString *lastPostTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastPostedTime];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (lastPostTime && ![lastPostTime isEqualToString:@""]) {
        
        /*
        NSDate *now = [[NSDate alloc] init];
        NSDate *lastModifyDate = [timeFormat dateFromString:lastPostTime];
        NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:lastModifyDate];
        
       // NSInteger hours = distanceBetweenDates / 3600;
        
        [now release];
        
        */
       //  if(hours > 0){
        [NSThread detachNewThreadSelector:@selector(checkNetworkReachability) toTarget:self withObject:nil];
       // }
        
        
        
        
        
        
        
    }else{
        
        [NSThread detachNewThreadSelector:@selector(checkNetworkReachability) toTarget:self withObject:nil];
        NSDate *now = [[NSDate alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:[timeFormat stringFromDate:now] forKey:kLastPostedTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [now release];
        
    }
    
    [timeFormat release];
    
   
}
-(void)checkNetworkReachability{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];   
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];    
    if (networkStatus == NotReachable) {        
        NSLog(@"There IS NO internet connection");    
       
    } else {        
        
        NSLog(@"There IS internet connection"); 
        // [self postDataToServer];
       // [ NSThread detachNewThreadSelector: @selector( postDataToServer ) toTarget: self withObject: nil ];
        
        
    }        

    
}

-(void)postDataToServer{
   
    responseData = [[NSMutableData data] retain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest 
									requestWithURL:[NSURL URLWithString:@"http://192.168.1.3/iosupload.php"]];
    
 // NSString *params = [[NSString alloc] initWithFormat:];
   // NSString *params = [[NSString alloc] initWithFormat:];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"upload=TRUE&my_file=%@",[self description]]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
   
}

-(NSString *)description{
    
    NSMutableArray *analyticsArry = [[NSMutableArray alloc]initWithContentsOfFile:[kAnalyticsPath stringByExpandingTildeInPath]];
    NSString *postString = [[NSString alloc]init];
    
    for(int i = 0 ; i < [analyticsArry count] ; i ++){
        
        postString = [ postString stringByAppendingString:[analyticsArry objectAtIndex:i]];
        
    }
    [postString release];
    return postString;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"didReciveData....%@",newStr);
    [newStr release];
    newStr=nil;
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveCatalogItems];

    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self saveCatalogItems];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
   // [self checkforupdatedTime];
   // [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(checkNetworkReachability) userInfo:nil repeats:YES];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [self saveCatalogItems];
}

- (void)dealloc
{
    [self.viewController saveCatalogItems];
    [_window release];
    [_navController release];
    [_viewController release];
    [super dealloc];
}

@end

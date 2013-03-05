//
//  FacebookController.h
//  ACKComicStore
//
//  Created by Madhusudhan  HK on 26/09/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"

@interface FacebookController : UIViewController<UIWebViewDelegate> {
NSString *feedPostId;
	IBOutlet UITextField *tweetTextField;
	UILabel *loginLbl;
	UIButton *loginbutton; 
}
@property(nonatomic,retain)IBOutlet UIButton *loginbutton;
@property(nonatomic,retain)IBOutlet UILabel *loginLbl;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;

@property(nonatomic, retain) IBOutlet UITextField *tweetTextField;
-(IBAction)postMeFeedButtonPressed:(id)sender;

@end

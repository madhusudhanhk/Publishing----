//
//  TwitterController.h
//  ACKComicStore
//
//  Created by Madhusudhan  HK on 26/09/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@interface TwitterController : UIViewController<UITextFieldDelegate, SA_OAuthTwitterControllerDelegate> {

	IBOutlet UITextField *tweetTextField;
	SA_OAuthTwitterEngine *_engine;
    UIButton *loginbutton; 
    
}
@property(nonatomic, retain) IBOutlet UITextField *tweetTextField;
@property(nonatomic,retain)IBOutlet UIButton *loginbutton;
-(IBAction)updateTwitter:(id)sender;
@end

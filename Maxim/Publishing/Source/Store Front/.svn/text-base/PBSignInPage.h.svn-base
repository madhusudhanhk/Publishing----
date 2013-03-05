//
//  PBSignInPage.h
//  Publishing
//
//  Created by Nithin Abraham on 19/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBSignInPage : UIViewController <UITextFieldDelegate> {
    
    UIView * signView;
    UITextField * username;
    UITextField * password;
    UIActivityIndicatorView *myact;
    BOOL _loginScreenDidPopOut;
}


@property(nonatomic,retain)IBOutlet UIView * signView;
@property(nonatomic,retain)IBOutlet UITextField * username;
@property(nonatomic,retain)IBOutlet UITextField * password;

- (IBAction) signInCloseFunc;
- (IBAction) signInFunc;

- (void) presentLoginScreen;

@end

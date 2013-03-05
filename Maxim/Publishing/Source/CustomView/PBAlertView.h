//
//  PBActivityAlertView.h
//  Publishing
//
//  Created by Nithin Abraham on 24/11/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBAlertView : UIAlertView {
    UIActivityIndicatorView *activityView;
    
}
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) close;
@end

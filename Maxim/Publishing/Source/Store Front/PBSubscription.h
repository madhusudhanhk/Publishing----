//
//  PBSubscription.h
//  Publishing
//
//  Created by Nithin Abraham on 25/11/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBSubscription : UIViewController {
    IBOutlet UIView * subscriptionView; 
    BOOL _subscriptionScreenDidPopOut;
}
@property(nonatomic,retain)IBOutlet UIView * subscriptionView;
-(IBAction)userDidTap3MonthSubscription;
-(IBAction)userDidTap6MonthSubscription;
-(IBAction)userDidTap1YearSubscription;
-(IBAction)restoreButtonTapped;



@end

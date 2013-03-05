//
//  PBOthermagazienCustomCell.h
//  Publishing
//
//  Created by Madhusudhan  HK on 18/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBOthermagazienCustomCell : UITableViewCell {
    
    
    UILabel *otherAppName;
    UIImageView *otherAppImage;
    UILabel *otherAppDiscription;

    
}
@property(nonatomic,retain)IBOutlet UILabel *otherAppName;
@property(nonatomic,retain)IBOutlet UILabel *otherAppDiscription;
@property(nonatomic,retain)IBOutlet UIImageView *otherAppImage;

@end

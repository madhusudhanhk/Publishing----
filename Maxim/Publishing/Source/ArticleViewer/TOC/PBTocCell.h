//
//  PBTocCell.h
//  Publishing
//
//  Created by Madhusudhan  HK on 25/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PBTocCell : UITableViewCell {
 
    
    UIImageView *  _articleThumbImage;
    UILabel     *  _articleTitle;
    
}
@property(nonatomic,retain)IBOutlet  UIImageView *  _articleThumbImage;
@property(nonatomic,retain)IBOutlet  UILabel     *  _articleTitle;

@end

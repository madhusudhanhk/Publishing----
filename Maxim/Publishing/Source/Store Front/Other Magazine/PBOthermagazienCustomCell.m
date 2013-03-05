//
//  PBOthermagazienCustomCell.m
//  Publishing
//
//  Created by Madhusudhan  HK on 18/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBOthermagazienCustomCell.h"


@implementation PBOthermagazienCustomCell


@synthesize otherAppName,otherAppImage,otherAppDiscription;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{   
    [otherAppDiscription release];
    [otherAppName release];
    [otherAppImage release];
    [super dealloc];
}

@end

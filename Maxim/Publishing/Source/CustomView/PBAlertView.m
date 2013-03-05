//
//  PBActivityAlertView.m
//  Publishing
//
//  Created by Nithin Abraham on 24/11/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBAlertView.h"


@implementation PBAlertView
@synthesize activityView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[activityView startAnimating];
    }
	
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc
{
    [activityView release];
    [super dealloc];
    
}

@end

//
//  PBToolBarAdditions.m
//  Publishing
//
//  Created by Ganesh S on 10/17/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBToolBarAdditions.h"
#define ToolBarBGTag 1789

@implementation PBToolBarAdditions

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end


@implementation UIToolbar (PBAdditions)

- (void) layoutSubviews {
        
#if __IPHONE_5_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 ) {
        [self setBackgroundImage: [UIImage imageNamed:@"tab_barnew.png"]
              forToolbarPosition: UIToolbarPositionTop
                      barMetrics: UIBarMetricsDefault];
        return;
    }
#endif
    
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    UIImageView *imageView = (UIImageView *)[self viewWithTag: ToolBarBGTag];
    if(!imageView) {
        imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"tab_barnew.png"]];
        imageView.tag = ToolBarBGTag;
        [imageView sizeToFit];
        [self addSubview: imageView];
        [imageView release];
    }
    [self sendSubviewToBack: imageView];
}

- (void) drawRect: (CGRect)rect {
    
    [super drawRect: rect];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 ) return;
    

    [[UIColor clearColor] setFill];
    UIRectFill(rect);
}

@end

//
//  PBUtilities.m
//  Publishing
//
//  Created by Ganesh S on 10/18/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBUtilities.h"

@implementation PBUtilities

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}


+ (NSString *) stringWithRandomUUID
{
        // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
        // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}

+ (UIColor *) titleColor {
    return [UIColor colorWithRed:0.769 green:0.778 blue:0.778 alpha:1.000];
}

+ (UIColor *) titleShadowColor; {
    return [UIColor colorWithWhite:0.123 alpha:1.000];
}

@end

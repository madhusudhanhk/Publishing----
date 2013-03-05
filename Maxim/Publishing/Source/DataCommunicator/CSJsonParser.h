//
//  MPJsonParser.h
//  Metropolis
//
//  Created by Ganesh S on 12/28/10.
//  Copyright 2010 mPortal Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSJsonParser : NSObject {
	id _delegate;
	NSThread * parsingThread;
}

+ (CSJsonParser *) sharedParser;

- (void) parseData: (NSData*)data delegate: (id)delegate;

@end

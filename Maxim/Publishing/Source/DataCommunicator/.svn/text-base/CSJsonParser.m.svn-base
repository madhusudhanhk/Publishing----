//
//  MPJsonParser.m
//  Metropolis
//
//  Created by Ganesh S on 12/28/10.
//  Copyright 2010 mPortal Inc. All rights reserved.
//

#import "CSJsonParser.h"
#import "JSON.h"

static CSJsonParser * sharedParser = nil;

@implementation CSJsonParser

+ (CSJsonParser *) sharedParser 
{
    @synchronized(self) {
        if (sharedParser == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedParser;
}


+ (id) allocWithZone: (NSZone *)zone 
{
    @synchronized(self) {
        if (sharedParser == nil) {
            sharedParser = [super allocWithZone:zone];
            return sharedParser;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id) init 
{
	if (self = [super init]) {
	}
	return self;
}

- (NSUInteger) retainCount
{
	return NSIntegerMax;
}

- (void) release
{
	//!-- Do nothing as this class is Singleton
}

#pragma mark -

- (void)parseData:(NSData*)data delegate:(id)delegate
{
	_delegate = [delegate retain];

	if([parsingThread isExecuting])
	{	
		PBLog(@"%s is cancelling thread", _cmd);
		[parsingThread cancel];
	}
	
	[NSThread detachNewThreadSelector: @selector(parseCityData:) toTarget: self withObject: data];
}



- (void) parserDidEnd: (NSDictionary *)inDic
{
	if([ _delegate respondsToSelector:@selector(parser:didFinishParsingWithObject:)])
	{
		//[ _delegate parser: self didFinishParsingWithObject: inDic];
	}
}

- (void) parseCityData:(NSData *)cityData 
{
	parsingThread = [NSThread currentThread];
	NSAutoreleasePool * pool = [NSAutoreleasePool new];
	NSString *responseString = [[NSString alloc] initWithData:cityData encoding:NSUTF8StringEncoding];

	id cityDataAsDict = [responseString JSONValue];
	if( nil != cityDataAsDict)
	{
		PBLog(@" Response List = %@",cityDataAsDict);
		[self performSelectorOnMainThread: @selector(parserDidEnd:) withObject: cityDataAsDict waitUntilDone: NO];
	}
	[responseString release];
	
	[pool drain];
	parsingThread = nil;
}

@end

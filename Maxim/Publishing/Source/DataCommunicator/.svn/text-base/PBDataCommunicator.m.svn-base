//
//  PBDataCommunicator.m
//  Publishing
//
//  Created by Ganesh S on 10/20/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBDataCommunicator.h"
#import "PBUtilities.h"
#import "SBJSON.h"
#import "JSON.h"

#define dict_(...) [NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]

@implementation PBDataCommunicator

- (id) initWithURL: (NSURL *) newURL serviceName: (NSString *)inServiceName{

    self = [super initWithURL: newURL];
    if (self) {
        _serviceName = [inServiceName copy];
    }
    return self;
}

+ (id)requestWithURL:(NSURL *)newURL serviceName: (NSString *)inServiceName; {    
    return [[[self alloc] initWithURL: newURL serviceName: inServiceName] autorelease];
}

+ (id) requestWithURL: (NSURL *)newURL 
          serviceName: (NSString *)inServiceName 
           usingCache: (id <ASICacheDelegate>)cache; {

    return [self requestWithURL:newURL serviceName: inServiceName usingCache: cache];
}


- (void)dealloc {
    [_serviceName release];
    _serviceName = nil;
    [super dealloc];
}

#pragma mark - 

- (void) setArguments: (NSArray *)args;
{
    NSDictionary *methodCall = dict_(_serviceName, @"method", 
                                     args, @"params", 
                                     [PBUtilities stringWithRandomUUID], @"id", 
                                     @"1.0", @"version");
    NSError *theError = nil;
    SBJSON * json = [[SBJSON alloc] init];
    NSString *post = [json stringWithObject: methodCall error:&theError];
    if (theError) {
        PBLog(@"<Error: %@> while framing JSON-RPC", theError);
        [json release];
        return ;
    }
    
    PBLog(@"%@", post);    
    [self addRequestHeader: @"Accept" value: @"application/json" ];
    [self addRequestHeader: @"Content-Type" value: @"application/json" ];
    [self addRequestHeader: @"Publishing++ iPad App" value: @"User-Agent" ];
    [self setRequestMethod: @"POST"];
    [self setPostBody: [NSMutableData dataWithData: [post dataUsingEncoding:NSUTF8StringEncoding]]];// ASIHttp API setPostBody requires mutable data
    [json release];
}


- (NSDictionary *) responseDictionary; {
    
    NSData *data = [self responseData];
    
	if (!data) {
		return nil;
	}
	
    NSString * responseString = [[NSString alloc] initWithBytes: [data bytes] 
                                                         length: [data length] 
                                                       encoding: [self responseEncoding]];
    
    NSDictionary * responseDictionary = [responseString JSONValue];
    [responseString release]; 
    
	return responseDictionary;
}




@end

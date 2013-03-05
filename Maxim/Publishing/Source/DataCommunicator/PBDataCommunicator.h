//
//  PBDataCommunicator.h
//  Publishing
//
//  Created by Ganesh S on 10/20/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface PBDataCommunicator : ASIHTTPRequest {
    NSString * _serviceName;
}

+ (id)requestWithURL:(NSURL *)newURL serviceName: (NSString *)inServiceName;

- (void) setArguments: (NSArray *)args;

- (NSDictionary *) responseDictionary;

@end

//
//  PBAnalytics.h
//  Publishing
//
//  Created by Madhusudhan  HK on 28/12/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AnalyticsDataDelegate <NSObject>
@required
- (NSString *) processSuccessful: (BOOL)success;
@end


@interface PBAnalytics : NSObject {
    NSMutableData * responseData;
   
    id<AnalyticsDataDelegate> delegate;
}

@property (retain) id delegate;
@property ( nonatomic , copy ) NSString * deviceID , * bundleID , * issueID , * time , * event , * objetType , * objetcID;



-(NSString *) startAnalyticsDetails:(NSDictionary *)infodetails;
-(NSString *) stopAnalyticsDetails;
//-(void)getSearchableArtistsIfNeeded;
-(void)writeContentToFile:(NSString *)jsonString;
-(NSString *)description1;
    

@end




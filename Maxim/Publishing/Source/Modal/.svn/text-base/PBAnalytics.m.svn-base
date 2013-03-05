//
//  PBAnalytics.m
//  Publishing
//
//  Created by Madhusudhan  HK on 28/12/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBAnalytics.h"
#import "DDTTYLogger.h"
#import "DDLog.h"

@implementation PBAnalytics
@synthesize deviceID = _deviceID, bundleID = _bundleID, issueID = _issueID, time = _time, event = _event, objetType = _objetType , objetcID = _objetcID;
@synthesize delegate;

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

-(id)init{
    self=[super init];
    if(self){
        
        
        self.deviceID =[[UIDevice currentDevice] uniqueIdentifier];
        self.bundleID = @"picsean1App";
        self.issueID = kIssueId;
        //[self postDataToServer];
        
        //[self getSearchableArtistsIfNeeded];
       
    }
    return self;
}
-(NSString *)curretTime{
    
    /*
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss:mmm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    
    
    [dateFormat release];
    [timeFormat release];
    [now release];
    return [NSString stringWithFormat:@"%@ - %@",theDate,theTime];
     */
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd '-' HH:mm:ss:mmm";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    return timeStamp;
}



-(void)objectDetails:(NSDictionary *)infodetails{
    
    
    self.time=[self curretTime];
    self.objetType = [infodetails objectForKey:kAnimationTypeKey];
    self.objetcID = [infodetails objectForKey:kURLKey];
    

}


-(void)storeObjectDetails:(NSDictionary *)infodetails{
    
    [[NSUserDefaults standardUserDefaults] setObject:infodetails forKey:@"objectDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) startAnalyticsDetails:(NSDictionary *)infodetails{
    
   
   // self.articleId = [[self delegate] processSuccessful:YES];
    
    
     self.event = @"start";
     [self storeObjectDetails:infodetails];
     [self objectDetails:infodetails];
     NSString *jsonString=[self description];
    // NSLog(@"jsonString: %@",jsonString);
    //[self postDataToServer];
   // DDLogError(@"Broken sprocket detected!");
    [self writeContentToFile:jsonString];
  
      return jsonString;
    
}

-(void)postDataToServer{
    
    responseData = [[NSMutableData data] retain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest 
									requestWithURL:[NSURL URLWithString:@"http://192.168.1.3/iosupload.php"]];
    
     
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"upload=TRUE&my_file=%@",[self description1]]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    /*
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request
                                                                   delegate:self startImmediately:YES];
    
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
     */
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"didReciveData....%@",newStr);
    [newStr release];
    newStr=nil;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"didfinish ");
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"fail");
}
-(void)writeContentToFile:(NSString *)jsonString{
    
    NSMutableArray *anliticsArry = [[NSMutableArray alloc]initWithContentsOfFile:[kAnalyticsPath stringByExpandingTildeInPath]];
    [anliticsArry addObject:jsonString];
    [anliticsArry writeToFile:[kAnalyticsPath  stringByExpandingTildeInPath]  atomically:YES];
    [anliticsArry release];
    anliticsArry = nil;
    
    
}

-(NSString *) stopAnalyticsDetails{
    
    
     self.event = @"stop";
     [self objectDetails:[[NSUserDefaults standardUserDefaults] objectForKey:@"objectDetails"]];
     NSString *jsonString=[self description];
    // NSLog(@"jsonString: %@",jsonString);
   
    [self writeContentToFile:jsonString];
     //[self postDataToServer];
    return jsonString;
    
    
}

- (NSString *) description {
    
    
   NSString * str = [NSString stringWithFormat:@"{\n\
            \"device\": \"%@\",\n\
            \"bundle\": \"%@\",\n\
            \"issue\": \"%@\",\n\
            \"time\": \"%@\",\n\
            \"event\": \"%@\", \n\
            \"otype\": \"%@\",\n\
            \"oID\": \"%@\"\n\
            }",self.deviceID,
            self.bundleID, self.issueID,
            self.time , self.event,
            self.objetType , self.objetcID];
    for(int i =0 ; i < 10  ; i ++){
        str = [ str stringByAppendingString:str];
    }
    return  str;
}



-(NSString *)description1{
    
    NSMutableArray *analyticsArry = [[NSMutableArray alloc]initWithContentsOfFile:[kAnalyticsPath stringByExpandingTildeInPath]];
    NSString *postString = [[NSString alloc]init];
    
    for(int i = 0 ; i < [analyticsArry count] ; i ++){
        
        postString = [ postString stringByAppendingString:[analyticsArry objectAtIndex:i]];
        
    }
    NSLog(@"postString : %@",postString);
    //[postString release];
    return postString;
    
}



-(void)dealloc{
    
    _bundleID=nil;
    _deviceID=nil;
    _issueID=nil;
    _time=nil;
    _event=nil;
    _objetType=nil;
    _objetcID=nil;
    
    
    [super dealloc];
}
@end

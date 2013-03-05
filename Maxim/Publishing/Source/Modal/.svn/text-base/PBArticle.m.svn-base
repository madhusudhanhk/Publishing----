//
//  PBArticle.m
//  Publishing
//
//  Created by Ganesh S on 10/21/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBArticle.h"
#import "PBArticleViewer.h"
#import "NSData+Base64.h"
#import "JSON.h"

@interface PBArticle ()
- (void) createWebPageRequestWithURL: (NSURL *)inURL;
@end

@implementation PBArticle

@synthesize type = _type, imageURL = _imageURL, thumbnailURL = _thumbnailURL, adURL = _adURL;
@synthesize title ,articleNumber;


- (NSArray *) arrayFromBase64EncodedJSONString: (NSString *)base64String {
    NSData * data = [NSData dataWithBase64EncodedString: base64String];
    NSString * jsonString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSArray * jsonValue = [jsonString JSONValue];
    [jsonString release];
   return jsonValue;
}

- (id) initWithDictionary: (NSDictionary *)inArticleInfo
{
    self = [super init];
    
    if (self) {
        
        // Initialization code here.
        /*
        index = 5;
        "article_images" = "http://coco/pubplus/images/article1pg3.jpg";
        thumbnail = "http://coco/pubplus/images/danda1.jpg";
        title = "Fine Jewellery - Bracelets with Charm";
        type = 0; */
        
        /*
         "ad_url" = "http://picsean.com/ios/rotatead/index.html";
         index = 2;
         title = "November Special";
         type = 1;
         */
        
        self.title = [inArticleInfo objectForKey: kIssueTitleKey];
        self.articleNumber=[inArticleInfo objectForKey:@"index"];
        self.type = [[inArticleInfo objectForKey: @"type"] intValue];
        
        if(!pages) pages = [NSMutableArray new];

        if(self.type == ePBArticleTypeNormal)  {

            NSArray * array = [inArticleInfo objectForKey: kArticlePages]; //TODO: article_images => "pages"
            NSArray * overlays = [self  arrayFromBase64EncodedJSONString: [inArticleInfo objectForKey: @"layer_data"]]; //[inArticleInfo objectForKey: @"layer_data"]; // TODO: @"layer_data" => @"overlays"

            for (NSInteger index = 0; index < [array count]; index++) {
                
                NSDictionary * pageInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [array objectAtIndex: index], kImageKey,
                                           [overlays objectAtIndex: index], kOverlayKey, nil];
                                
                PBArticlePage * page = [[PBArticlePage alloc] initWithDictionary: pageInfo];
//                PBArticlePage * page = [[PBArticlePage alloc] initWithURLString: imageURLString];
                [pages addObject: page];
                [page release];

            }
            
            self.thumbnailURL = [NSURL URLWithString: [inArticleInfo objectForKey: kIssueThumbnailURLKey]];
            self.imageURL = [NSURL URLWithString: [inArticleInfo objectForKey: @"large_image"]];
        }
        
        else if (self.type == ePBArticleTypeAd){
            
            self.adURL = [NSURL URLWithString: [inArticleInfo objectForKey: @"ad_url"]];
            [self createWebPageRequestWithURL: self.adURL];            
        }
        
        else {
            
            self.adURL = [NSURL URLWithString: [inArticleInfo objectForKey: @"ad_url"]];
            [self createWebPageRequestWithURL: self.adURL];
            self.thumbnailURL = [NSURL URLWithString: [inArticleInfo objectForKey: kIssueThumbnailURLKey]];
        }
        
        self.adURL = [NSURL URLWithString: [inArticleInfo objectForKey: @"ad_url"]];
        _path = nil;
                
        PBLog(@"%@", inArticleInfo);
    }
    
    return self;
}


- (void) createWebPageRequestWithURL: (NSURL *)inURL {
    
    ASIDownloadCache * cache =   [[PBArticleViewer sharedInstance] downloadCache];
    
    if(![cache pathToCachedResponseDataForURL: inURL]) {
        [_webpageRequest setDelegate:nil];
        [_webpageRequest cancel];
        _webpageRequest = [ASIWebPageRequest requestWithURL: inURL];
        
        [_webpageRequest setDidFailSelector:@selector(webPageFetchFailed:)];
        [_webpageRequest setDidFinishSelector:@selector(webPageFetchSucceeded:)];
        [_webpageRequest setDelegate:self];
        
        [_webpageRequest setDownloadProgressDelegate: nil];
        [_webpageRequest setUrlReplacementMode: ASIReplaceExternalResourcesWithLocalURLs];
        
        // It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
        [_webpageRequest setDownloadCache:[[PBArticleViewer sharedInstance] downloadCache]];
        [_webpageRequest setCachePolicy: ASIOnlyLoadIfNotCachedCachePolicy];
        [_webpageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        // This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
        [_webpageRequest setDownloadDestinationPath: [[[PBArticleViewer sharedInstance] downloadCache] pathToStoreCachedResponseDataForRequest: _webpageRequest]];
        
        [[[PBArticleViewer sharedInstance] downloadCache] setShouldRespectCacheControlHeaders: NO];
        [_webpageRequest startAsynchronous];
    }
}


- (NSArray *) pages; {
    return pages;
}

- (NSString *) offlineContent {

//    NSURL *baseURL;
    NSString *offlineContent = nil;
    
//    baseURL = [NSURL fileURLWithPath: [_webpageRequest downloadDestinationPath]];
    
    ASIDownloadCache * cache =   [[PBArticleViewer sharedInstance] downloadCache];
    NSString * path = [cache pathToCachedResponseDataForURL: self.adURL];
    
	if (path/*[_webpageRequest downloadDestinationPath]*/) {
		offlineContent = [NSString stringWithContentsOfFile: path 
                                                   encoding: NSUTF8StringEncoding 
                                                      error: nil];        
//		[webView loadHTMLString:response baseURL:baseURL];
	} 
/*    
    else {
        offlineContent = [_webpageRequest responseString];
//		[webView loadHTMLString:[_webpageRequest responseString] baseURL:baseURL];
	}
  */
    return offlineContent;
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
	PBLog(@"Failed to fetch contents for URL <%@> ERROR: <%@>", [[theRequest url] absoluteString], 
          [[theRequest error] localizedDescription]);
    
    _path = nil;
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    PBLog(@"Offiline storage for page with URL <%@> completed ", [[theRequest url] absoluteString]);
    _path = [[theRequest downloadDestinationPath] copy];
}

- (void) dealloc {  
    
    self.imageURL = nil;
    self.thumbnailURL = nil;
    self.title = nil;    
    self.articleNumber=nil;
    [super dealloc];
}

#pragma mark - 

- (NSDictionary *) dictionaryRepresentation; {
    return nil;
}

@end


@implementation PBArticlePage

@synthesize imageURL = _pageImageURL, progress;

- (id) initWithDictionary: (NSDictionary *)inPageInfo  {
    self = [super init];
    
    if (self) {
        self.imageURL = [NSURL URLWithString: [inPageInfo objectForKey: kImageKey]];   
        _animationList = [[inPageInfo objectForKey: kOverlayKey] retain];
    }
    return self;

}

- (id) initWithURLString: (NSString *)inURLString {
    
    self = [super init];
    
    if (self) {
        self.imageURL = [NSURL URLWithString: inURLString];   
    }
    return self;
}


- (void) dealloc {
    self.imageURL = nil;
    [_animationList release];
    [super dealloc];
}


- (ASIHTTPRequest *) requestWithURLString: (NSString *)inURLString {
    
    ASIHTTPRequest  * request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: inURLString]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.downloadCache = [[PBArticleViewer sharedInstance] downloadCache];
    //    request.showAccurateProgress = YES;
    //    request.downloadProgressDelegate = self;
    //    request.delegate = self;
    return request;
}

- (NSArray *) overlayDownloadRequests {
    
    NSMutableArray * requests = [NSMutableArray array];

    for ( NSDictionary *animationInfo in _animationList) {

        NSString * animationType = [animationInfo objectForKey: kAnimationTypeKey];
        
        if([animationType isEqualToString: kSequenceKey]) {
            
            //FIXME: handle multiple image sequece case
            NSArray * images = [animationInfo objectForKey: kImagesKey] ;
            for (NSString * str in images) {
                [requests addObject: [self requestWithURLString: str]];
            }
        }
        
        else if ([animationType isEqualToString: kVideoKey]) {
            [requests addObject: [self requestWithURLString: [animationInfo objectForKey: kURLKey]]];
            NSLog(@"Video URL: %@", [animationInfo objectForKey: kURLKey]);
        }
        
        else if ([animationType isEqualToString: kSlideShowKey]) {
            NSArray * images = [animationInfo objectForKey: kImagesKey] ;
            for (NSString * str in images) {
                [requests addObject: [self requestWithURLString: str]];
            }
        }

        else if ([animationType isEqualToString: kScrollKey]) {
            NSArray * images = [animationInfo objectForKey: kImagesKey] ;
            for (NSString * str in images) {
                [requests addObject: [self requestWithURLString: str]];
            }
        }
        
        else if ([animationType isEqualToString: kDrawKey]) {
            [requests addObject: [self requestWithURLString: [animationInfo objectForKey: kImageKey]]];
        }

        else if ([animationType isEqualToString: kAudioKey]) {
            [requests addObject: [self requestWithURLString: [animationInfo objectForKey: kURLKey]]];
        }
        else if ([animationType isEqualToString: kPanaromaStyle]) {
            [requests addObject: [self requestWithURLString: [animationInfo objectForKey: kImageKey]]];
        }

    }
    
    return [requests count] ? requests : nil;
}


- (ASIHTTPRequest *) requestForDownloadingPageContentWithCache: (ASIDownloadCache *)inCache {
    ASIHTTPRequest  * request = [ASIHTTPRequest requestWithURL: self.imageURL];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.downloadCache = inCache;
    request.showAccurateProgress = YES;
    request.downloadProgressDelegate = self;
    request.delegate = self;
    return request;
}

- (NSArray *) animationList {
    
    if(!_animationList) {
//        NSDictionary * animationInfo1 = [NSDictionary dictionaryWithObjectsAndKeys: 
//                                         kVideoKey, kAnimationTypeKey,
//                                         NSStringFromCGRect(CGRectMake( 500, 500, 50, 50) ), @"trigger", 
//                                        @"http://dl.dropbox.com/u/10090393/2009_Ford_Endeavour.mp4", @"url", nil];
//
//        NSDictionary * animationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         kVideoKey, kAnimationTypeKey,
//                                        NSStringFromCGRect(CGRectMake( 200, 200, 50, 50) ), @"trigger", 
//                                       @"http://dl.dropbox.com/u/10090393/2009_Ford_Endeavour.mp4", @"url", nil];
//
//        NSDictionary * gallery = [NSDictionary dictionaryWithObjectsAndKeys: 
//                                   kSlideShowKey, kAnimationTypeKey,
//                                  NSStringFromCGRect(CGRectMake( 400, 600, 70, 70) ), @"overlay_frame", 
//                                  [NSArray arrayWithObjects: @"La-off-art1pg1.jpg", @"La-off-art1pg2.jpg",@"La-off-art1pg3.jpg", nil], @"images", 
//                                   NSStringFromCGRect(CGRectMake( 154.0f,  198.0f, 460.0f, 614.0f)), @"location", nil];
//
//        _animationList = [[NSArray arrayWithObjects: animationInfo, animationInfo1,gallery, nil] retain];
    }
    
    return _animationList;
}

#pragma mark - ASIHttp Request delegates

- (void) requestFinished: (ASIHTTPRequest *)request {
    
    if ([request didUseCachedResponse]) {
        PBLog(@"Got image from cached response");
    }
    
    PBLog(@"pathExtension: %@", [[request url] pathExtension]);
    if([[[request url] pathExtension] isEqualToString:@"mov"]) {
        PBLog(@"Movie URL: %@", [request url]);
    }
    
    PBLog(@"Url: %@", [request url]); 
    PBLog(@"Progress %f", self.progress);
//    [[PBArticleViewer sharedInstance] updateDownloadProgressForArticle: self];    
    request = nil;
}

- (void) requestFailed: (ASIHTTPRequest *)request {
    NSError *error = [request error];
    PBLog(@"<ERROR %@>! Could not fetch Article image for URL %@", [error localizedDescription], [self.imageURL absoluteString]);    
    request = nil;
}

- (void) setProgress:(CGFloat)inProgress {
    
    progress = inProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName: kArticlePageDownloadProgress 
                                                        object: self];
    // Need to upate UI if currently viewing page is self        
//    [[PBArticleViewer sharedInstance] updateDownloadProgressForArticle: self];
}

@end

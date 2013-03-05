//
//  PBIssue.m
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBIssue.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASINetworkQueue.h"
#import "PublishingAppDelegate.h"

@implementation PBIssue

@synthesize state = _state;
@synthesize progress = _progress;
@synthesize title = _title, month = _month, year = _year, editionId = _uid, issueThumbnailURL = _issueThumbnailURL;
@synthesize price = _price, productId = _productId;
@synthesize prepareForView = _prepareForView;
@synthesize  issuePreviewArry=_issuePreviewArry;
- (id)initWithDictionary: (NSDictionary *)inIssueInfo
{
    self = [super init];

    if (self) {
        // Initialization code here.
        self.editionId = [inIssueInfo objectForKey: kIssueEditionIdKey];
        self.month =  [inIssueInfo objectForKey: kIssueMonthKey];
        self.year = [inIssueInfo objectForKey: kIssueYearKey];//[NSString stringWithFormat: @"%@ %@", , ]; // kIssueDescriptionKey we need to change to kIssueDateKey
        self.price = [inIssueInfo objectForKey: kIssuePriceKey];
        self.title = [inIssueInfo objectForKey: kIssueTitleKey];  
        self.state = [[inIssueInfo objectForKey: kIssueStateKey] intValue];
        self.progress = [[inIssueInfo objectForKey: kIssueDownloadProgress] floatValue];
        self.issueThumbnailURL = [inIssueInfo objectForKey: @"image"];
         self.issuePreviewArry= [inIssueInfo objectForKey:kIssuePreviewKey];
        _shouldFetchImage = YES;
        _request = nil;
        _prepareForView = NO;
    }
    
    return self;
}

- (NSDictionary *) dictionaryRepresentation; {
    
    return [NSDictionary dictionaryWithObjectsAndKeys: self.editionId, kIssueEditionIdKey, 
            self.title, kIssueTitleKey, 
            self.price, kIssuePriceKey, 
            self.month, kIssueMonthKey,
             self.issuePreviewArry,kIssuePreviewKey,
            self.year, kIssueYearKey,
            (self.issueThumbnailURL) ? self.issueThumbnailURL: @"", @"image",
            [NSNumber numberWithInt: self.state], kIssueStateKey,
            [NSNumber numberWithFloat: self.progress], kIssueDownloadProgress,
            nil];
}

- (void) dealloc {
    self.title = nil;
    self.month = nil;
    self.year = nil;
    self.price = nil;
    self.editionId = nil;
    self.issueThumbnailURL = nil;
    _request = nil;
    [_image release];
    
    self.issuePreviewArry=nil;
    [self.issuePreviewArry release];
    [super dealloc];
}

#pragma mark - Network Queue Related


- (NSString *) productId {
    return @"com.picsean.inapprage.drummerrage"; //! FIXME: remove this method once we start getting productids from server
}

- (NSString *) description;{
    return [NSString stringWithFormat: @"PBIssue <Title:%@, ID:%@, Date:%@-%@, State:%d>", self.title, self.editionId, self.month, self.year, self.state];
}

- (void) resetProgress {
    _progress = 0.0f;
}

- (void) setProgress: (CGFloat)progress {
    
    if((progress >= _progress) && (progress < 2.0)) {
        _progress = progress;
        // Update UI 
        [[NSNotificationCenter defaultCenter] postNotificationName: kIssueProgressUpdate
                                                            object: self];
    }
    
    self.prepareForView = NO;
}


- (void) setPrepareForView: (BOOL)prepareForView {
    
    _prepareForView = prepareForView;
    [[NSNotificationCenter defaultCenter] postNotificationName: kShouldReloadStoreCatalog
                                                        object: nil];
}


- (void) queueComplete: (ASINetworkQueue *)queue {
    
   // PBLog(@"called with progress %f", [self progress]);
        
    if ((self.progress >= 0.97f) && (self.progress < 10.0f)) {
        self.state = eIssueStateView;  
    }   
    else        
        self.state = ([queue isSuspended]) ? eIssueStatePaused : self.state;
    
//    PBLog(@"Network Queue Completed for Issue %@", self.title);    
    [(PublishingAppDelegate *)[UIApplication sharedApplication].delegate saveCatalogItems];
    [[NSNotificationCenter defaultCenter] postNotificationName: kShouldReloadStoreCatalog
                                                        object: self];
}

#pragma mark -


-(void)previewImageArry{
    
    if(!_previewImageArry)
        _previewImageArry=[NSMutableArray new];
    for(int i = 0 ; i < [ self.issuePreviewArry count] ; i++)
    {
        ASIDownloadCache * _cache = [ASIDownloadCache sharedCache];
        
        NSString *path = [_cache pathToCachedResponseHeadersForURL: [NSURL URLWithString: [self.issuePreviewArry objectAtIndex:i]]];
        
        if(path) {
            UIImage *img = [[UIImage imageWithData: [_cache cachedResponseDataForURL: [NSURL URLWithString: self.issueThumbnailURL]]] retain];
            if(img)
            [_previewImageArry addObject:img];
            [img release];
            
        }
        
        else {
            if(_request && _shouldFetchImage) {
                _request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: [self.issuePreviewArry objectAtIndex:i]]];
                _cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
                [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [_request setDownloadCache: _cache];
                _cache.shouldRespectCacheControlHeaders = NO;
                _request.delegate = self;
                [_request startAsynchronous];
            }
        }
    }
        
}

- (UIImage *) image {
    
    if(_image) return _image;
    
    else {
        
        ASIDownloadCache * _cache = [ASIDownloadCache sharedCache];

        NSString *path = [_cache pathToCachedResponseHeadersForURL: [NSURL URLWithString: self.issueThumbnailURL]];
       
        if(path) {
            _image = [[UIImage imageWithData: [_cache cachedResponseDataForURL: [NSURL URLWithString: self.issueThumbnailURL]]] retain];
            return _image;
        }
        
        else {
            if(!_request && _shouldFetchImage) {
                _request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: self.issueThumbnailURL]];
                _cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
                [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [_request setDownloadCache: _cache];
                _cache.shouldRespectCacheControlHeaders = NO;
                _request.delegate = self;
                [_request startAsynchronous];
            }
        }
    }

    return nil;
}


- (void) requestFinished: (ASIHTTPRequest *)request {

    if ([request didUseCachedResponse]) {
      ///  PBLog(@"Got image from cached response");
    }
    
    if(!_image) 
        _image = [[UIImage imageWithData: [request responseData]] retain];

    [[NSNotificationCenter defaultCenter] postNotificationName: kShouldReloadStoreCatalog
                                                        object: nil];
    _request = nil;
    _shouldFetchImage = NO;    
}

- (void) requestFailed: (ASIHTTPRequest *)request {
   // NSError *error = [request error];
   // PBLog(@"Could not fetch issue thumbnail image.<ERROR %@>", [error localizedDescription]);
    _request = nil;
    _shouldFetchImage = NO;
}

@end

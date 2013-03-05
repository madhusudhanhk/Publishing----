//
//  PBArticle.h
//  Publishing
//
//  Created by Ganesh S on 10/21/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIWebPageRequest.h"

typedef enum {
    ePBArticleTypeNormal = 0,
    ePBArticleTypeAd,
    ePBArticleTypeWebArticle
    
} PBArticleType ;

@class PBArticlePage;

@interface PBArticle : NSObject {  
    PBArticleType _articleType;
    NSMutableArray * pages;
    NSURL * _imageURL, * _thumbnailURL, *_adURL;
    
    PBArticleType _type;
    NSString * title,* articleNumber;
    ASIWebPageRequest * _webpageRequest;
    NSString * _offlineContent;
    NSString * _path;
}

@property (nonatomic) PBArticleType type;
@property (nonatomic, copy) NSURL * imageURL, *thumbnailURL, *adURL;
@property (nonatomic, copy) NSString * title, * articleNumber;

- (id) initWithDictionary: (NSDictionary *)inIssueInfo;

- (NSDictionary *) dictionaryRepresentation;

- (NSArray *) pages;

- (NSString *) offlineContent;

@end


@interface PBArticlePage : NSObject {
    NSURL * _pageImageURL;
    NSMutableArray * _overlays;
    CGFloat progress;
    NSArray * _animationList;
}

@property (nonatomic) CGFloat progress;
@property (nonatomic, copy) NSURL * imageURL;

- (id)initWithURLString: (NSString *)inURLString ;
- (id) initWithDictionary: (NSDictionary *)inPageInfo ; 

- (NSArray *) overlayDownloadRequests ;
- (ASIHTTPRequest *) requestForDownloadingPageContentWithCache: (ASIDownloadCache *)inCache;

- (NSArray *) animationList;


@end
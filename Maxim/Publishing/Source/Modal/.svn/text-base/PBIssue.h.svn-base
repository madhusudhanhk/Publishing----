//
//  PBIssue.h
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBArticleViewer.h"

typedef enum {
    eIssueStateBuy = 0,
    eIssueStateDownload,
    eIssueStateDownloading,
    eIssueStatePaused,
    eIssueStateView
} PBIssueState;

@class ASIHTTPRequest;

@interface PBIssue : NSObject <PBIssueDownloadDelegate>
{
    NSString * _title;
    NSString * _month;
    NSString * _year;
    NSNumber * _price;
    NSString * _uid;
    NSString * _issueThumbnailURL;
    NSArray  * _issuePreviewArry;
    NSString * _productId;
     NSMutableArray * _previewImageArry;
    PBIssueState _state;
    UIImage * _image;
    ASIHTTPRequest * _request;
    BOOL _shouldFetchImage, _downloadDidComplete, _prepareForView;
    CGFloat _progress;    
}

@property (nonatomic, copy) NSString * title, *month, *year, *editionId, *issueThumbnailURL, *productId;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic) PBIssueState state;
@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL prepareForView;

@property ( nonatomic, retain)NSArray *issuePreviewArry;
- (id) initWithDictionary: (NSDictionary *)inIssueInfo;

- (NSDictionary *) dictionaryRepresentation;

- (UIImage *) image;

- (NSString *) description;

- (void) resetProgress;
-(void)previewImageArry;

@end

//
//  CSConstants.h
//  ACKComicStore
//
//  Created by Ganesh S on 9/26/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kPubId      @"3"
#define kMagId      @"20"
#define kIssueId    @"1"
#define kAppName    @"EasternShore"
#pragma mark - Service Related

#define Arabic 1

extern NSString * kBaseURL;
extern NSString * kNotesPath;
extern NSString * kAnalyticsPath;
extern NSString * kGetAllIssuesURL;
extern NSString * kComicDetailURL;

extern NSString * kCatalogService;
extern NSString * kIssueDetailsService;
extern NSString * kAuthenticationService;
extern NSString * kVerifyReceipt; //verify receipt for in app purchase

#pragma mark - Issue related

extern NSString * kCatalogFilePath;
extern NSString * kIssueEditionIdKey;
extern NSString * kIssueDateKey;
extern NSString * kIssuePurchsed;
extern NSString * kIssueStateKey;
extern NSString * kIsIssueDownloaded;
extern NSString * kIssueDownloadProgress;
extern NSString * kIsIssueDownloadPaused;
extern NSString * kIssuePriceKey;
extern NSString * kIssueDescriptionKey;
extern NSString * kIssueTitleKey;
extern NSString * kIssueThumbnailURLKey;

extern NSString * kRequestType;
extern NSString * kBookMarkPath;
extern NSString * kSuccessCode;

extern NSString * kIssueThumbnailURLKey ;
extern NSString * kIssueMonthKey;
extern NSString * kIssueYearKey;
extern NSString * kMagazineId;
extern NSString * kPublisherId;
extern NSString * kArticlePages;  
extern NSString * kIssuePreviewKey;

#pragma mark - Overlay Related

extern NSString * kImageKey;    // Single image
extern NSString * kImageKey_l;
extern NSString * kImagesKey;   // Image list
extern NSString * kTriggerKey;
extern NSString * kJumpKey;
extern NSString * kNestedKey;
extern NSString * kEffectsKey;
extern NSString * kURLKey;// url
extern NSString * kLocationKey;//location
extern NSString * kSlideShowKey; //slideshow
extern NSString * kSequenceKey;  //sequence"
extern NSString * kVideoKey;     //video
extern NSString * kDrawKey;
extern NSString * kAudioKey;     //audio
extern NSString * kScrollKey;
extern NSString * kNextTriggerKey ;
extern NSString * kPreviousTriggerKey;
extern NSString * kAnimationTypeKey;     //type
extern NSString * kDurationKey;// duration
extern NSString * kRepeatcountKey; // repeatcount
extern NSString * kVolumeKey; //volume
extern NSString * kOverlayKey; //
extern NSString * kControlStyle;
extern NSString * kShouldAutoPlay;
extern NSString * kHyperlinkUrl;
extern NSString * kImageHyperLink;
extern NSString * kLargImageKey;
extern NSString * kOrientationKey;
extern NSString * kPanaromaStyle;


#pragma mark -OtherMagzein related

extern NSString * kOtherMagzeinDiscription;
extern NSString * kOtherMagzeinImage;
extern NSString * kOtherMagzeinStoreLink;
extern NSString * kOtherMagzeinName;
extern NSString * kOtherMagzeinDocumentryPath;

#pragma mark - Notifications Related

extern NSString * kShouldReloadStoreCatalog;
extern NSString * kArticlePageDownloadProgress;

#pragma mark - BookMark Related

extern NSString * kBookMarkImageUrl;
extern NSString * kBookMarkTitle;
extern NSString * kBookMarkPageNumber;
extern NSString * kIssueProgressUpdate;


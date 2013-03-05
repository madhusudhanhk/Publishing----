//
//  CSConstants.m
//  ACKComicStore
//
//  Created by Ganesh S on 9/26/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBConstants.h"



#ifdef DEBUG
NSString * kBaseURL = @"http://picsean.com/pubplus/pubserver.php";
#else
NSString * kBaseURL = @"http://picsean.com/pubplus/pubserver.php";
#endif

NSString *kNotesPath=@"~/Documents/NoteBook.plist";
NSString *kAnalyticsPath=@"~/Documents/Analytics.plist";

#pragma mark - Web Service Related

NSString * kGetAllIssuesURL = @"http://picsean.com/ack/get_all_tinkle_issues.php";
NSString * kComicDetailURL  = @"http://picsean.com/ack/comic_page_info.php?comicid=%@";
NSString * kCatalogFilePath = @"~/Documents/StoreCatalog.plist";
NSString * kBookMarkPath    = @"~/Documents/BookMark.plist";
NSString * kOtherMagzeinDocumentryPath =@"~/Documents/OtherMagzein.plist";

NSString * kCatalogService  = @"get_all_issues";
NSString * kIssueDetailsService = @"get_article_details";
NSString * kVerifyReceipt = @"verify_receipt"; // receipt verification call 
NSString * kAuthenticationService = @"authenticate";

#pragma mark - Issue Related

NSString * kIssueEditionIdKey       = @"editionid";
NSString * kIssueDateKey            = @"IssueDate";
NSString * kIssuePurchsed           = @"IsComicPurchsed";
NSString * kIssueStateKey           = @"ComicPurchaseState";
NSString * kIsIssueDownloadPaused   = @"IsComicDownloadPaused";
NSString * kIssueDownloadProgress   = @"ComicDownloadProgress";
NSString * kIsIssueDownloaded       = @"IsComicDownloaded";
NSString * kIssuePriceKey           = @"price";
NSString * kIssueDescriptionKey     = @"description";
NSString * kIssueTitleKey           = @"title" ;
NSString * kIssueThumbnailURLKey    = @"thumbnail";
NSString * kIssueMonthKey           = @"month";
NSString * kIssueYearKey            = @"year";
NSString * kMagazineId              = @"magid";
NSString * kPublisherId             = @"pubid";
NSString * kArticlePages            = @"article_images";
NSString * kRequestType             = @"RequestType"; // Used for setting context info for request
NSString * kSuccessCode             = @"ACK_2000";
NSString * kIssuePreviewKey         = @"preview";

#pragma mark - Notifications Related

NSString * kIssueProgressUpdate         = @"kIssueProgressUpdate";
NSString * kShouldReloadStoreCatalog   = @"ThumbnailDownload";
NSString * kArticlePageDownloadProgress = @"ArticlePageDownloadProgress";

#pragma mark - Overlay Related

NSString * kImageKey = @"image";
NSString * kImageKey_l = @"image_l";
NSString * kImagesKey = @"images";
NSString * kTriggerKey = @"trigger";
NSString * kURLKey = @"url";// url
NSString * kLocationKey = @"location";//
NSString * kHyperlinkUrl = @"url";
NSString * kSlideShowKey = @"slideshow"; 
NSString * kNextTriggerKey = @"trigger1";
NSString * kPreviousTriggerKey = @"trigger2";
NSString * kSequenceKey = @"sequence";  //
NSString * kVideoKey = @"video";     //
NSString * kDrawKey = @"draw";
NSString * kAudioKey = @"audio";     //
NSString * kScrollKey = @"scroll";
NSString * kAnimationTypeKey = @"type";     //
NSString * kDurationKey = @"duration";// 
NSString * kRepeatcountKey = @"repeatcount"; // 
NSString * kVolumeKey = @"volume"; //
NSString * kOverlayKey = @"overlay"; //
NSString * kJumpKey                 = @"jump";
NSString * kNestedKey               = @"nested";
NSString * kControlStyle            = @"style";
NSString * kShouldAutoPlay          = @"autoplay";
NSString * kEffectsKey              = @"effects";
NSString * kImageHyperLink          =@"imageHyperLink";
NSString * kLargImageKey            =@"";
NSString * kOrientationKey          =@"orientation";
NSString * kPanaromaStyle            =@"panaroma";




#pragma mark -OtherMagzein related

NSString * kOtherMagzeinDiscription    =@"magazine_description";
NSString * kOtherMagzeinImage          =@"thumbnail";
NSString * kOtherMagzeinStoreLink      =@"StoreLink";
NSString * kOtherMagzeinName           =@"magazine_name";

#pragma mark - BookMark Related

NSString * kBookMarkImageUrl        =@"BookMarkImageUrl";
NSString * kBookMarkTitle           =@"kBookMarkTitle";
NSString * kBookMarkPageNumber      =@"kBookMarkPageNumber";

//
//  PBBookMark.h
//  Publishing
//
//  Created by Madhusudhan  HK on 19/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASIDownloadCache;

@protocol PBBookMarkDelegate;

@interface PBBookMark : UITableViewController {
    
    NSMutableArray *_bookMarkList;
    ASIDownloadCache * _downloadCache;
    id <PBBookMarkDelegate> delegate;
}

@property (assign) id <PBBookMarkDelegate> delegate;;

@end

@protocol PBBookMarkDelegate <NSObject>
- (void) userDidChooseASetting ;
- (void) bookmark: (PBBookMark *)bookmarkController didChooseBookmarkItem: (NSDictionary *)inBookmarkDetails;
@end


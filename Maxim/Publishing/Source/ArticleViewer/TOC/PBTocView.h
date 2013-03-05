//
//  PBTocView.h
//  Publishing
//
//  Created by Madhusudhan  HK on 25/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBArticle.h"
@class ASIDownloadCache;

@protocol tocDelegate <NSObject>
@required
- (void) navigateToArticle: (PBArticle *)article;
@end
@interface PBTocView : UITableViewController<UITableViewDataSource>{
   
    
    UITableView *  _tocTableView;
    NSMutableArray *_tocImageArry;
    ASIDownloadCache * _downloadCache;
    __weak id<tocDelegate> delegate;
}
@property (assign) id delegate;
@property (nonatomic,retain) NSMutableArray *_tocImageArry;
@property (nonatomic,retain)IBOutlet UITableView *  _tocTableView;


@end

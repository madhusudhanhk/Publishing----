//
//  PBIssuePreviewController.h
//  Publishing
//
//  Created by Ganesh S on 10/24/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBOrientedTableView.h"

@interface PBIssuePreviewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    PBOrientedTableView * _paginationView;
    NSArray * _previewItemList;
    UIScrollView *scrollView;
    UIImageView *slideShowImage;
     NSArray * _previewImageUrlArry;
    UIImage * _image;
}

@property(nonatomic,retain) NSArray * _previewImageUrlArry;
@property (nonatomic, retain) IBOutlet PBOrientedTableView * paginationView;
@property(nonatomic,retain)IBOutlet  UIScrollView *scrollView;
- (UIImage *) image:(NSString *)imageUrl;
@end

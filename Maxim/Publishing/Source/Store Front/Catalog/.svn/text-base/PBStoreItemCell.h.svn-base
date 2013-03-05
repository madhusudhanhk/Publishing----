//
//  MagzienCustomCell.h
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBIssue;
@class PBStoreItemTileView;

@protocol PBCatlogItemDelegate <NSObject>
@required 
@end

@interface PBStoreItemCell : UITableViewCell {
	PBStoreItemTileView *holderView1, *holderView2;
} 

@property (nonatomic,retain) IBOutlet PBStoreItemTileView *holderView1, *holderView2;;

- (void) setupCellDetailsForFirstItem: (PBIssue *)inCellData;

- (void) setupCellDetailsForSecondItem: (PBIssue *)inCellData;

@end


@interface PBStoreItemTileView : UIView {
    
    IBOutlet UILabel *title;
    IBOutlet UILabel *price;
    IBOutlet UILabel *description;
    UIImageView *comicImageView;
    
    UIButton *viewButton;
    UIButton *buyOrViewButton;
    UISlider * _progressView;
    __weak PBIssue * _issue;
}

@property (nonatomic, retain) IBOutlet UIButton *buyOrViewButton;
@property (nonatomic, retain) IBOutlet UIButton *viewButton;
@property (nonatomic, retain) IBOutlet UIImageView *comicImageView;

- (void) setupProperties: (PBIssue *)inTileData;

@end
//
//  MagzienCustomCell.m
//  Publishing
//
//  Created by Ganesh S on 10/14/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBStoreItemCell.h"
#import "PBIssue.h"


@implementation PBStoreItemCell

@synthesize holderView1, holderView2;
/*
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];

    return self;
}
*/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void) setSelected: (BOOL)selected animated: (BOOL)animated {
    
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state.
}


- (void) dealloc {
    [holderView1 release];
    [holderView2 release];    
    [super dealloc];
}


- (void) setupCellDetailsForFirstItem: (PBIssue *)inCellData; {
    [holderView1 setupProperties: inCellData];
}

- (void) setupCellDetailsForSecondItem: (PBIssue *)inCellData; {
    [holderView2 setupProperties: inCellData];
}


@end


@implementation PBStoreItemTileView

@synthesize buyOrViewButton;
@synthesize viewButton;
@synthesize comicImageView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleIssueThumbnailDownload:) 
                                                     name: kIssueProgressUpdate
                                                   object: nil];
        
        
        title.textColor = [PBUtilities titleColor];
        title.shadowColor = [PBUtilities titleShadowColor];
        title.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        _progressView = [[UISlider alloc] initWithFrame: CGRectMake(170.0f, 143.0f, 204.0f, 11.0f)];
        _progressView.userInteractionEnabled = NO;
        [_progressView setThumbImage: [UIImage imageNamed: @"Thumb.png"] forState: UIControlStateNormal];
        [_progressView setMinimumTrackImage: [[UIImage imageNamed: @"Progress.png"] stretchableImageWithLeftCapWidth: 4.0f 
                                                                                                        topCapHeight: 4.0f]
                                   forState: UIControlStateNormal];
        [_progressView setMaximumTrackImage: [[UIImage imageNamed: @"ProgressBg.png"] stretchableImageWithLeftCapWidth: 4.0f
                                                                                                          topCapHeight: 4.0f]
                                   forState: UIControlStateNormal];

        _progressView.minimumValue = 0.0f;
        _progressView.maximumValue = 1.0f;  
        [self addSubview: _progressView];
        [_progressView release];
    }
    
    return self;
}


- (void) setupProperties: (PBIssue *)inTileData; {
    _issue = inTileData;
    title.text = inTileData.title;
    description.text = [NSString stringWithFormat: @"%@ %@", inTileData.month, inTileData.year];
    price.text = [NSString stringWithFormat: @"$ %.2f", [inTileData.price floatValue]];
    self.comicImageView.image = [inTileData image];
    [_progressView setValue: inTileData.progress];
    

    
    switch ([inTileData state]) {
        case eIssueStateBuy: 
        {
            // Set buyOrViewButton to say "Buy"
            // Download progress and pause buttons should be disabled
                        _progressView.hidden = YES;
            viewButton.hidden = NO;
            buyOrViewButton.hidden = NO;
            [buyOrViewButton setTitle: NSLocalizedString(@"Buy", nil)forState: UIControlStateNormal];
            [viewButton setTitle: NSLocalizedString(@"Preview", nil)forState: UIControlStateNormal];
           [inTileData previewImageArry];
            

            break;
        }
            
        case eIssueStateDownload: 
        {
            // Set buyOrViewButton to say "Download"
            // Download progress and pause buttons should be disabled
            _progressView.hidden = YES;
            viewButton.hidden = YES;        
            buyOrViewButton.hidden = NO;            
            [buyOrViewButton setTitle: NSLocalizedString(@"Download", nil)forState: UIControlStateNormal];
            break;
        }
        
        case eIssueStateDownloading:
        case eIssueStatePaused:
        {
            _progressView.hidden = NO;
            viewButton.hidden = NO;              
            buyOrViewButton.hidden = NO;            
            [buyOrViewButton setTitle: (inTileData.state == eIssueStatePaused) ? NSLocalizedString(@"Resume", nil): NSLocalizedString(@"Pause", nil)
                         forState: UIControlStateNormal];

            [viewButton setTitle: NSLocalizedString(@"View", nil)forState: UIControlStateNormal];
            viewButton.enabled = !inTileData.prepareForView;
            break;  
        }
            
        case eIssueStateView: 
        {
            _progressView.hidden = YES;
            viewButton.hidden = NO;              
            buyOrViewButton.hidden = NO;

//            if((inTileData.state == eIssueStatePaused) || 
//               (inTileData.progress >= 1.0f)) {
//                pauseButton.hidden = NO;
//            }
            [buyOrViewButton setTitle: NSLocalizedString(@"Archive", nil)forState: UIControlStateNormal];
            [viewButton setTitle: NSLocalizedString(@"View", nil)forState: UIControlStateNormal];

            break;
        }
    
        default:
            break;
    }
    
    buyOrViewButton.titleLabel.shadowColor = [UIColor blackColor];
    buyOrViewButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);

    viewButton.titleLabel.shadowColor = [UIColor blackColor];
    viewButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
    [self setNeedsLayout];
}

- (void) dealloc {
    [title release];
    [description release];
    [price release];
    [comicImageView release];
    [viewButton release];
    [buyOrViewButton release];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}


- (void) handleIssueThumbnailDownload: (NSNotification *)inNotification
{
    PBIssue * issue = [inNotification object];    

    if(issue == _issue) {
        _progressView.hidden = NO;
        _progressView.value = issue.progress;
        
        [buyOrViewButton setTitle: NSLocalizedString(@"Pause", nil)
                         forState: UIControlStateNormal];
    }
}

@end

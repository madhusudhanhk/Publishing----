//
//  PBPageView.h
//  Publishing
//
//  Created by Ganesh S on 10/25/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PBArticleViewer.h"
#import "PBAnalytics.h"
@class PBArticlePage;
@class PBCarouselView;
@class MPMoviePlayerViewController;
@class AVAudioPlayer;

@interface PBPageView : UIView <PBPageDelegate,AnalyticsDataDelegate> {
    UIView * _progressHolder;
    UILabel * _downloadStatus, *_downloadBG, *_downloadBar;
    UIImageView * _imageView;  
    __weak PBArticlePage * _articlePage;

    MPMoviePlayerViewController *_videoPlayer;

    NSInteger _currentScrollIndex;
    NSMutableArray * _overlays;

    AVAudioPlayer * _audioPlayer;   

    BOOL _loadOverlays;
    
    NSInteger _nestedAnimationIndex;    
    NSMutableArray  *_nestedAnimationResources;
    
    MPMoviePlayerController * _movieController;
   
    
    
}

- (id) initWithFrame: (CGRect)frame article: (PBArticlePage *)inArticle;

- (void) setImage: (UIImage *)inImage forArticle: (PBArticlePage *)inArticle;

//- (void) updateProgressForArticle: (PBArticlePage *)inArticle; 

- (void) resetPageLayout;

- (void) playAnimationForPage: (PBArticlePage *)inArticlePage;

- (void) playAnimationOnPageLoad;
//-(void)playMe;
-(void) autoplayMethod;
//-(void)analyticsLogin;

@end

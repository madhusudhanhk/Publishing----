//
//  PBPageView.m
//  Publishing
//
//  Created by Ganesh S on 10/25/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBPageView.h"
#import "PBArticle.h"
#import "PBArticleViewer.h"
#import "PBAnalytics.h"
#import "PBArticle.h"
#define kProgressBarTag 32897
#define kGalleryViewTag 23784
#define kLargImageTag 89734
#define kScrollControlKey 378
#define kDrawControlKey 86778
#define kButtonTag 867
#define kSequenceAnimationViewTag 75536

#define kNestedAnimationView 765
#define kNestedAnimationTrigger 545
#define kVideotag 7347934

@interface PBTrigger: UIButton  {
@private
    id context;
    id imageFrame;
    id hyperLinkUrl;
    id videoUrl;
    id closeBool;
}
@property (retain) id context;
@property (retain) id imageFrame;
@property (retain) id hyperLinkUrl;
@property (retain) id videoUrl;
@property (retain) id closeBool;
@end 

@implementation PBTrigger

@synthesize context;
@synthesize imageFrame;
@synthesize hyperLinkUrl;
@synthesize videoUrl;
@synthesize closeBool;

- (void)dealloc {
    [context release];
    context = nil;
    [imageFrame release];
    imageFrame = nil;
    [hyperLinkUrl release];
    hyperLinkUrl=nil;
    [videoUrl release];
    videoUrl=nil;
    [closeBool release];
    closeBool=nil;
    
    [super dealloc];
}

@end






@implementation PBPageView


- (UILabel *) labelWithFrame: (CGRect)inRect {
    UILabel * label = [[UILabel alloc] initWithFrame: inRect];
    return label;
}


- (id)initWithFrame:(CGRect)frame article: (PBArticlePage *)inArticlePage;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        // Initialization code
        _loadOverlays = 1;
        _articlePage = inArticlePage;
        self.backgroundColor = [UIColor darkGrayColor];
      
        _imageView = [[UIImageView alloc] initWithFrame: frame];
        [self addSubview: _imageView];
        [_imageView release];
        _imageView.center = _imageView.center;

        _progressHolder = [[UIView alloc] initWithFrame: CGRectMake( CGRectGetMidX(frame) - 100.0f, CGRectGetMidY(frame)-25.0f, 200, 49.0f)];
        _progressHolder.backgroundColor = [UIColor clearColor];
        [self addSubview: _progressHolder];
        [_progressHolder release];
        
        _downloadStatus  = [self labelWithFrame: CGRectMake(34.0f, 8.0f, 135.0f, 21.0f)];
        _downloadStatus.text = NSLocalizedString(@"Downloading…", nil);
        _downloadStatus.backgroundColor = [UIColor clearColor];
        _downloadStatus.textAlignment = UITextAlignmentCenter;
        _downloadStatus.textColor = [UIColor colorWithRed:0.202 green:0.745 blue:1.000 alpha:1.000];
        [_progressHolder addSubview: _downloadStatus];
        [_downloadStatus release];
        
        _downloadBG = [self labelWithFrame: CGRectMake( 20, 37.0f, 160.0f, 4.0f)];
        _downloadBG.backgroundColor = [UIColor blackColor];
        [_progressHolder addSubview: _downloadBG];
        [_downloadBG release];
        
        _downloadBar = [self labelWithFrame: CGRectMake( 20, 37.0f, 1, 4.0f)];
        _downloadBar.backgroundColor = [UIColor colorWithRed:0.202 green:0.745 blue:1.000 alpha:1.000];
        [_progressHolder addSubview: _downloadBar];
        _downloadBar.tag = kProgressBarTag;
        [_downloadBar release];
        
        [_progressHolder setHidden: 0];
        
        if(!_overlays) _overlays  = [NSMutableArray new];

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleProgressUpdate:) 
                                                     name: kArticlePageDownloadProgress
                                                   object: nil];

        
//        [self updateProgressForArticle: _articlePage];
        
    }
    
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return self;
}


- (void) dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [NSObject cancelPreviousPerformRequestsWithTarget: self];    

    if(_nestedAnimationResources) {
        [_nestedAnimationResources removeAllObjects];
        [_nestedAnimationResources release];
    }
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *) processSuccessful:(BOOL)success
{
    
	// PBArticle * filePath =   [[PBArticleViewer sharedInstance]articleDetail];
   
    return nil;
}

-(void)analyticsLogin:(NSDictionary *)animationInfo{
    
    PBAnalytics * analytics = [[PBAnalytics alloc]init];
    [analytics setDelegate:self];
    [analytics startAnalyticsDetails:animationInfo];
    [analytics release];
    
}
- (void) updateProgressForArticle: (PBArticlePage *)page {
    
    if([page progress] >= 1.0f) {
        _progressHolder.hidden = YES;
        _imageView.image = [UIImage imageWithData: [[[PBArticleViewer sharedInstance] downloadCache] cachedResponseDataForURL: page.imageURL]];
    }
    else {
        _progressHolder.hidden = NO;
        CGRect progressFrame = _downloadBar.frame;
        progressFrame.size.width = page.progress * 160.0f;
        _downloadBar.frame = progressFrame;
    }

}

- (void) setImage: (UIImage *)inImage forArticle: (PBArticlePage *)inArticle; {

    _articlePage = inArticle;

    if(inImage) {
        _imageView.image = inImage;        
        _progressHolder.hidden = 1;        
    } else {
        _imageView.image = nil;        
       // [self updateProgressForArticle: inArticle];
    }
    
}

- (void) handleProgressUpdate: (NSNotification *)inNotification; {

    PBArticlePage * page = [inNotification object];
    
    if(page == _articlePage) {        
        [self updateProgressForArticle: page];
    }
}


#pragma mark - Page Animation Related

- (void) resetPageLayout {

    _nestedAnimationIndex = 0;
    
    _loadOverlays = YES;

    if(_audioPlayer) {
            [_audioPlayer stop]; 
            [_audioPlayer release];
    }
    
    _audioPlayer = nil;
    _currentScrollIndex = 0;
    
    [[self viewWithTag: kGalleryViewTag] removeFromSuperview];
    //PBLog(@"Subviews %@ \n _overlays %@",  [self subviews], _overlays);

    [_overlays makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [_overlays removeAllObjects];
}


- (void) playImageSequeceAnimationWithInfo: (NSDictionary *)inAnimationInfo {

    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame: _imageView.frame];
    [self addSubview: imageView];
    [imageView release];
    [_overlays addObject: imageView];
    
    NSArray * imagePaths = [inAnimationInfo objectForKey: kImagesKey];
    
    NSMutableArray * imageList = [NSMutableArray array];
    for (NSString * path in  imagePaths) {
        NSURL * url = [NSURL URLWithString:path];
        NSString *path = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
        if(path){
            UIImage * anImage = [UIImage imageWithContentsOfFile: path];            
            if(anImage) [imageList addObject: anImage];
        }
    }
    
    imageView.animationImages = imageList;
    imageView.tag = kSequenceAnimationViewTag;
    imageView.animationRepeatCount = [[inAnimationInfo objectForKey: kRepeatcountKey] integerValue];
    imageView.animationDuration = [[inAnimationInfo objectForKey: kDurationKey] floatValue];
    [pool drain];
    [self playAnimationOnPageLoad];
    
    // Analytics call::::
    
      [self performSelectorInBackground:@selector(analyticsLogin:) withObject:inAnimationInfo];    
    
    
}/*
-(void)playVideoForPage: (NSDictionary *)inAnimationInfo{
     NSAutoreleasePool * pool = [NSAutoreleasePool new];
   
    CGRect location = CGRectFromString([inAnimationInfo objectForKey: kLocationKey]);
    NSURL * videoURL = [NSURL URLWithString: [inAnimationInfo objectForKey: kURLKey]];
    NSString * controlStyle = [inAnimationInfo objectForKey: kControlStyle];
    NSString * filePath = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: videoURL];
    NSURL * videoFileURL = [NSURL fileURLWithPath: filePath];
    
    _movieController = [[MPMoviePlayerController alloc] initWithContentURL: videoFileURL];
    [_movieController.view setFrame: location];
    _movieController.controlStyle = [controlStyle isEqualToString: @"none"] ? MPMovieControlStyleNone : MPMovieControlStyleEmbedded;       
    _movieController.view.tag = kVideotag;
    [self addSubview: _movieController.view];
    [_movieController release];
    [_overlays addObject: _movieController.view];
    
   
    
    

    [pool drain];
    
}
-(void)playMe{
     NSLog(@"play Video,,,,,");
    //[[self viewWithTag: kVideotag] play];
}
  */

- (void) closeGalleryView: (id)inSender {
    [[self viewWithTag: kGalleryViewTag] removeFromSuperview];
    [inSender removeFromSuperview];
}

- (void) closeDrawImage: (id)inSender {
    [[self viewWithTag: kDrawControlKey] setHidden:YES];
    [inSender removeFromSuperview];
}
-(void) showLargeImageslide:(id)inSender{
    
          //TODO: 
          NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [inSender tag]];
    
    
          NSString * imagePaths = [animationInfo objectForKey: kImagesKey];
    
         UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
         scrollView.backgroundColor = [UIColor blackColor];
    
        
        NSURL * url = [NSURL URLWithString: imagePaths];
        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
        UIImage *largeImage =[UIImage imageWithContentsOfFile: filePath]; //TODO: should use image with contents of file (from cache)
        UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,largeImage.size.width,largeImage.size.height )];
        img.image= largeImage;
        [scrollView addSubview:img];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img release];
      
        
   
    
    scrollView.contentSize=CGSizeMake(img.frame.size.width, img.frame.size.width);
    scrollView.pagingEnabled=NO;
    scrollView.tag = kLargImageTag;
    [self addSubview: scrollView];
    [scrollView release];

}
- (void) showImageGallery: (id)inSender  {
   
    
    
    
    //TODO: 
    NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [inSender tag]];
     
     // Analytics call::::
    [self performSelectorInBackground:@selector(analyticsLogin:) withObject:animationInfo];
    
    
    int x_Val=0;
    NSArray * imagePaths = [animationInfo objectForKey: kImagesKey];

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
    scrollView.backgroundColor = [UIColor blackColor];
    for(int i = 0 ; i < [imagePaths count] ; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(x_Val, 0, scrollView.frame.size.width, scrollView.frame.size.height)];

        NSURL * url = [NSURL URLWithString: [imagePaths objectAtIndex: i]];
        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
        img.image= [UIImage imageWithContentsOfFile: filePath]; //TODO: should use image with contents of file (from cache)
        [scrollView addSubview:img];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img release];
        x_Val+=scrollView.frame.size.width;
        
    }
    
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*[imagePaths count], 0);
    scrollView.pagingEnabled=YES;
    scrollView.tag = kGalleryViewTag;
    [self addSubview: scrollView];
    [scrollView release];
    
    UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];  
    UIImage * image = [UIImage imageNamed: @"Close.png"];
    [button setImage: image forState: UIControlStateNormal];
    [button sizeToFit];
    button.tag = kButtonTag;
    [button addTarget: self
               action: @selector(closeGalleryView:) 
     forControlEvents: UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(CGRectGetMaxX(scrollView.frame)-30, 
                              scrollView.frame.origin.y-14, 
                              40, 
                              40);
    [self addSubview: button];
    
}

-(void)clearSubViews{
    [[self viewWithTag: kDrawControlKey] setHidden:YES];
    [[self viewWithTag: kButtonTag] setHidden:YES];
}
- (void) playOrPause: (PBTrigger *)trigger {
    
    // Analytics call::::
    
    [[self viewWithTag: kDrawControlKey] setHidden:YES];
    [[self viewWithTag: kButtonTag] setHidden:YES];
    [ self clearSubViews];
    [self sendSubviewToBack:_imageView];
    _movieController.contentURL=trigger.videoUrl;
    switch ([_movieController playbackState]) {
            
        case MPMoviePlaybackStateStopped:
        {
            [_movieController play];
            break;        
        }
            
        case MPMoviePlaybackStatePlaying:
        {
            [_movieController pause];
            break;        
        }    
            
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateInterrupted:
        {
            [_movieController play];
            break;        
        }
    }
    //  [self addSubview:_movieController.view];
}


-(void) playVideo: (id)inSender  {
   
    NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [inSender tag]];

    NSURL *url = [NSURL URLWithString: [animationInfo objectForKey: kURLKey]];
    
    NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];

    
    if(filePath) {
        NSURL * videoFileURL = [NSURL fileURLWithPath: filePath];
        _videoPlayer = [[MPMoviePlayerViewController alloc]  initWithContentURL: videoFileURL];    
        
        //    _videoPlayer.contentURL = url;
        //    _videoPlayer.controlStyle = MPMovieControlStyleEmbedded;
        //    _videoPlayer.view.frame=CGRectMake(64, 320,640, 360); // Should be read from response [inAnimationInfo objectForKey: @"video_location"]
        //    [self addSubview: _videoPlayer.view];
        [[PBArticleViewer sharedInstance] presentModalViewController: _videoPlayer animated: 1];
        [_videoPlayer release];    
    }
    
}

- (PBTrigger *) triggerWithFrame: (CGRect)inFrame selector: (SEL)selector {
    PBTrigger * trigger = [PBTrigger buttonWithType: UIButtonTypeCustom];
    [trigger setImage: [UIImage imageNamed: @"video_play.png"] forState: UIControlStateNormal];
    [trigger setFrame: inFrame]; 
    [trigger addTarget: self action: selector forControlEvents: UIControlEventTouchUpInside];
    return trigger;
}

- (PBTrigger *) triggerWithFrame: (CGRect)inFrame selector: (SEL)selector hyperLinkURL:(NSString *)url {
    PBTrigger * trigger = [PBTrigger buttonWithType: UIButtonTypeCustom];
    [trigger setImage: [UIImage imageNamed: @"video_play.png"] forState: UIControlStateNormal];
    [trigger setFrame: inFrame]; 
    [trigger setHyperLinkUrl:url];
    [trigger addTarget: self action: selector forControlEvents: UIControlEventTouchUpInside];
    return trigger;
}

- (PBTrigger *) triggerWithFrame: (CGRect)inFrame selector: (SEL)selector imageFrame:(CGRect)imgFrame {
    PBTrigger * trigger = [PBTrigger buttonWithType: UIButtonTypeCustom];
    [trigger setImage: [UIImage imageNamed: @"video_play.png"] forState: UIControlStateNormal];
    [trigger setFrame: inFrame]; 
    [trigger addTarget: self action: selector forControlEvents: UIControlEventTouchUpInside];
    return trigger;
}

- (void) updateScrollLocationWithImageURL: (NSString *) imageURL {
    
    NSString *path = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: [NSURL URLWithString: imageURL]];

    if(path)
        [((UIImageView *)[self viewWithTag: kScrollControlKey]) setImage: [UIImage imageWithContentsOfFile: path]];
}

- (void) showNextImage: (PBTrigger *)inTrigger {
  //  PBLog(@" ");
    NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [inTrigger tag]];
    
    NSArray * images  = [animationInfo objectForKey: kImagesKey];
    _currentScrollIndex = (_currentScrollIndex+1)%[images count];
    
    if(_currentScrollIndex < [images count]) { // Array
        [self updateScrollLocationWithImageURL: [images objectAtIndex: _currentScrollIndex]];
    }

}

- (void) showPreviousImage: (PBTrigger *)inTrigger {
    //PBLog(@" ");    
    NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [inTrigger tag]];
    
    NSArray * images  = [animationInfo objectForKey: kImagesKey];
    _currentScrollIndex = (_currentScrollIndex-1)%[images count];
    
    if(_currentScrollIndex < [images count]) { // Array
        [self updateScrollLocationWithImageURL: [images objectAtIndex: _currentScrollIndex]];
    }
}


- (void) openUrl: (PBTrigger *)trigger {
    [[PBArticleViewer sharedInstance] showWebpageWithURL:trigger.hyperLinkUrl];
}

- (void) drawImage: (PBTrigger *)trigger {
    // Analytics call::::
    
    [self performSelectorInBackground:@selector(analyticsLogin:) withObject:nil];
    
    
    NSURL *url = [NSURL URLWithString: trigger.context];
    NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
    [((UIImageView *)[self viewWithTag: kDrawControlKey]) setImage: [UIImage imageWithContentsOfFile: filePath]];
    [((UIImageView *)[self viewWithTag: kDrawControlKey]) setFrame:CGRectFromString(trigger.imageFrame)];
    [((UIImageView *)[self viewWithTag: kDrawControlKey]) setHidden:NO];
    
    if([trigger.closeBool isEqualToString:@"YES"])
        
    {
        
        
        UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];  
        // UIImage * image = [UIImage imageNamed: @"Close.png"];
        // [button setImage: image forState: UIControlStateNormal];
        [button sizeToFit];
        button.tag = kButtonTag;
        [button addTarget: self
                   action: @selector(closeDrawImage:) 
         forControlEvents: UIControlEventTouchUpInside];
        
        button.frame = CGRectFromString(trigger.imageFrame);
        
        [self addSubview: button];
    }
    
    

}

- (void) jumpToAPage: (PBTrigger *)trigger {
    
    if([trigger tag] < [[_articlePage animationList] count]) {
        NSDictionary * animationInfo = [[_articlePage animationList] objectAtIndex: [trigger tag]];
       // [[PBArticleViewer sharedInstance] showArticleWithIndex: [animationInfo objectForKey: @"article"]];
        [[PBArticleViewer sharedInstance] showArticleWithIndex: [animationInfo objectForKey: @"article"]
                                                    pageNumber:[animationInfo objectForKey: @"page"]];
    }
}


#pragma mark - Nest Animation Related

- (void) loadAnimationImageForCurrentNestIndex: (NSNumber *)inIndex {
    
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    
    if(!_nestedAnimationResources) _nestedAnimationResources = [NSMutableArray new];    
    [_nestedAnimationResources removeAllObjects];
        
    NSArray * animationList = [_articlePage animationList];
    NSDictionary * animationInfo = [animationList objectAtIndex: 0];
    
    NSArray * nestInfo = [animationInfo objectForKey: kEffectsKey];    
    
    if(_nestedAnimationIndex < [nestInfo count]) {

        NSArray * animationList = [nestInfo objectAtIndex: _nestedAnimationIndex];
        
        for (NSDictionary *dic  in animationList) {
            
            if ([[dic objectForKey: kAnimationTypeKey] isEqualToString: kSequenceKey]) {

                NSArray * imagePaths = [dic objectForKey: kImagesKey];
                
                for (NSString * path in imagePaths) {
                    
                    NSURL * url = [NSURL URLWithString:path];
                    NSString *localPath = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
                    
                    if(path){
                        UIImage * anImage = [UIImage imageWithContentsOfFile: localPath];            
                        if(anImage) [_nestedAnimationResources addObject: anImage];
                    }            
                }
            }
        }
        
/*        
        NSURL *url = [NSURL URLWithString: [animationInfo objectForKey: kURLKey]];
        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
        
        if (filePath) {
            if(!_audioPlayer)  
                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
            else
                if ([_audioPlayer isPlaying]) [_audioPlayer stop];
            _audioPlayer.volume = [[animationInfo objectForKey: kVolumeKey] floatValue];
            _audioPlayer.numberOfLoops = [[animationInfo objectForKey: kRepeatcountKey] integerValue];
            [_audioPlayer performSelector: @selector(play) withObject: nil afterDelay: 0.012f];
        }
 */       

    }
    _nestedAnimationIndex = (_nestedAnimationIndex+1) % [nestInfo count];
    
    [pool drain];
}


- (void) enableTriggerForNestedAnimation: (NSTimer *)timer {
    ((PBTrigger *)timer.userInfo).userInteractionEnabled = YES;
}

- (void) playNestedAnimation: (PBTrigger *)trigger {

    NSArray * animationList = [_articlePage animationList];
    NSDictionary * animationInfo = [animationList objectAtIndex: trigger.tag];
    
    NSArray * nestInfo = [animationInfo objectForKey: kEffectsKey];
    CGFloat triggerBlockDuration = 0.50f;
    
    if(_nestedAnimationIndex < [nestInfo count]) {
        
        NSArray * animationList = [nestInfo objectAtIndex: _nestedAnimationIndex];
        
        for (NSDictionary *dic  in animationList) {
            
            if ([[dic objectForKey: kAnimationTypeKey] isEqualToString: kSequenceKey]) {
                
//                NSArray * imagePaths = [dic objectForKey: kImagesKey];
//                
//                for (NSString * path in imagePaths) {
//                    
//                    NSURL * url = [NSURL URLWithString:path];
//                    NSString *path = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
//                    
//                    if(path){
//                        UIImage * anImage = [UIImage imageWithContentsOfFile: path];            
//                        if(anImage) [_nestedAnimationResources addObject: anImage];
//                    }
//                }
                
                UIImageView * imageView = (UIImageView *)[self viewWithTag: kNestedAnimationView];
                imageView.animationImages = nil;
                imageView.animationImages = _nestedAnimationResources;
                imageView.animationRepeatCount = [[dic objectForKey: kRepeatcountKey] integerValue];
                imageView.animationDuration = [[dic objectForKey: kDurationKey] floatValue];
                [imageView performSelector: @selector(startAnimating) withObject: nil afterDelay: 0.1f];
                
                if([_nestedAnimationResources count])
                    [_imageView performSelector: @selector(setImage:) withObject: [_nestedAnimationResources lastObject] afterDelay: 0.15f];                  
                
                if (triggerBlockDuration < [[dic objectForKey: kDurationKey] floatValue]) 
                    triggerBlockDuration = [[dic objectForKey: kDurationKey] floatValue];
            }
            
            else if ([[dic objectForKey: kAnimationTypeKey] isEqualToString: kAudioKey]) {

                NSURL *url = [NSURL URLWithString: [dic objectForKey: kURLKey]];
                NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
                
                if (filePath) {
                    if(!_audioPlayer)  
                        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
                    else
                        if ([_audioPlayer isPlaying]) [_audioPlayer stop];
                    _audioPlayer.volume = [[dic objectForKey: kVolumeKey] floatValue];
                    _audioPlayer.numberOfLoops = [[dic objectForKey: kRepeatcountKey] integerValue];
                    [_audioPlayer performSelector: @selector(play) withObject: nil afterDelay: 0.012f];
                    if (triggerBlockDuration < [_audioPlayer duration]) triggerBlockDuration = [_audioPlayer duration];
                }
            }
        }
    } 
    
    if(_nestedAnimationIndex >= [nestInfo count]) _nestedAnimationIndex = 0;
    
    [self performSelectorInBackground: @selector(loadAnimationImageForCurrentNestIndex:) 
                           withObject: [NSNumber numberWithInt: _nestedAnimationIndex]];
    
    trigger.userInteractionEnabled = NO;
    
    [NSTimer scheduledTimerWithTimeInterval: triggerBlockDuration + 0.2f
                                     target: self
                                   selector: @selector(enableTriggerForNestedAnimation:)
                                   userInfo: trigger 
                                    repeats: NO];
}
    

#pragma mark -


- (void) playAnimationOnPageLoad {
    
    //[self playOrPause:nil];
    [(UIImageView *)[self viewWithTag: kSequenceAnimationViewTag] startAnimating];
   
       
}

- (void) playAnimationForPage: (PBArticlePage *)inArticlePage; {
    /*
    for (UIView *current = self; current!=nil; current=current.superview) {
        NSLog(@"View: %@, Bounds: %@, Frame: %@",
              NSStringFromClass([current class]),
              NSStringFromCGRect(current.bounds),
              NSStringFromCGRect(current.frame));
    }
    */
    
   // NSLog(@"Article Number:::: %@",inArticlePage.imageURL);
    
    if(_movieController){
        [_movieController stop];
        _movieController.initialPlaybackTime = -1;
    }
    
    if(_progressHolder.hidden && _loadOverlays) {
        
       // PBLog(@" ############### ");
        _articlePage = inArticlePage;
        
        
        NSArray * animationList = [_articlePage animationList];
        
        if([animationList count]) {
            
            for (int index = 0; index < [animationList count]; index++) {
                
                NSDictionary * animationInfo = [animationList objectAtIndex: index];
                if([animationList count]) {
                    NSString * orientation =  [animationInfo objectForKey: kOrientationKey];
                    
                    if(!orientation) orientation = @"portrait";
                    
                    if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])
                            && ! [orientation isEqualToString:@"portrait"]) {
                        // ignore the animation
                        continue;
                    }

                    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])
                        && ! [orientation isEqualToString:@"landscape"]) {
                        // ignore the animation
                        continue;
                    }

                    NSString * animationType =  [animationInfo objectForKey: kAnimationTypeKey];
                    
                    if([animationType isEqualToString: kSequenceKey]) {
                        
                        //FIXME: handle multiple image sequece case
                        //duration
                        //repeatcount
                        // Prepare for animation in background
                        [self performSelectorInBackground: @selector(playImageSequeceAnimationWithInfo:)
                                               withObject: animationInfo];
                    }else if ([animationType isEqualToString: kImageHyperLink]) {
                        
                        //FIXME: Assuming there can be one draw animation per page
                        
                        PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                            selector: @selector(openUrl:) hyperLinkURL:[animationInfo objectForKey: kHyperlinkUrl]];
                        
                        trigger.tag = index;
                        trigger.hyperLinkUrl=[animationInfo objectForKey: kHyperlinkUrl];
                        
                        [self addSubview: trigger];
                        [_overlays addObject: trigger];
                        
                    }
                    else if ([animationType isEqualToString: kVideoKey]) {
                        
                        if ([animationInfo objectForKey: kControlStyle]) {
                            NSString * controlStyle = [animationInfo objectForKey: kControlStyle];
                            
                            if( [controlStyle isEqualToString: @"fullscreen"]) {
                                PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                                    selector: @selector(playVideo:)];
                                
                                trigger.tag = index;
                                [self addSubview: trigger];
                                [_overlays addObject: trigger];    
                            }
                            
                            else {
                                BOOL autoPlay = [[animationInfo objectForKey: kShouldAutoPlay] isEqualToString: @"true"];
                                CGRect location = CGRectFromString([animationInfo objectForKey: kLocationKey]);
                                CGRect triggerLocation = CGRectFromString([animationInfo objectForKey: kTriggerKey]); 
                                NSURL * videoURL = [NSURL URLWithString: [animationInfo objectForKey: kURLKey]];
                                
                                NSString * filePath = [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: videoURL];
                                
                                if (filePath) {
                                    
                                    NSURL * videoFileURL = [NSURL fileURLWithPath: filePath];
                                    
                                    if(!_movieController) {
                                        
                                        _movieController = [[MPMoviePlayerController alloc] initWithContentURL: videoFileURL];
                                        
                                        if (!autoPlay)
                                            [_movieController setShouldAutoplay:NO];
                                        
                                    }
                                    
                                    else {
                                        _movieController.contentURL = videoFileURL;
                                        //[_movieController setShouldAutoplay:NO];
                                    }
                                    _movieController.view.backgroundColor=[UIColor clearColor];
                                    _movieController.backgroundView.backgroundColor=[UIColor clearColor];
                                    // [_movieController.backgroundView addSubview:_imageView];   
                                    _movieController.view.bounds=self.bounds;
                                    [_movieController.view setFrame: location];
                                    
                                    _movieController.controlStyle = [controlStyle isEqualToString: @"none"] ? MPMovieControlStyleNone : MPMovieControlStyleNone;       
                                    
                                    [[NSNotificationCenter defaultCenter] addObserver:self 
                                                                             selector:@selector(autoplayMethod) 
                                                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                                                               object:_movieController];
                                    
                                    
                                    [self insertSubview: _movieController.view atIndex:0];
                                    
                                    
                                    // [self addSubview:_movieController.view];
                                    
                                    [_movieController prepareToPlay];
                                    
                                    PBTrigger * trigger = [self triggerWithFrame: triggerLocation
                                                                        selector: @selector(playOrPause:)];
                                    
                                    trigger.tag = index;
                                    trigger.videoUrl=videoFileURL;
                                    [self addSubview: trigger];
                                    
                                    [_overlays addObject: trigger];    
                                    [_overlays addObject: _movieController.view];    
                                    // if(autoPlay) {
                                    [self sendSubviewToBack:_imageView];
                                    
                                    // }  else{
                                    //     [self bringSubviewToFront:_imageView];
                                    
                                    // }
                                    
                                    //  if (!autoPlay)
                                    //    [_movieController setShouldAutoplay:NO];
                                    
                                }
                            }
                            
                        }
                        
                        else {
                            PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                                selector: @selector(playVideo:)];
                            
                            trigger.tag = index;
                            [self addSubview: trigger];
                            [_overlays addObject: trigger];    
                            
                        }
                        
                    }
                    
                    else if ([animationType isEqualToString: kSlideShowKey]) {
                        PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                            selector: @selector(showImageGallery:)];
                        
                        trigger.tag = index;
//                       trigger.backgroundColor = [UIColor greenColor];
                        [self addSubview: trigger];
                        [_overlays addObject: trigger];
                        
                    }else if ([animationType isEqualToString: kLargImageKey]) {
                        
                        // Analytics call::::
                        
                        [self performSelectorInBackground:@selector(analyticsLogin:) withObject:animationInfo];
                        
                        
                        NSString * imagePaths = [animationInfo objectForKey: kImagesKey];
                        
                        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
                        scrollView.backgroundColor = [UIColor blackColor];
                        
                        
                        NSURL * url = [NSURL URLWithString: imagePaths];
                        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
                        UIImage *largeImage =[UIImage imageWithContentsOfFile: filePath]; //TODO: should use image with contents of file (from cache)
                        UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,largeImage.size.width,largeImage.size.height )];
                        img.image= largeImage;
                        [scrollView addSubview:img];
                        img.contentMode = UIViewContentModeScaleAspectFit;
                        [img release];
                        
                        
                        
                        
                        scrollView.contentSize=CGSizeMake(img.frame.size.width, img.frame.size.width);
                        scrollView.pagingEnabled=NO;
                        scrollView.tag = kLargImageTag;
                        [self addSubview: scrollView];
                        [scrollView release];                        
                    }
                    
                    else if ([animationType isEqualToString: kAudioKey]) {
                        // TODO: hanlde audio type with params                
                        // url, repeatcount, volume
                        NSURL *url = [NSURL URLWithString: [animationInfo objectForKey: kURLKey]];
                        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
                        
                        if (filePath) {
                            // Analytics call::::
                            
                            [self performSelectorInBackground:@selector(analyticsLogin:) withObject:animationInfo];  
                            if(!_audioPlayer)  
                                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
                            else
                                if ([_audioPlayer isPlaying]) [_audioPlayer stop];
                            _audioPlayer.volume = [[animationInfo objectForKey: kVolumeKey] floatValue];
                            _audioPlayer.numberOfLoops = [[animationInfo objectForKey: kRepeatcountKey] integerValue];
                            [_audioPlayer performSelector: @selector(play) withObject: nil afterDelay: 0.012f];
                        }
                    }
                    
                    else if ([animationType isEqualToString: kDrawKey]) {
                        
                        //FIXME: Assuming there can be one draw animation per page
                        
                        UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
                        
                        imageView.tag = kDrawControlKey;
                        [self addSubview: imageView];
                        [imageView release];
                        [_overlays addObject: imageView];
                        
                        PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                            selector: @selector(drawImage:)imageFrame:CGRectFromString([animationInfo objectForKey: kLocationKey])];
                        
                        trigger.context = [animationInfo objectForKey: kImageKey];
                        trigger.imageFrame=[animationInfo objectForKey: kLocationKey];
                        trigger.closeBool=[animationInfo objectForKey: @"closetrigger"];
                        [self addSubview: trigger];
                        [_overlays addObject: trigger];
                        
                    }else if ([animationType isEqualToString: kPanaromaStyle]) {
                        
                        
                        NSString * imagePaths = [animationInfo objectForKey: kImageKey];
                        
                        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
                        scrollView.backgroundColor = [UIColor clearColor];
                        scrollView.bounces=NO;
                        scrollView.showsVerticalScrollIndicator=NO;
                        scrollView.showsHorizontalScrollIndicator=NO;
                        
                        
                        NSURL * url = [NSURL URLWithString:imagePaths];
                        NSString * filePath =   [[[PBArticleViewer sharedInstance] downloadCache] pathToCachedResponseDataForURL: url];
                        UIImage *largeImage =[UIImage imageWithContentsOfFile: filePath]; //TODO: should use image with contents of file (from cache)
                        UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,largeImage.size.width,largeImage.size.height )];
                        img.image= largeImage;
                        [scrollView addSubview:img];
                        img.contentMode = UIViewContentModeScaleAspectFit;
                        [img release];
                        
                        
                        
                        
                        scrollView.contentSize=CGSizeMake(img.frame.size.width, img.frame.size.height);
                        scrollView.pagingEnabled=NO;
                        scrollView.tag = kLargImageTag;
                        [self addSubview: scrollView];
                      //  [self sendSubviewToBack:scrollView];
                        [scrollView release]; 
                        [_overlays addObject: scrollView];
                    }
                    
                    else if ([animationType isEqualToString: kJumpKey]) {
                        
                        //FIXME: Assuming there can be one draw animation per page
                                          
                        PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                            selector: @selector(jumpToAPage:)];
                        
                        trigger.tag = index;
//                        trigger.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent: 0.4f];
                        [self addSubview: trigger];
                        [_overlays addObject: trigger];
                      
                        /*
                        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 768, 600)];
                        scrollView.backgroundColor = [UIColor blackColor];
                        
                        
                        
                        
                        UIImage *largeImage =[UIImage imageNamed:@"largeimage.png"]; //TODO: should use image with contents of file (from cache)
                        UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,largeImage.size.width,largeImage.size.height )];
                        img.image= largeImage;
                        [scrollView addSubview:img];
                        img.contentMode = UIViewContentModeScaleAspectFit;
                        [img release];
                        
                        
                        
                        
                        scrollView.contentSize=CGSizeMake(img.frame.size.width, img.frame.size.width);
                        scrollView.pagingEnabled=NO;
                        scrollView.tag = kLargImageTag;
                        [self addSubview: scrollView];
                        [scrollView release]; 
                         */
                        
                    }

                    else if ([animationType isEqualToString: kScrollKey]) {
                        
                        // Fix me: show atleast one image in location
                        
                        UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectFromString([animationInfo objectForKey: kLocationKey])];
                        imageView.tag = kScrollControlKey;
//                        imageView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.5f];
                        [self addSubview: imageView];
                        [_overlays addObject: imageView];
                        [imageView release];
                        
                        PBTrigger * leftTrigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kNextTriggerKey])
                                                                selector: @selector(showNextImage:)];
                        
                        PBTrigger * rightTrigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kPreviousTriggerKey])
                                                                 selector: @selector(showPreviousImage:)];
                        
                        leftTrigger.tag = index;
                        rightTrigger.tag = index;
                        
//                        leftTrigger.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: 0.4f];
//                        rightTrigger.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent: 0.4f];                
                        
                        if([[animationInfo objectForKey: kImagesKey] count]) { // Array
                            [self updateScrollLocationWithImageURL: [[animationInfo objectForKey: kImagesKey] objectAtIndex: 0]];
                        }
                        
                        [self addSubview: leftTrigger];
                        [_overlays addObject: leftTrigger];
                        
                        [self addSubview: rightTrigger];
                        [_overlays addObject: rightTrigger];
                    }
                    
                    else if ([animationType isEqualToString: kNestedKey]) {
                        
                        _nestedAnimationIndex = 0;
                        
                        UIImageView * imageView = [[UIImageView alloc] initWithFrame: _imageView.frame];
                        [self addSubview: imageView];
                        imageView.tag = kNestedAnimationView;
                        [imageView release];
                        [_overlays addObject: imageView];

                        PBTrigger * trigger = [self triggerWithFrame: CGRectFromString( [animationInfo objectForKey: kTriggerKey])
                                                            selector: @selector(playNestedAnimation:)];
                        
                        trigger.tag = index;
                        [self addSubview: trigger];                    
                        [_overlays addObject: trigger];  
                        [self performSelectorInBackground: @selector(loadAnimationImageForCurrentNestIndex:) 
                                               withObject: [NSNumber numberWithInt: _nestedAnimationIndex]];
                    }
                    
                }
            }
        }
        _loadOverlays = NO;
    }
    
}
#pragma PGpage Protocal........

-(void) autoplayMethod{
        
    
}
-(void)bringPlayerToFront{
   //  [self bringSubviewToFront:_movieController.view];
   // NSLog(@"moview player notification ........");
    [self bringSubviewToFront:_movieController.view];
    
}

#pragma video notifications
-(void)eventStoped{
    
    
    PBAnalytics * analytics = [[PBAnalytics alloc]init];
    [analytics setDelegate:self];
    [analytics stopAnalyticsDetails];
    [analytics release];

    
}
@end

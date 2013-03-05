//
//  PBArticleViewer.h
//  Publishing
//
//  Created by Ganesh S on 10/20/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

typedef enum{
    eNoteType = 0,
    eHighlightType,
} PBHighlightType;


@class PBOrientedTableView;
@class PBIssue;
@class PBArticle;
@class ASIDownloadCache;
@protocol PBIssueDownloadDelegate;
@class ASINetworkQueue;
@class PBTocView;
@protocol PBPageDelegate;

@interface PBArticleViewer : UIViewController < MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate, 
                                                UITableViewDelegate, UITableViewDataSource,
                                                UIGestureRecognizerDelegate, UIActionSheetDelegate, 
                                                MFMailComposeViewControllerDelegate, UIWebViewDelegate > {
    
    IBOutlet PBOrientedTableView * _pageView;
    UIView *_geastuerView;
    __weak id<PBIssueDownloadDelegate> _progressDelegate;
    id<PBPageDelegate> pageDelegate;

    NSMutableArray * _pages; // items of PBArticle type
    NSMutableArray * _tocItems;
    NSMutableArray *_navigationItems;
                                                    
    ASIDownloadCache * _downloadCache;
    ASINetworkQueue * _queue;   

    IBOutlet UIButton *titleView;
    IBOutlet UIBarButtonItem *tocButtonItem;
    IBOutlet UIBarButtonItem *shareButtonItem;
    IBOutlet UIBarButtonItem *bookMarkButton;
    IBOutlet UIBarButtonItem *_searchItem;
    IBOutlet UITextView *noteView;
    IBOutlet UIButton *_noteViewHolder;
    IBOutlet UIView *noteViewContainer;
    IBOutlet UIView *_tocHolderView;
    IBOutlet UIView *_searchHolder;
                                                    IBOutlet UIView *_helpHolder;
    IBOutlet UITextField *_searchField; 
    IBOutlet UIBarButtonItem *_articleNavigationItem;
                                                
                                                    
    PBIssue * _issue;
    NSString * _rangeForNote;
    NSMutableArray *  _tocThumbUrlArray;
    
    UIPopoverController * _popOverController;
    UIActionSheet *popoverActionsheet;
                                                                                                    
    NSMutableArray *_noteArry; 
    BOOL _isNewNote, _addNavigationItem;
    NSMutableDictionary * _noteInfo;
    UIButton * _customPopOverHolder;
    PBTocView * _tocController;
                                                    
                                                    
}

@property(nonatomic,retain)IBOutlet UIBarButtonItem *bookMarkButton;
@property (nonatomic, retain) IBOutlet UIView *geastuerView;
@property (nonatomic) CGFloat progress;
@property (copy) NSString * rangeForNote;
@property(nonatomic,assign)id<PBPageDelegate> pageDelegate;

+ (PBArticleViewer *) sharedInstance;

- (ASIDownloadCache *) downloadCache;

- (void) showArticlesForIssue: (PBIssue *)inIssue;

- (void) updateDownloadProgressForArticle: (PBArticle *)inArticle;

- (void) pauseDownloadForIssue: (PBIssue *)inIssue;

- (void) showArticleWithIndex: (NSNumber *)inArticleIndex;
- (void) showArticleWithIndex: (NSNumber *)inArticleIndex pageNumber:(NSNumber *)inPageNumber;
- (void) showWebpageWithURL: (NSString *)inURLString;
- (void) resetDataFields;

- (IBAction) popToStoreFront: (id)sender;

- (IBAction) tocCall:(id)sender;

- (IBAction) booMarkClicked:(id)sender;

- (IBAction) removeNote:(id)sender;

- (IBAction) shareButtonClicked:(id)sender;

- (IBAction) showSearchField:(id)sender;

- (IBAction) navigateToPreviousPage:(id)sender;

- (IBAction)showHelpField:(id)sender ;

- (void) updateBookMarkButton;
-(void)displayComposerSheet ;
-(void)launchMailAppOnDevice;
- (void) showNotePage: (NSString *)selectedText;
- (NSMutableArray *) articleNotes;

- (void)reloadRowAtSection:(int)rowitem;

@end
@protocol PBPageDelegate <NSObject>

-(void) autoplayMethod;

@end

@protocol PBIssueDownloadDelegate <NSObject>
@required
- (void) setProgress: (CGFloat)progress;
@end

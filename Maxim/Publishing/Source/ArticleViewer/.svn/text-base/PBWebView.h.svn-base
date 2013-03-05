
#import <Foundation/Foundation.h>

@protocol pbWebViewDelegate <NSObject>
@required
- (void) showNotePage: (NSString *)selectedText;
- (void) saveHiglightForPage: (NSString *)range;
- (void) showWebpageWithURL: (NSString *)inURLString;
- (void) showNoteEditorForTextSelection: (NSString *)selectedText;

@end

@interface PBWebView : UIWebView {
    
    NSURL * url;
    __weak id<pbWebViewDelegate> _delegate;
}
@property (assign) id _delegate;
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void) removeAllHighlights;
//- (void) addCustomMenuItems;
-(void)addNoteButton:(NSInteger ) index;
- (void) highlightRange: (NSString *)inRange;
@end

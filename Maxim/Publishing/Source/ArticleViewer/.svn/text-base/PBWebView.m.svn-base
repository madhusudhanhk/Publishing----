
#import "PBWebView.h"
//#import "PBAppDelegate.h"

@implementation PBWebView
@synthesize _delegate;
- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame: frame];
    {
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(myCopy:)];
        UIMenuItem *wikiMenuItem = [[UIMenuItem alloc] initWithTitle:@"Wiki" action:@selector(searchInWiki:)];
        UIMenuItem *googleMenuItem = [[UIMenuItem alloc] initWithTitle:@"Google" action:@selector(googleSelectedText:)];
        UIMenuItem *noteMenuItem = [[UIMenuItem alloc] initWithTitle:@"Note" action:@selector(showNoteEditor:)];
        UIMenuItem *highlightItem = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(hilightText:)];
        [UIMenuController sharedMenuController].menuItems = [NSArray arrayWithObjects: copyMenuItem,
                                                             noteMenuItem,
                                                            highlightItem, 
                                                             wikiMenuItem, 
                                                             googleMenuItem,  nil];
        [wikiMenuItem release];
        [googleMenuItem release];
        [noteMenuItem release];                
        [copyMenuItem release];
        [highlightItem release];
    }
    return self;
}

-(void)addNoteButton:(NSInteger ) index{
    
    NSString *notePath=@"~/Documents/NoteBook.plist";
    
    // tack existing BookMark data ......
    NSMutableArray *_noteArry ;
    
    _noteArry=[[NSMutableArray alloc]initWithContentsOfFile:[notePath stringByExpandingTildeInPath]];
    
    NSMutableArray *articleArry=[_noteArry objectAtIndex:index];
    
    if([articleArry count]>0){
        for(int i = 0 ; i < [articleArry count] ; i++){
            NSMutableDictionary *dic=[articleArry objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self 
                       action:@selector(noteButtonClicked:)
             forControlEvents:UIControlEventTouchDown];
            button.tag=i;
            [button setTitle:[dic objectForKey:@"note"] forState:UIControlStateNormal];
            button.frame = CGRectMake(600, 100, 160.0, 100);
            [self addSubview:button];
        }
        
    }
    
}

-(void)noteButtonClicked:(id)sender{
    
    // add note view here......
    UIButton *buttn=(UIButton *)sender;
    [_delegate showNotePage:buttn.titleLabel.text];
}

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *startSearch = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender 
{
    if( (action == @selector(searchInWiki:)) || (action == @selector(googleSelectedText:))||
       (action == @selector(showNoteEditor:)) || (action == @selector(myCopy:))|| (action == @selector(hilightText:))||
       (action == @selector(myPaste:)))
    {
        return YES;
    }
    
    if (action == @selector(copy:))
    {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}


- (NSString *) getSelectedText
{
//    NSString * script =  @"var selectedText; var length;" 
//        "function getTextSelection() {"
//        "var text = window.getSelection();"
//    "selectedText = text.focusOffset - text.anchorOffset;"//window.getSelection().toString();"
//    
////    "text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);"
//    "}";
//    [self stringByEvaluatingJavaScriptFromString: script];
//    [self stringByEvaluatingJavaScriptFromString: @"getTextSelection()"];
    
    return [self stringByEvaluatingJavaScriptFromString: @"window.getSelection().toString();"];
}

- (NSString *) getSelectionRange
{
    /*
    [self stringByEvaluatingJavaScriptFromString: script];
    [self stringByEvaluatingJavaScriptFromString: @"getTextRange()"];
    NSString * rangeIndex = [self stringByEvaluatingJavaScriptFromString: @"location"];
    NSLog(@"Location %@ Length  %@", [self stringByEvaluatingJavaScriptFromString: @"location"],
    [self stringByEvaluatingJavaScriptFromString: @"length"]);
    */
    return nil;
}

- (void) highlightRange: (NSString *)inRange {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    [self stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"str2highlight('%@');", inRange]];
}

- (void) hilightText: (id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *range = [self stringByEvaluatingJavaScriptFromString:@"hightlight2str();"];
    if(range) [_delegate saveHiglightForPage: range];
    NSLog(@"range = %@", range);
}

- (void) searchInWiki: (id)sender {

    NSString *query = [self getSelectedText];
    NSLog(@"Text selected = %@, %@", query,  [self getSelectionRange]);    
	NSString *wiki = @"http://en.wikipedia.org/wiki";
	NSString *wikiurl = [[wiki stringByAppendingPathComponent:query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[_delegate showWebpageWithURL: wikiurl];

}

- (void) googleSelectedText: (id)sender {
    // Perform the action here
    NSString *query = [self getSelectedText];
    NSLog(@"Text selected = %@ , %@", query,  [self getSelectionRange]);
	NSString *googleSearchBaseURL = @"http://www.google.com/search?q=";
	NSString *googleURL = [[googleSearchBaseURL stringByAppendingString:query] 
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[_delegate showWebpageWithURL: googleURL];

}

- (void) showNoteEditor: (id)sender {
    [_delegate showNoteEditorForTextSelection: [self getSelectedText]];
}

- (void) myCopy: (id)sender {

//  [[UIPasteboard generalPasteboard] setValue: [self getSelectedText] forPasteboardType: UIPasteboardNameGeneral];
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral
															create:YES];
	appPasteBoard.persistent = YES;
	[appPasteBoard setString:[self getSelectedText]];
    
}

@end

//
//  PBArticleView.m
//  Publishing
//
//  Created by Ganesh S on 10/25/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBArticleView.h"
#import "PBPageView.h"
#import "PBArticleViewer.h"
#import "PBArticle.h"

#define kPageViewTag 34578

@interface PBArticleView ()
- (void) triggerPageAnimation;
@end

@implementation PBArticleView

@synthesize pagesList = _pagesList;

- (id) initWithFrame: (CGRect)frame 
{
    self = [super initWithFrame: frame style: UITableViewStylePlain];
    if (self) {
        // Initialization code here.
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;   
        self.bounces = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

- (void)dealloc {
    self.pagesList = nil;
    [super dealloc];
}

#pragma mark - Article View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [self.pagesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"PBArticlePage2";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: cellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        

    }

    PBArticlePage * page = (PBArticlePage *)[self.pagesList objectAtIndex: indexPath.row];
    PBPageView * pageView = (PBPageView *)[cell.contentView viewWithTag: kPageViewTag];
    NSData * imageData = [[[PBArticleViewer sharedInstance] downloadCache] cachedResponseDataForURL: page.imageURL];
    
    if(!pageView) {        
        pageView = [[PBPageView alloc] initWithFrame: self.frame article: page];
        [cell.contentView addSubview: pageView];
        [pageView setImage: nil forArticle: page];
        pageView.tag = kPageViewTag;
        pageView.backgroundColor = [UIColor darkGrayColor];
        [pageView release];
    }
    [pageView resetPageLayout];
    [pageView setImage: [UIImage imageWithData: imageData] forArticle: page];
   // [pageView playAnimationForPage: page];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return self.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    //[self triggerPageAnimation];
}

- (void) triggerPageAnimation {
    NSInteger row = [[self indexPathForCell: [[self visibleCells] objectAtIndex: 0]] row];
    PBArticlePage * page = (PBArticlePage *)[self.pagesList objectAtIndex:row];
    if([self visibleCells]) {
        if ([[self visibleCells] count]) {
          //  [(PBPageView *)[[[self visibleCells] objectAtIndex: 0] viewWithTag: kPageViewTag] playAnimationOnPageLoad];
            [(PBPageView *)[[[self visibleCells] objectAtIndex: 0] viewWithTag: kPageViewTag] playAnimationForPage:page];
            
            
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
 //  [self triggerPageAnimation]; 
    NSInteger row = [[self indexPathForCell: [[self visibleCells] objectAtIndex: 0]] row];
    
    [self reloadRowAtSection:row];
    [self triggerPageAnimation];
}

- (void)reloadRowAtSection:(int)rowitem {
    NSLog(@"Row item ......%d",rowitem);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowitem inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [indexPaths release];
    
   
    
    
}
@end

//
//  PBIssuePreviewController.m
//  Publishing
//
//  Created by Ganesh S on 10/24/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBIssuePreviewController.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASINetworkQueue.h"


@implementation PBIssuePreviewController

@synthesize paginationView = _paginationView;
@synthesize _previewImageUrlArry;
@synthesize scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paginationView.orientedTableViewDataSource = self;
    self.paginationView.pagingEnabled = 1;
    self.paginationView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.paginationView.backgroundColor = [UIColor blackColor];
    self.paginationView.tableViewOrientation = ePBTableViewOrientationHorizontal;
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                           target: self
                                                                           action: @selector(dismissViewController:)];
    self.navigationController.navigationBar.tintColor=[UIColor clearColor];
    self.title=@"Preview";
    self.navigationItem.rightBarButtonItem = item;
    
    [item release];
    
    scrollView.hidden = 1;
//    [self previewcreation];
    [self.paginationView reloadData];

}


-(void)previewcreation{

    scrollView.backgroundColor = [UIColor blackColor];
    int x_Val=0;
    for(int i = 1 ; i < 5 ; i++){
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x_Val, 0, 
                                                                      scrollView.frame.size.width,
                                                                      scrollView.frame.size.height)];
        
        img.image=[UIImage imageNamed:[NSString stringWithFormat:@"La-off-art1pg%d.jpg",i]];
        img.contentMode=UIViewContentModeCenter;
       // img.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [scrollView addSubview:img];
        x_Val+=img.frame.size.width;
        [img release];
        
    }
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*4, 0);
    scrollView.pagingEnabled=YES;
}
- (void)viewDidUnload
{
    self.paginationView = nil;
    self.scrollView=nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
        [self.paginationView reloadData];
    PBLog(@"{frame, bounds} {%@, %@}", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.paginationView reloadData];
}

- (void) dismissViewController: (id)inSender {
    [self.navigationController dismissModalViewControllerAnimated: 1];
}

#pragma mark - Web API interface


#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [_previewImageUrlArry count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 540;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PreviewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    UIImageView * imageView = (UIImageView *)[cell.contentView viewWithTag: 32897];
    if(!imageView) {
        imageView = [[UIImageView alloc] initWithFrame: tableView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 32897;
        [cell.contentView addSubview: imageView];
        imageView.backgroundColor = [UIColor blackColor];
        
        [imageView release];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = self.view.bounds;
    imageView.image = [self image:[_previewImageUrlArry objectAtIndex:indexPath.row]];
    return cell;
}

- (UIImage *) image:(NSString *)imageUrl {
    
    
    
    
    
    ASIDownloadCache * _cache = [ASIDownloadCache sharedCache];
    
    NSString *path = [_cache pathToCachedResponseHeadersForURL: [NSURL URLWithString: imageUrl]];
    
    if(path) {
        _image = [[UIImage imageWithData: [_cache cachedResponseDataForURL: [NSURL URLWithString: imageUrl]]] retain];
        return _image;
    }
    
    
    
    return nil;
}


@end

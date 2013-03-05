//
//  PBBookMark.m
//  Publishing
//
//  Created by Madhusudhan  HK on 19/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBBookMark.h"
#import "PBBookMarkCell.h"
#import "ASIDownloadCache.h"
#import "PBArticleViewer.h"

@implementation PBBookMark

@synthesize delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_bookMarkList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void) dismissController {
    [self dismissModalViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"BookMark", nil);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                           target: self action: @selector(dismissController)];
    self.navigationController.navigationBar.tintColor=[UIColor clearColor];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    // Do any additional setup after loading the view from its nib.
    // Handle download based on issue state
//    if(!_downloadCache)
//        _downloadCache = [[ASIDownloadCache alloc] init];
    
    
    // adding dummy data for testing...........
    
//    [self bookMarkdata];
    
     self.tableView.rowHeight=122;
    _bookMarkList = [[NSMutableArray alloc]initWithContentsOfFile:[kBookMarkPath stringByExpandingTildeInPath]]; 
    
    

}

-(void)bookMarkdata{
    /*
    NSMutableArray *bookMarkArry=[[NSMutableArray alloc]init];
    for(int i=0 ; i<5 ; i++){
        
   
    NSMutableDictionary *newScore = [[NSMutableDictionary alloc] init];
    [newScore setValue:@"Page Number 10" forKey:@"pageNo"];
        [newScore setValue:@"AUGUST" forKey:@"articleName"];
        [newScore setValue:@"ACK" forKey:@"pubName"];
        [newScore setValue:@"image/1.png" forKey:@"imagePath"];
        
    
    [bookMarkArry addObject:newScore];
        [newScore release];
        
    }
    [bookMarkArry writeToFile:[kBookMarkPath stringByExpandingTildeInPath] atomically:YES];
    [bookMarkArry release];
     */
}
- (void)viewDidUnload
{
    [_bookMarkList release];
    _bookMarkList = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_bookMarkList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PBBookMarkCell";
	
    PBBookMarkCell *cell = (PBBookMarkCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PBBookMarkCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (PBBookMarkCell *) currentObject;
				cell.backgroundView.backgroundColor = [UIColor clearColor];
				break;
			}
		}
	}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // BookMark data from plist 
    
    NSMutableDictionary *bmDictionary =[_bookMarkList objectAtIndex:indexPath.row];
    cell._bmTitle.text=[bmDictionary objectForKey:kBookMarkTitle];
    cell._bmPageNumber.text=[[bmDictionary objectForKey:kBookMarkPageNumber] stringValue];
    NSURL *url = [NSURL URLWithString:[bmDictionary objectForKey:kBookMarkImageUrl]];
    NSData * data = [[ASIDownloadCache sharedCache] cachedResponseDataForURL: url];    
    UIImage *image =  [UIImage imageWithData: data];
    cell._bmImage.image=image;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{     
    
    if([delegate respondsToSelector: @selector(bookmark:didChooseBookmarkItem:)]) {
        [delegate bookmark: self didChooseBookmarkItem: [_bookMarkList objectAtIndex: [indexPath row]]];
    }
}

@end

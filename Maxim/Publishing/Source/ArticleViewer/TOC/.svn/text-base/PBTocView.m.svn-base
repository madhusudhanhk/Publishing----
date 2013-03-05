//
//  PBTocView.m
//  Publishing
//
//  Created by Madhusudhan  HK on 25/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBTocView.h"
#import "PBTocCell.h"
#import "PBArticle.h"
#import "ASIDownloadCache.h"
#import "PBArticleViewer.h"

@implementation PBTocView
@synthesize _tocTableView;
@synthesize _tocImageArry, delegate;

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
    [_tocTableView release];
    [_tocImageArry release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight=106.0f;
    self.tableView.delegate=self;
 // self.tableView.backgroundColor = [UIColor grayColor];
    
    
  self.tableView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"StorePattern.png"]];   
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self._tocTableView=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tocImageArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"PBTocCell";
	
    PBTocCell *cell = (PBTocCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed: @"PBTocCell" 
                                                                 owner: self 
                                                               options: nil];
		
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell =  (PBTocCell *) currentObject;
			//	cell.backgroundColor = [UIColor colorWithWhite:0.087 alpha:1.000];
				break;
			}
		}
	}
    
 //   cell.contentView.backgroundColor = [UIColor colorWithWhite:0.087 alpha:1.000];   

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PBArticle *art;
    art = [_tocImageArry objectAtIndex: indexPath.row];
    //NSLog(@"art.thumbnailURL.....%@",art.thumbnailURL);   
    cell._articleTitle.text = art.title;    
    NSData *imageData=[[ASIDownloadCache sharedCache] cachedResponseDataForURL: art.thumbnailURL];
    cell._articleThumbImage.image = [UIImage imageWithData: imageData];
    [(UIImageView *)[cell viewWithTag: 700] setImage: (indexPath.row % 2) ? [UIImage imageNamed: @"Box_02.png"] : [UIImage imageNamed: @"Box_03.png"]];
    return cell;
}

- (CGSize) contentSizeForViewInPopover {
    return CGSizeMake(300.0f, 700);
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
    if([delegate respondsToSelector: @selector(navigateToArticle:)])
        [delegate navigateToArticle: [_tocImageArry objectAtIndex: indexPath.row]]; 
}

@end

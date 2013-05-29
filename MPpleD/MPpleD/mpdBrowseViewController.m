//
//  mpdBrowseViewController.m
//  MPpleD
//
//  Created by Apple on 13-5-10.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "mpdBrowseViewController.h"

@interface mpdBrowseViewController ()

@end

@implementation mpdBrowseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchController = [[browseList alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.searchController browseCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"browseItem";
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //	if (cell == nil)
    //	{
    //		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //	}
    
    // Configure the cell...
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [[cell textLabel] setText:[self.searchController browseAtIndex:indexPath.row]];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [[cell textLabel] setText:[self.searchController browseAtIndex:indexPath.row]];
    }
    
    
    //    UILongPressGestureRecognizer *longPressGesture =
    //    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //    [cell addGestureRecognizer:longPressGesture];
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchController addSongAtIndexToQueue:indexPath.row];
}

- (void) onSearch:(id)sender {
    
}

- (void)filterContentForSearchText:(NSString*)searchString scope:(int)scope {
    int nType = MPD_TAG_TITLE;
    switch (scope) {
        case 0:
            nType = MPD_TAG_TITLE;
            break;
        case 1:
            nType = MPD_TAG_ALBUM;
            break;
        case 2:
            nType = MPD_TAG_ARTIST;
            break;
            
        default:
            break;
    }
    if (scope == 0) {
        
    }
//    [self.searchController initializeDataList:searchString tagtype:nType];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:searchString forKey:@"searchkey"];
    [dic setObject:[NSNumber numberWithInt:nType] forKey:@"type"];
//    [NSThread detachNewThreadSelector:@selector(searchBrowse:) toTarget:self withObject:dic];
//    [self searchBrowse:dic];
    [self performSelector:@selector(searchBrowse:) withObject:dic afterDelay:0.1];
}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//
- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString {
    [self filterContentForSearchText: searchString
                               scope: [self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    return YES;
}

- (void) searchBrowse:(NSDictionary*)dic {
    NSLog(@"search browse");
    NSString* str = [dic objectForKey:@"searchkey"];
    int nType = [[dic objectForKey:@"type"] intValue];
    [self.searchController initializeDataList:str tagtype:nType];
//    [self.tableView reloadData];
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}
- (void) updateUI {
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
    if([self.searchDisplayController isActive]) {
    }
    else {
    }
}
@end

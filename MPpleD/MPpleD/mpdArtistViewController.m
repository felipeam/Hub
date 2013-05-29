//
//  mpdArtistViewController.m
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/20/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "mpdArtistViewController.h"
#import "artistList.h"
#import "mpdAlbumViewController.h"

@interface mpdArtistViewController ()

@end

@implementation mpdArtistViewController

- (void)awakeFromNib
{    
    [super awakeFromNib];    
}

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
    self.sections = [NSArray arrayWithObjects:@"#", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    searchBar.showsScopeBar = YES;
//    [searchBar sizeToFit];
//    searchBar.delegate = self;
//    //    searchBar.scopeButtonTitles = [NSArray arrayWithObjects: @"All", @"Device", @"Desktop", @"Portable", nil];
//    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    //    searchBar.selectedScopeButtonIndex = 0;
//    searchBar.placeholder = @"Search";
//    
//    UISearchDisplayController *searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController: self];
//    searchDC.delegate = self;
//    searchDC.searchResultsDataSource = self;
//    searchDC.searchResultsDelegate = self;
//    self.aSearchDisplayController = searchDC;

//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
//    searchBar.delegate = self;
//    [searchBar setShowsCancelButton:YES];
//    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchDisplayController.delegate = self;
//    searchDisplayController.searchResultsDelegate = self;
//    searchDisplayController.searchResultsDataSource = self;
    
//    self.tableView.tableHeaderView = self.aSearchDisplayController.searchBar;
//    [self.aSearchDisplayController.searchBar becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataController = [[artistList alloc] init];
    self.searchController = [[artistList alloc] init];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 27;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSUInteger rowCount = 0;
    if(tableView == self.searchDisplayController.searchResultsTableView)
        rowCount = [[self.searchController sectionArray:section] count];
    else
        rowCount = [[self.dataController sectionArray:section ] count];
    if(rowCount == 0)
        return nil;
    return [self.sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [[self.searchController sectionArray:section] count];
    return [[self.dataController sectionArray:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"artistItem";
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
        [[cell textLabel] setText:[self.searchController artistAtSectionAndIndex:indexPath.section row:indexPath.row]];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [[cell textLabel] setText:[self.dataController artistAtSectionAndIndex:indexPath.section row:indexPath.row]];
    }
    
    
//    UILongPressGestureRecognizer *longPressGesture =
//    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"ShowArtistAlbums" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"%@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"ShowArtistAlbums"]) {
        
         mpdAlbumViewController *albumViewController = [segue destinationViewController];
        
        if([self.searchDisplayController isActive]) {
            NSIndexPath* indexPath = self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow;
            albumViewController.artistFilter = [self.searchController artistAtSectionAndIndex:indexPath.section row:indexPath.row];
            albumViewController.navigationItem.title = [self.searchController artistAtSectionAndIndex:indexPath.section row:indexPath.row];
        }
        else {
            NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;
            albumViewController.artistFilter = [self.dataController artistAtSectionAndIndex:indexPath.section row:indexPath.row];
            albumViewController.navigationItem.title = [self.dataController artistAtSectionAndIndex:indexPath.section row:indexPath.row];
        }
    }
    
}


-(IBAction)backToArtistClick:(UIStoryboardSegue *)segue
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    return;
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
		// do something with this action
        if(self.tableView == self.searchDisplayController.searchResultsTableView)
            [self.searchController addArtistAtSectionAndIndexToQueue:indexPath.section row:indexPath.row];
        else
            [self.dataController addArtistAtSectionAndIndexToQueue:indexPath.section row:indexPath.row];
	}
}

- (void) onSearch:(id)sender {
    
}

- (void)filterContentForSearchText:(NSString*)searchString scope:(NSString*)scope {
    [self.searchController initializeDataList:searchString];
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
                               scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
@end

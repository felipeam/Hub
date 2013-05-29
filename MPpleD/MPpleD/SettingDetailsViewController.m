//
//  SettingDetailsViewController.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "SettingDetailsViewController.h"
#import "SettingInfo.h"

@interface SettingDetailsViewController ()

@end

@implementation SettingDetailsViewController

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString*) getCellText:(NSIndexPath *)indexPath {
    NSString* str;
    
    switch (g_SettingInfo.m_nSettingSection) {
        case SETTINGSECTION_DATA:
            switch (g_SettingInfo.m_nSettingSectionRow) {
                case 0: //Artist
                    if (indexPath.row == 0)
                        str = @"All";
                    else
                        str = @"Only with full album(s)";
                    break;
                case 1: //Artist capitaliztion
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
                case 2: //Album
                    if (indexPath.row == 0)
                        str = @"Group by album title";
                    else
                        str = @"Group by directory";
                    break;
                case 3: //Album order
                    if (indexPath.row == 0)
                        str = @"By title";
                    else
                        str = @"By artist";
                    break;
                case 4: //Auto refresh cache
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
                default:
                    break;
            }
            break;
        case SETTINGSECTION_PLAY:
            switch (g_SettingInfo.m_nSettingSectionRow) {
                case 0: //Default click action
                    switch (indexPath.row) {
                        case 0:
                            str = @"Play now";
                            break;
                        case 1:
                            str = @"Play next";
                            break;
                        case 2:
                            str = @"Play only";
                            break;
                        case 3:
                            str = @"add to playlist";
                            break;
                            
                        default:
                            break;
                    }
                    break;
                case 1: //Consume
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
                case 2: //Shake
                    switch (indexPath.row) {
                        case 0:
                            str = @"None";
                            break;
                        case 1:
                            str = @"Random album";
                            break;
                        case 2:
                            str = @"10 Random songs";
                            break;
                        case 3:
                            str = @"25 Random songs";
                            break;
                        case 4:
                            str = @"50 Random songs";
                            break;
                        case 5:
                            str = @"100 Random songs";
                            break;
                            
                        default:
                            break;
                    }
                    break;
            }
            break;
        case SETTINGSECTION_COVERART:
            switch (g_SettingInfo.m_nSettingSectionRow) {
                case 0: //Fetch local cover art
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
                case 1: //Fetch from amazon
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
                case 2: //Fetch from discogs
                    if (indexPath.row == 0)
                        str = @"Off";
                    else
                        str = @"On";
                    break;
            }
            break;

        default:
            break;
    }
    return str;
}
- (int) getRowCount {
    int count = 2;
    switch (g_SettingInfo.m_nSettingSection) {
        case SETTINGSECTION_DATA:
            break;
        case SETTINGSECTION_PLAY:
            switch (g_SettingInfo.m_nSettingSectionRow) {
                case 0: //Default click action
                    count = 4;
                    break;
                case 1: //Consume
                    break;
                case 2: //Shake
                    count = 6;
                    break;
            }
            break;
        case SETTINGSECTION_COVERART:
            break;
            
        default:
            break;
    }
    return count;
}
- (NSString*) getFootString:(NSIndexPath *)indexPath {
    return nil;
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
    return [self getRowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self getCellText:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    // Configure the cell...
    
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
}

@end

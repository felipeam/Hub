//
//  SettingsViewController.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingInfo.h"
#import "SettingDetailsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.title = @"Settings";
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    self.navigationItem.leftBarButtonItem = right;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSString*) getCellText:(NSIndexPath *)indexPath {
    NSString* str = @"";
    switch (indexPath.section) {
        case SETTINGSECTION_HELP:
            if (indexPath.row == 0)
                str = @"About MPod";
            else
                str = @"Help";
            break;
        case SETTINGSECTION_SERVERACTIONS:
            if (indexPath.row == 0)
                str = @"Refresh local cache";
            else
                str = @"Update database";
            break;
        case SETTINGSECTION_DATA:
            switch (indexPath.row) {
                case 0:
                    str = @"Artist";
                    break;
                case 1:
                    str = @"Artist capitalization";
                    break;
                case 2:
                    str = @"Album";
                    break;
                case 3:
                    str = @"Album order";
                    break;
                case 4:
                    str = @"Auto refresh cache";
                    break;
                default:
                    break;
            }
            break;
        case SETTINGSECTION_PLAY:
            switch (indexPath.row) {
                case 0:
                    str = @"Default click action";
                    break;
                case 1:
                    str = @"Consume";
                    break;
                case 2:
                    str = @"Shake";
                    break;
                default:
                    break;
            }
            break;
        case SETTINGSECTION_COVERART:
            switch (indexPath.row) {
                case 0:
                    str = @"Fetch local cover art";
                    break;
                case 1:
                    str = @"Fetch from Amazon";
                    break;
                case 2:
                    str = @"Fetch from Discogs";
                    break;
                case 3:
                    str = @"Clear cover art cach";
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return str;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int nRet = 0;
    switch (section) {
        case SETTINGSECTION_HELP:
            nRet = 2;
            break;
        case SETTINGSECTION_SERVERACTIONS:
            nRet = 2;
            break;
        case SETTINGSECTION_DATA:
            nRet = 5;
            break;
        case SETTINGSECTION_PLAY:
            nRet = 3;
            break;
        case SETTINGSECTION_COVERART:
            nRet = 4;
            break;
            
        default:
            break;
    }
    return nRet;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* str = nil;
    switch (section) {
        case SETTINGSECTION_HELP:
            break;
        case SETTINGSECTION_SERVERACTIONS:
            str = @"Server actions";
            break;
        case SETTINGSECTION_DATA:
            str = @"Data";
            break;
        case SETTINGSECTION_PLAY:
            str = @"Play";
            break;
        case SETTINGSECTION_COVERART:
            str = @"Cover art";
            break;
            
        default:
            break;
    }
    return str;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.section*6+indexPath.row];
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self getCellText:indexPath];
        switch (indexPath.section) {
            case SETTINGSECTION_HELP:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case SETTINGSECTION_SERVERACTIONS:
                break;
            case SETTINGSECTION_DATA:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case SETTINGSECTION_PLAY:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case SETTINGSECTION_COVERART:
                if (indexPath.row != 3)
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            default:
                break;
        }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    g_SettingInfo.m_nSettingSection = indexPath.section;
    g_SettingInfo.m_nSettingSectionRow = indexPath.row;
    SettingDetailsViewController* ctrl = nil;
    switch (indexPath.section) {
        case SETTINGSECTION_HELP:
            break;
        case SETTINGSECTION_SERVERACTIONS:
            break;
        case SETTINGSECTION_DATA:
            ctrl = [[SettingDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case SETTINGSECTION_PLAY:
            ctrl = [[SettingDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
        case SETTINGSECTION_COVERART:
            if (indexPath.row < 3)
            ctrl = [[SettingDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            break;
            
        default:
            break;
    }
    if (ctrl != nil)
        [self.navigationController pushViewController:ctrl animated:YES];
}

@end

//
//  PlayerSettingViewController.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "PlayerSettingViewController.h"
#import "PlayerInfo.h"
#import "GameUnit.h"
#import "PlayerDetailsViewController.h"

@interface PlayerSettingViewController ()

@end

@implementation PlayerSettingViewController

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
     self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSave:)];
    self.tableView.allowsSelectionDuringEditing = YES;
//    self.m_playerBackup = [[PlayerInfo alloc] initWithPlayer:g_GameUnit.m_player];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void) onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) onSave:(id)sender {
    if (g_GameUnit.m_nSelPlayer == NEW_PLAYER) {
        [g_GameUnit.m_arrayPlayers addObject:g_GameUnit.m_player];
    }
    else {
        [g_GameUnit.m_arrayPlayers replaceObjectAtIndex:g_GameUnit.m_nSelPlayer withObject:g_GameUnit.m_player];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*) getCellText:(NSIndexPath *)indexPath {
    int nType = indexPath.section*2+indexPath.row;
    return [PlayerInfo getPlayerSettingText:nType];
}
- (NSString*) getCellValueText:(NSIndexPath *)indexPath {
    NSString* str = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            str = g_GameUnit.m_player.m_strName;
        else {
            str = [PlayerInfo getPlayerConnectionModeText:g_GameUnit.m_player.m_nConnectionMode];
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
                str = g_GameUnit.m_player.m_strMPDServer;
                break;
            case 1:
                str = g_GameUnit.m_player.m_strMPDPort;
                break;
            case 2:
                str = g_GameUnit.m_player.m_strMPDPassword;
                break;
            case 3:
                str = [PlayerInfo getPlayerUseLocalCacheText:g_GameUnit.m_player.m_bMPDLocalCache];
                break;
                
            default:
                break;
        }
    }
//    NSLog(@"%@", str);
    return str;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Connection";
    else
        return @"MPD";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.section*6+indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self getCellText:indexPath];
        if (indexPath.section == 0) {
            if (indexPath.row == 1)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            if (indexPath.row == 3)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(140, 7, 134, 30)];
        label.textColor = [UIColor blueColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 0x10;
        [cell.contentView addSubview:label];
    }
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:0x10];
    if (label) {
        label.text = [self getCellValueText:indexPath];
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
    g_GameUnit.m_nSelPlayerInfoId = indexPath.section*2+indexPath.row;
    PlayerDetailsViewController *detailViewController = [[PlayerDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end

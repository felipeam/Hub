//
//  PlayerDetailsViewController.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "PlayerDetailsViewController.h"
#import "GameUnit.h"
#import "PlayerInfo.h"

@interface PlayerDetailsViewController ()

@end

@implementation PlayerDetailsViewController

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
    self.title = [PlayerInfo getPlayerSettingText:g_GameUnit.m_nSelPlayerInfoId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    switch (g_GameUnit.m_nSelPlayerInfoId) {
        case kPlayerName:
            g_GameUnit.m_player.m_strName = m_textField.text;
            break;
        case kPlayerMPDServer:
            g_GameUnit.m_player.m_strMPDServer = m_textField.text;
            break;
        case kPlayerMPDPort:
            g_GameUnit.m_player.m_strMPDPort = m_textField.text;
            break;
        case kPlayerMPDPassword:
            g_GameUnit.m_player.m_strMPDPassword = m_textField.text;
            break;
        default:
            break;
    }
    NSLog(@"%@", m_textField.text);
    [super viewWillDisappear:animated];
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
    int nRet = 1;
    switch (g_GameUnit.m_nSelPlayerInfoId) {
        case kPlayerName:
            nRet = 1;
            break;
        case kPlayerConnectionMode:
            nRet = 2;
            break;
        case kPlayerMPDServer:
            nRet = 1;
            break;
        case kPlayerMPDPort:
            nRet = 1;
            break;
        case kPlayerMPDPassword:
            nRet = 1;
            break;
        case kPlayerMPDUseLocalCache:
            nRet = 2;
            break;
            
        default:
            break;
    }
    return nRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        CGRect rtText = CGRectMake(14, 8, 280, 28);
        UIFont* font = [UIFont systemFontOfSize:22];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        switch (g_GameUnit.m_nSelPlayerInfoId) {
            case kPlayerName:
            {
                if (m_textField == nil) {
                    m_textField = [[UITextField alloc] initWithFrame:rtText];
                    m_textField.backgroundColor = [UIColor clearColor];
                    m_textField.font = font;
                    [cell.contentView addSubview:m_textField];
                    m_textField.text = g_GameUnit.m_player.m_strName;
                    [m_textField becomeFirstResponder];
                }
            }
                break;
            case kPlayerConnectionMode:
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Remote";
                }
                else {
                    cell.textLabel.text = @"On the go";
                }
                break;
            case kPlayerMPDServer:
                if (m_textField == nil) {
                    m_textField = [[UITextField alloc] initWithFrame:rtText];
                    m_textField.font = font;
                    m_textField.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:m_textField];
                    m_textField.text = g_GameUnit.m_player.m_strMPDServer;
                    [m_textField becomeFirstResponder];
                }
                break;
            case kPlayerMPDPort:
                if (m_textField == nil) {
                    m_textField = [[UITextField alloc] initWithFrame:rtText];
                    m_textField.backgroundColor = [UIColor clearColor];
                    m_textField.font = font;
                    m_textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell.contentView addSubview:m_textField];
                    m_textField.text = g_GameUnit.m_player.m_strMPDPort;
                    [m_textField becomeFirstResponder];
                }
                break;
            case kPlayerMPDPassword:
                if (m_textField == nil) {
                    m_textField = [[UITextField alloc] initWithFrame:rtText];
                    m_textField.secureTextEntry = YES;
                    m_textField.backgroundColor = [UIColor clearColor];
                    m_textField.font = font;
                    [cell.contentView addSubview:m_textField];
                    m_textField.text = g_GameUnit.m_player.m_strMPDPassword;
                    [m_textField becomeFirstResponder];
                }
                break;
            case kPlayerMPDUseLocalCache:
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Yes";
                }
                else {
                    cell.textLabel.text = @"No";
                }
                break;
                
            default:
                break;
        }
    }
    if (g_GameUnit.m_nSelPlayerInfoId == kPlayerConnectionMode) {
        if (g_GameUnit.m_player.m_nConnectionMode == CONNECTIONMODE_REMOTE) {
            if (indexPath.row == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            if (indexPath.row == 1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if (g_GameUnit.m_nSelPlayerInfoId == kPlayerMPDUseLocalCache) {
        if (g_GameUnit.m_player.m_bMPDLocalCache == YES) {
            if (indexPath.row == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            if (indexPath.row == 1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
    if (g_GameUnit.m_nSelPlayerInfoId == kPlayerConnectionMode) {
        g_GameUnit.m_player.m_nConnectionMode = indexPath.row;
        [tableView reloadData];
    }
    if (g_GameUnit.m_nSelPlayerInfoId == kPlayerMPDUseLocalCache) {
        g_GameUnit.m_player.m_bMPDLocalCache = 1-indexPath.row;
        [tableView reloadData];
    }
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

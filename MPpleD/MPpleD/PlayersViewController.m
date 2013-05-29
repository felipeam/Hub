//
//  PlayersViewController.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "PlayersViewController.h"
#import "GameUnit.h"
#import "PlayerInfo.h"
#import "PlayerSettingViewController.h"
#import <QuartzCore/CALayer.h>  
#import <mpd/client.h>
#import "mpdConnectionData.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController

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
    self.title = @"Players";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStyleBordered target:self action:@selector(onRemove:)];
    self.tableView.allowsSelectionDuringEditing = YES;
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

- (void) onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) onRemove:(id)sender {
    if (self.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStyleBordered target:self action:@selector(onRemove:)];
        self.editing = NO;
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onRemove:)];
        self.editing = YES;
    }
}
- (void) onAdvanced:(UIButton*)btn {
    int index = btn.tag - 0x20;
    g_GameUnit.m_nSelPlayer = index;
    g_GameUnit.m_player = [[PlayerInfo alloc] initWithPlayer:[g_GameUnit.m_arrayPlayers objectAtIndex:index]];
    PlayerSettingViewController *detailViewController = [[PlayerSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void) connectToServer:(int)playerid {
    NSLog(@"%s\n", __func__);
    g_GameUnit.m_nSelServerPlayer = playerid;
    PlayerInfo* player = [g_GameUnit.m_arrayPlayers objectAtIndex:playerid];
    struct mpd_connection *conn;
    mpdConnectionData *globalConnection = [mpdConnectionData sharedManager];
    globalConnection.host = player.m_strMPDServer;
    globalConnection.port = [[NSNumber alloc] initWithInt:[player.m_strMPDPort intValue]];
    const char *host = [player.m_strMPDServer UTF8String];
    int port = [player.m_strMPDPort intValue];
    
	conn = mpd_connection_new(host, port, 3000);
    
	if (mpd_connection_get_error(conn) != MPD_ERROR_SUCCESS) {
//        self.connectionLabel.text = @"Connection Failed";
        NSLog(@"Connection Failed");
    }
    else
    {
//        self.connectionLabel.text = @"Connected to MPD!";
        NSLog(@"Connection to MPD!");
    }
    
    mpd_connection_free(conn);
}

static int handle_error(struct mpd_connection *c)
{
	assert(mpd_connection_get_error(c) != MPD_ERROR_SUCCESS);
    
	fprintf(stderr, "%s\n", mpd_connection_get_error_message(c));
	mpd_connection_free(c);
	return EXIT_FAILURE;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 80;
    else
        return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Configured players";
    else
        return @"Manual";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [g_GameUnit.m_arrayPlayers count];
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.section];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (indexPath.section == 0) {
            UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 16)];
            labelName.textColor = [UIColor blueColor];
            labelName.font = [UIFont systemFontOfSize:14];
            labelName.backgroundColor = [UIColor clearColor];
            labelName.tag = 0x10;
            [cell.contentView addSubview:labelName];
            UILabel* labelServer = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 14)];
            labelServer.backgroundColor = [UIColor clearColor];
            labelServer.textColor = [UIColor blueColor];
            labelServer.font = [UIFont systemFontOfSize:12];
            labelServer.tag = 0x11;
            [cell.contentView addSubview:labelServer];
            
            UIImageView* imgWifi = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 29, 22)];
            imgWifi.image = [UIImage imageNamed:@"wifi-off-29x22.png"];
            imgWifi.tag = 0x12;
            [cell.contentView addSubview:imgWifi];

            UIImageView* imgRemote = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 21, 22)];
            imgRemote.image = [UIImage imageNamed:@"remote-21x22.png"];
            imgRemote.tag = 0x13;
            [cell.contentView addSubview:imgRemote];
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(220, 50, 80, 22);
            [btn setTitle:@"Advanced" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor lightGrayColor]];
            btn.tag = 0x20+indexPath.row;
            [btn.layer setCornerRadius:10.0];
            [btn.layer setBorderColor:[UIColor grayColor].CGColor];
            [btn.layer setBorderWidth:1.0];
            [btn addTarget:self action:@selector(onAdvanced:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:btn];
        }
        else {
            cell.textLabel.text = @"Add player manually";
        }
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        PlayerInfo* player = [g_GameUnit.m_arrayPlayers objectAtIndex:indexPath.row];
        UILabel* labelName = (UILabel*)[cell.contentView viewWithTag:0x10];
        labelName.text = player.m_strName;
        UILabel* labelServer = (UILabel*)[cell.contentView viewWithTag:0x11];
        labelServer.text = player.m_strMPDServer;
        UIImageView* imgRemote = (UIImageView*)[cell.contentView viewWithTag:0x13];
        if (player.m_nConnectionMode == CONNECTIONMODE_REMOTE)
            imgRemote.image = [UIImage imageNamed:@"remote-21x22.png"];
        else
            imgRemote.image = [UIImage imageNamed:@"on-the-go-21x22.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == g_GameUnit.m_nSelServerPlayer) {
            cell.backgroundColor = [UIColor colorWithHue:0.61
                                              saturation:0.09
                                              brightness:0.99
                                                   alpha:1.0];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [g_GameUnit.m_arrayPlayers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    
    if (indexPath.section == 1) {
        g_GameUnit.m_nSelPlayer = NEW_PLAYER;
        g_GameUnit.m_player = [[PlayerInfo alloc] init];
        PlayerSettingViewController *detailViewController = [[PlayerSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
//        g_GameUnit.m_nSelPlayer = indexPath.row;
//        g_GameUnit.m_player = [[PlayerInfo alloc] initWithPlayer:[g_GameUnit.m_arrayPlayers objectAtIndex:indexPath.row]];
        [self connectToServer:indexPath.row];
    }
}

@end

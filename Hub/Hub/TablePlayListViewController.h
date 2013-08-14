//
//  TablePlayListViewController.h
//  Hub
//
//  Created by Desarrollo on 07/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playlistsList.h"
@interface TablePlayListViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) playlistsList *searchController;

@property struct mpd_connection *conn;
@property const char* host;
@property int port;
@property int PosClick;

@property NSMutableArray *songs;
@property NSMutableArray *albums;

@property (retain, nonatomic) IBOutlet UITableView *tablePlaylistList;


@end

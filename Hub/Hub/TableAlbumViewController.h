//
//  TableAlbumViewController.h
//  Hub
//
//  Created by Desarrollo on 04/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "albumList.h"

@interface TableAlbumViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) albumList *searchController;

@property struct mpd_connection *conn;
@property const char* host;
@property int port;
@property int PosClick;

@property NSMutableArray *songs;

@property UIViewController *ListadoGlobal;

@property (retain, nonatomic) IBOutlet UITableView *tableAlbumList;

@end

//
//  TableArtistViewController.h
//  Hub
//
//  Created by Desarrollo on 07/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "artistList.h"
#import "ViewController.h"

@interface TableArtistViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) artistList *searchController;

@property struct mpd_connection *conn;
@property const char* host;
@property int port;
@property int PosClick;

@property UIViewController *ListadoGlobal;


@property NSMutableArray *songs;

@property (retain, nonatomic) IBOutlet UITableView *tableArtistList;


@end

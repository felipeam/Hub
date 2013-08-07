//
//  TableFileViewController.h
//  Hub
//
//  Created by Desarrollo on 07/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "browseList.h"

@interface TableFileViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) browseList *searchController;

@property struct mpd_connection *conn;
@property const char* host;
@property int port;

@property NSMutableArray *songs;

@property (retain, nonatomic) IBOutlet UITableView *tableFileList;


@end

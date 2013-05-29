//
//  mpdPlaylistsViewController.h
//  MPpleD
//
//  Created by Apple on 13-5-12.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playlistsList.h"

@interface mpdPlaylistsViewController : UITableViewController

@property (strong, nonatomic) playlistsList *searchController;

@end

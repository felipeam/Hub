//
//  ListadosViewController.h
//  Hub
//
//  Created by Desarrollo on 27/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playlistsList.h"

@interface ListadosViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property int posScreen;
- (IBAction)Swipeleft:(id)sender;
- (IBAction)Swiperight:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *VistaPlaylist;
@property (retain, nonatomic) IBOutlet UIView *VistaAlbums;
@property (retain, nonatomic) IBOutlet UIView *VistaArtists;
@property (retain, nonatomic) IBOutlet UIView *VistaFiles;

@property (retain, nonatomic) IBOutlet UIButton *buttonPlaylist;
@property (retain, nonatomic) IBOutlet UIButton *buttonAlbums;
@property (retain, nonatomic) IBOutlet UIButton *buttonArtist;
@property (retain, nonatomic) IBOutlet UIButton *buttonFiles;

@property (strong, nonatomic) playlistsList *searchController;

@property (retain, nonatomic) IBOutlet UITableView *tablePlaylist;
@end

//
//  TableSongArtistViewController.h
//  Hub
//
//  Created by Desarrollo on 07/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "songList.h"

@interface TableSongArtistViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) songList *searchController;

@property struct mpd_connection *conn;
@property const char* host;
@property int port;
@property int PosClick;

@property NSMutableArray *songs;

@property (retain, nonatomic) IBOutlet UITableView *TablaListado;

-(void) cargarDatos;
-(void) cargarDatosAlbum;
-(void) cargarDatosBusqueda;

@end

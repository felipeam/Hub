//
//  ListadosViewController.h
//  Hub
//
//  Created by Desarrollo on 27/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playlistsList.h"
#import "albumList.h"
#import "artistList.h"
#import "browseList.h"
#import "songList.h"
#import "TableAlbumViewController.h"
#import "TablePlayListViewController.h"
#import "TableArtistViewController.h"
#import "TableFileViewController.h"
#import "TableSongArtistViewController.h"

@interface ListadosViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    TableAlbumViewController *AlbumTableController;
    TablePlayListViewController *PlaylistTableController;
    TableArtistViewController *ArtistTableController;
    TableFileViewController *FilelistTableController;
    TableSongArtistViewController *SongArtistTableController;
}

@property NSTimer *updateTimer;

@property int posScreen;
- (IBAction)Swipeleft:(id)sender;
- (IBAction)Swiperight:(id)sender;

-(void)MostrarListadoCanciones;
-(void)MostrarListadoCancionesAlbum;

//Connection Settings:
@property struct mpd_connection *conn;
@property const char* host;
@property int port;

@property (retain, nonatomic) NSString *ArtistText;
@property UIImage *artwork;
@property id artworkPath;
@property (retain, nonatomic) IBOutlet UILabel *textTituloCancion;
@property (retain, nonatomic) IBOutlet UILabel *textAlbumCancion;
@property (retain, nonatomic) IBOutlet UIImageView *imgAlbumCancion;

@property (retain, nonatomic) IBOutlet UIView *VistaPlaylist;
@property (retain, nonatomic) IBOutlet UIView *VistaAlbums;
@property (retain, nonatomic) IBOutlet UIView *VistaArtists;
@property (retain, nonatomic) IBOutlet UIView *VistaFiles;
@property (retain, nonatomic) IBOutlet UIView *VistaCanciones;

@property (retain, nonatomic) IBOutlet UIButton *buttonPlaylist;
@property (retain, nonatomic) IBOutlet UIButton *buttonAlbums;
@property (retain, nonatomic) IBOutlet UIButton *buttonArtist;
@property (retain, nonatomic) IBOutlet UIButton *buttonFiles;

@property (strong, nonatomic) playlistsList *searchController;
@property (strong, nonatomic) albumList *albumController;
@property (strong, nonatomic) artistList *artistController;
@property (strong, nonatomic) browseList *fileController;
@property (strong, nonatomic) songList *songartistController;

@property (retain, nonatomic) IBOutlet UITableView *tablePlaylist;
@property (retain, nonatomic) IBOutlet UITableView *tableAlbum;
@property (retain, nonatomic) IBOutlet UITableView *tableArtist;
@property (retain, nonatomic) IBOutlet UITableView *tableFiles;
@property (retain, nonatomic) IBOutlet UITableView *tableCanciones;
@end

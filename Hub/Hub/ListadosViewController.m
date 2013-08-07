//
//  ListadosViewController.m
//  Hub
//
//  Created by Desarrollo on 27/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "ListadosViewController.h"
#import "TableAlbumViewController.h"
#import "TablePlayListViewController.h"
#import "AppDelegate.h"

@interface ListadosViewController ()


@end

@implementation ListadosViewController
@synthesize posScreen;
@synthesize VistaAlbums;
@synthesize VistaArtists;
@synthesize VistaFiles;
@synthesize VistaPlaylist;
@synthesize buttonAlbums;
@synthesize buttonArtist;
@synthesize buttonFiles;
@synthesize buttonPlaylist;
@synthesize tablePlaylist;
@synthesize VistaCanciones;

-(void)initializeConnection
{
    NSLog(@"%s\n", __func__);
    mpdConnectionData *connection = [mpdConnectionData sharedManager];
    self.host = [connection.host UTF8String];
    self.port = [connection.port intValue];
    
    
    
    NSLog(@"HOST %s",self.host);
    NSLog(@"PORT %d",self.port);
    
    self.conn = mpd_connection_new(self.host, self.port, 10000);
    
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeConnection];
    
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.Busqueda!=nil)
    {
        if (SongArtistTableController == nil) {
            SongArtistTableController = [[TableSongArtistViewController alloc] init];
        }
        [_tableCanciones setDataSource:SongArtistTableController];
        [_tableCanciones setDelegate:SongArtistTableController];
        SongArtistTableController.view = SongArtistTableController.tableView;
        SongArtistTableController.TablaListado = _tableCanciones;
        [self MostrarListadoCancionesBusqueda];
    }
    else
    {
        if (AlbumTableController == nil) {
            AlbumTableController = [[TableAlbumViewController alloc] init];
        }
        
        if (PlaylistTableController == nil) {
            PlaylistTableController = [[TablePlayListViewController alloc] init];
        }
        
        if (ArtistTableController == nil) {
            ArtistTableController = [[TableArtistViewController alloc] init];
        }
        
        //  if (FilelistTableController == nil) {
        //		FilelistTableController = [[TableFileViewController alloc] init];
        //	}
        
        if (SongArtistTableController == nil) {
            SongArtistTableController = [[TableSongArtistViewController alloc] init];
        }
        
        
        self.searchController = [[playlistsList alloc] init];
        self.albumController = [[albumList alloc] init];
        
        self.artistController = [[artistList alloc] init];
        //  self.fileController = [[browseList alloc] init];
        
        //    self.songartistController = [[songList alloc] init];
        
        //[TableAlbumViewController initialize];
        // TableAlbumViewController * delegateClass = [[TableAlbumViewController alloc] init];
        
        
        [_tableAlbum setDataSource:AlbumTableController];
        [_tableAlbum setDelegate:AlbumTableController];
        
        [tablePlaylist setDataSource:PlaylistTableController];
        [tablePlaylist setDelegate:PlaylistTableController];
        
        [_tableArtist setDataSource:ArtistTableController];
        [_tableArtist setDelegate:ArtistTableController];
        
        //  [_tableFiles setDataSource:FilelistTableController];
        //  [_tableFiles setDelegate:FilelistTableController];
        
        [_tableCanciones setDataSource:SongArtistTableController];
        [_tableCanciones setDelegate:SongArtistTableController];
        
        
        AlbumTableController.view = AlbumTableController.tableView;
        PlaylistTableController.view = PlaylistTableController.tableView;
        ArtistTableController.view = ArtistTableController.tableView;
        //  FilelistTableController.view = FilelistTableController.tableView;
        SongArtistTableController.view = SongArtistTableController.tableView;
        
        
        AlbumTableController.tableAlbumList = _tableAlbum;
        PlaylistTableController.tablePlaylistList = tablePlaylist;
        ArtistTableController.tableArtistList = _tableArtist;
        //  FilelistTableController.tableFileList = _tableFiles;
        
        SongArtistTableController.TablaListado = _tableCanciones;
        
        ArtistTableController.ListadoGlobal = self;
        AlbumTableController.ListadoGlobal = self;
    }
    
    posScreen = 0;
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self selector:@selector(asyncupdate) userInfo: nil repeats:YES];
    
    
	// Do any additional setup after loading the view.
}

-(void)asyncupdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    

    
    int lineas;
    
    switch (posScreen) {
        case 0: lineas = [self.albumController albumCount];//[self.searchController playlistsCount];
            break;
        case 1: lineas = [self.albumController albumCount];
            break;
        case 2: lineas = [self.searchController playlistsCount];
            break;
        case 3: lineas = [self.searchController playlistsCount];
            break;
        default: lineas = [self.searchController playlistsCount];;
    }
    return  lineas;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"CeldaIdentifier";
        UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //	if (cell == nil)
        //	{
        //		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //	}
        
        // Configure the cell...
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
            
            
            labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
            
            //  [[cell textLabel] setText:[self.searchController playlistsAtIndex:indexPath.row]];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
            
            switch (posScreen) {
                case 0: labelTitle.text = [self.albumController albumAtIndex:indexPath.row]; //[self.searchController playlistsAtIndex:indexPath.row];
                    break;
                case 1: labelTitle.text = [self.albumController albumAtIndex:indexPath.row];
                    break;
                case 2: labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
                    NSLog(@"VALOR CELDA: %@",[self.searchController playlistsAtIndex:indexPath.row]);
                    break;
                case 3: labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
                    break;
                default: labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
            }
            
            //   [[cell textLabel] setText:[self.searchController playlistsAtIndex:indexPath.row]];
        }
        
        
            UILongPressGestureRecognizer *longPressGesture =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    
    
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
   
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [tablePlaylist indexPathForCell:cell];
        
		// do something with this action
        if(tablePlaylist == self.searchDisplayController.searchResultsTableView)
            [_searchController addAlbumAtSectionAndIndexToQueue:indexPath.section row:indexPath.row];
        else
        {
            if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
            {
                NSLog(@"Connection error");
                mpd_connection_free(self.conn);
                [self initializeConnection];             
                return;
            }
            
          /*  mpd_command_list_begin(self.conn, true);
            
            mpd_search_add_db_songs(self.conn, TRUE); */
            
            mpd_command_list_begin(self.conn, true);
            mpd_search_queue_songs(self.conn, TRUE);
            
            mpd_search_add_any_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, [[self.searchController playlistsAtIndex:indexPath.row] UTF8String]);
            
            mpd_search_commit(self.conn);
            mpd_command_list_end(self.conn);
            mpd_connection_free(self.conn);
            

        }
          //  [_dataController addAlbumAtSectionAndIndexToQueue:indexPath.section row:indexPath.row];
	}
}


- (void)dealloc {
    [VistaPlaylist release];
    [VistaAlbums release];
    [VistaArtists release];
    [VistaFiles release];
    [buttonPlaylist release];
    [buttonAlbums release];
    [buttonArtist release];
    [buttonFiles release];
    [tablePlaylist release];
    [_tableArtist release];
    [_tableFiles release];
    [VistaCanciones release];
    [_tableCanciones release];
    [_textTituloCancion release];
    [_textAlbumCancion release];
    [_imgAlbumCancion release];
    [super dealloc];
}


-(void)MostrarListadoCanciones
{
    
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaCanciones.frame;
        theFrame.origin.x = 0.f;
        
        VistaCanciones.frame = theFrame;
        
        
    }];
    
    if (SongArtistTableController == nil) {
		SongArtistTableController = [[TableSongArtistViewController alloc] init];
	}
    
    [SongArtistTableController cargarDatos];
    
}

-(void)MostrarListadoCancionesAlbum
{
    
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaCanciones.frame;
        theFrame.origin.x = 0.f;
        
        VistaCanciones.frame = theFrame;
        
        
    }];
    
    if (SongArtistTableController == nil) {
		SongArtistTableController = [[TableSongArtistViewController alloc] init];
	}
    
    [SongArtistTableController cargarDatosAlbum];
    
}




-(void)MostrarListadoCancionesBusqueda
{
    CGRect theFrame = VistaCanciones.frame;
    theFrame.origin.x = 0;
    
    VistaCanciones.frame = theFrame;
        
        
    
    
    if (SongArtistTableController == nil) {
		SongArtistTableController = [[TableSongArtistViewController alloc] init];
	}
    
    [SongArtistTableController cargarDatosBusqueda];
    
}




- (IBAction)Swipeleft:(id)sender {
    switch (posScreen) {
        case 0:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -320.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 0.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 640.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 220.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 330.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];

            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            posScreen = 1;
            [tablePlaylist reloadData];
            break;
        case 1:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -640.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 0.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 320.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 0.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 110.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 220.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            posScreen = 2;
            [tablePlaylist reloadData];
            break;
        case 2:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -960.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -640.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = -320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 0.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -220.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = -110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 0.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 110.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            posScreen = 3;
            [tablePlaylist reloadData];
            break;
        
    }
    
}

- (IBAction)Swiperight:(id)sender {
    switch (posScreen) {
        case 1:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 640.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 960.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 220.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 330.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 440.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            posScreen = 0;
            [tablePlaylist reloadData];
            break;
        case 2:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -320.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 0.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 640.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 220.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 330.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            posScreen = 1;
            [tablePlaylist reloadData];
            break;
        case 3:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -640.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 0.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 320.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 0.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 110.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 220.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            [buttonPlaylist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonPlaylist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonAlbums setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonAlbums setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonArtist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
            [buttonArtist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonFiles setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
            [buttonFiles setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            posScreen = 2;
            [tablePlaylist reloadData];
            break;
    }
}


//Called every 5 seconds to sync with database info.
-(void)updateView
{
    [self initializeConnection];
    NSLog(@"%s\n", __func__);
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error - %d", mpd_connection_get_error(self.conn));
        mpd_connection_free(self.conn);
        [self initializeConnection];        
        
        _textTituloCancion.text = @"No Conectado";
        _textAlbumCancion.text = @"";
        
        
        
        return;
    }
    
    NSLog(@"ERROR CONNECTION: %u",mpd_connection_get_error(self.conn));
    
       
    //get song and status
    struct mpd_status * status = nil;
    struct mpd_song *song;
    //    mpd_command_list_begin(self.conn, true);
    //    mpd_send_status(self.conn);
    //    mpd_send_current_song(self.conn);
    //    mpd_command_list_end(self.conn);
    //    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    if (status == NULL)
    {
        NSLog(@"Connection error status");
   
        
        _textTituloCancion.text = @"No Conectado";
        _textAlbumCancion.text = @"";
 
        
        
        return;
    }
    else{
        //get all of our status and song info
        //        [self.volume setValue:mpd_status_get_volume(status)];
                
        enum mpd_state playerState;
        //If playing or paused, load all song info.  Else clear all fields.
        if((playerState= mpd_status_get_state(status)) == MPD_STATE_PLAY || mpd_status_get_state(status) == MPD_STATE_PAUSE)
        {
            if(playerState==MPD_STATE_PAUSE)
            {
                //                self.play.image =[UIImage imageNamed:@"play.png"];
              /*  self.playing = false;
                self.m_labelArtist.text = @"Paused";
                self.m_labelAlbum.text = @"";
                [BotonPlayPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                [self.m_btnPlayMini setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal]; */
                
            }
            else
            {
                //                self.play.image = [UIImage imageNamed:@"pause.png"];
                //                self.m_labelArtist.text = @"Not connected to MPD Server";
                //                self.m_labelAlbum.text = @"";
            /*    self.playing = true;
                [BotonPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                [self.m_btnPlayMini setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal]; */
            }
            
            if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
            {
                NSLog(@"Connection error free");
                mpd_connection_free(self.conn);
                [self initializeConnection];
                return;
            }
            //            mpd_response_next(self.conn);
            //            song = mpd_recv_song(self.conn);
            song = mpd_run_current_song(self.conn);
            // NSLog(@"uri = %s", mpd_song_get_uri(song));
            //These are all wrapped in try catch statements because if the tag is empty, the
            //function doesn't handle well
            if(song!=NULL)
            {
                @try {
                    char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_ARTIST, 0);
                    if (szText == nil) {
                        szText = "Artista desconocido";
                    }                   
                    
                    
                    _ArtistText = [[NSString alloc] initWithUTF8String:szText];
                    
                }
                @catch (NSException *e) {
                    _ArtistText = @"";
                }

                @try {
                    //                self.albumText.text = [[NSString alloc] initWithUTF8String:mpd_song_get_tag(song, MPD_TAG_ALBUM, 0)];
                    char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_ALBUM, 0);
                    if (szText == nil) {
                        szText = "Album desconocido";
                    }
                    
                    _textAlbumCancion.text = [[NSString alloc] initWithUTF8String:szText];
                    
                }
                @catch (NSException *e) {
                    
                    _textAlbumCancion.text = @"";
                }
                @try {
                    
                    char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
                    if (szText == nil) {
                        szText = "Canción desconocida";
                    }
                    
                    _textTituloCancion.text = [[NSString alloc] initWithUTF8String:szText];
                    
                    //                NSMutableString *trackString=[[NSMutableString alloc] initWithUTF8String:mpd_song_get_tag(song, MPD_TAG_TRACK, 0)];
                    //                [trackString appendString:@" of "];
                    //                [trackString appendString:[NSString stringWithFormat:@"%d",[self maxTrackNum:self.artistText.text album:self.albumText.text]]];
                    //                self.trackText.text = trackString;
                }
                @catch (NSException *e) {
                   _textTituloCancion.text = @"";
                    //                self.trackText.text = @"";
                }
            }
            //kgh
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getArtwork];
                    [_imgAlbumCancion setImage:self.artwork];
           
                });
            });
            
            //            mpd_song_free(song);
        }
        else
        {
            //            self.songTitle.text = @"Stopped";
            //            self.artistText.text = @"";
            //            self.albumText.text = @"";
            //            self.trackText.text = @"";
            _textTituloCancion.text = @"Stopped";
            _textAlbumCancion.text = @"";
        
        }
        //        mpd_status_free(status);
   
        
        
        
        
        
    }
    //    mpd_connection_free(self.conn);
    //    [self.m_tableView reloadData];
}

//uses last.fm web api to fetch the picture.  UpdateView then loads this info into the uiimageview
-(void)getArtwork
{
    UIImage *newArtwork;
    //get the album xml page
    NSMutableString *fetcherString=[[NSMutableString alloc] initWithString:@"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=892d8cc27ce29468dc4da6d03afc5da9"];
    [fetcherString appendString:@"&artist="];
    [fetcherString appendString:[_ArtistText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [fetcherString appendString:@"&album="];
    [fetcherString appendString:[_textAlbumCancion.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = [[NSError alloc] init];
    NSString *lfmpage = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fetcherString] encoding:NSUTF8StringEncoding error:&error];
    //find the medium image url in the xml
    NSString *search = @"<image size=\"large\">";
    NSString *sub = [lfmpage substringFromIndex:NSMaxRange([lfmpage rangeOfString:search])];
    NSString *endSearch = @"</image>";
    sub=[sub substringToIndex:[sub rangeOfString:endSearch].location];
    
    id path = sub;
    //only fetch the artwork again if the album has changed.  Minimizes data usage.  only fetch each image once.
    if(path!=_artworkPath)
    {
        _artworkPath = path;
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data != nil) {
            newArtwork = [[UIImage alloc] initWithData:data];
        }
        else {
            newArtwork = [UIImage imageNamed:@"no_cover.png"];
            NSLog(@"imagen Artwork: %@",newArtwork);
        }
        self.artwork = newArtwork;
    }
}


@end

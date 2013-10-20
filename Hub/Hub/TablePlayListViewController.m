//
//  TablePlayListViewController.m
//  Hub
//
//  Created by Desarrollo on 07/08/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "TablePlayListViewController.h"
#import "AppDelegate.h"

@interface TablePlayListViewController ()

@end

@implementation TablePlayListViewController

- (id)init {
    
    if (self = [super init]) {
        return self;
    }
    
    return nil;
    
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
    [self checkConnnection];
    self.searchController = [[playlistsList alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - connection function
- (void) checkConnnection {
    if (self.conn == nil || mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS) {
        [self initializeConnection];
    }
}

- (void) releaseConnection {
    mpd_connection_free(self.conn);
    self.conn = nil;
}
//Called to setup self.conn. Used by all database interactions.
//It is best not to reuse the connection for multiple interactions, so setup and
//released each time.
-(void)initializeConnection
{
    if (self.conn == nil || mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"%s\n", __func__);
        mpdConnectionData *connection = [mpdConnectionData sharedManager];
        self.host = [connection.host UTF8String];
        self.port = [connection.port intValue];
        
        NSLog(@"HOST %s",self.host);
        NSLog(@"PORT %d",self.port);
        
        self.conn = mpd_connection_new(self.host, self.port, 20000);

    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.searchController playlistsCount];
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
        
        labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
        
        
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
		NSIndexPath *indexPath = [_tablePlaylistList indexPathForCell:cell];
        
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@",[self.searchController playlistsAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Playlist to Hublist", @"Clear Hublist and Play Now", @"Play Now", @"Add to playlist",nil];
        [sheet showInView:app.window];
        
        _PosClick = indexPath.row;
        
		/* // get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [_tablePlaylistList indexPathForCell:cell];
        
        
		// do something with this action
        
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
            mpd_connection_free(self.conn);
            [self initializeConnection];
            return;
        }
        [self initializePlaylistDataList: [self.searchController playlistsAtIndex:indexPath.row]];
         */
        /*  mpd_command_list_begin(self.conn, true);
         
         mpd_search_add_db_songs(self.conn, TRUE); */
        /*
         mpd_command_list_begin(self.conn, true);
         mpd_search_queue_songs(self.conn, TRUE);
         
         //  mpd_search_add_any_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, [[self.searchController playlistsAtIndex:indexPath.row] UTF8String]);
         mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, [[self.searchController albumAtIndex:indexPath.row] UTF8String]);
         mpd_search_commit(self.conn);
         mpd_command_list_end(self.conn);
         mpd_connection_free(self.conn);
         */
        //   for (int songval=0; songval<[_songs count] ; songval++) {
       // [self addPlaylistSong:indexPath.row];
        //    }
        
        
        
        
        //  [_dataController addAlbumAtSectionAndIndexToQueue:indexPath.section row:indexPath.row];
	}
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // do something with this action
        
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
          //  mpd_connection_free(self.conn);
            [self checkConnnection];
            //  [self initializeConnection];
            return;
        }
        [self initializePlaylistDataList: [self.searchController playlistsAtIndex:_PosClick]];
        //   for (int songval=0; songval<[_songs count] ; songval++) {
        [self addPlaylistSong:_PosClick];
        //    }
    }
    else if (buttonIndex == 1) {
        [self checkConnnection];
        /*
        [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
          //  mpd_connection_free(self.conn);
            [self initializeConnection];
            return;
        } */
        mpd_send_clear(self.conn);
        [self initializePlaylistDataList: [self.searchController playlistsAtIndex:_PosClick]];
        //   for (int songval=0; songval<[_songs count] ; songval++) {
        [self addPlaylistSong:_PosClick];
        //    }
        
        
    }
    else if (buttonIndex == 2) {
        // do something with this action
        
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
         //   mpd_connection_free(self.conn);
            [self checkConnnection];
       //     [self initializeConnection];
            return;
        }
        [self initializePlaylistDataList: [self.searchController playlistsAtIndex:_PosClick]];
        //   for (int songval=0; songval<[_songs count] ; songval++) {
        [self addPlaylistSong:_PosClick];
        //    }
    }
    else if (buttonIndex == 3) {
        // do something with this action
        
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
         //   mpd_connection_free(self.conn);
            [self checkConnnection];
            //            [self initializeConnection];
            return;
        }
        [self initializePlaylistDataList: [self.searchController playlistsAtIndex:_PosClick]];
        //   for (int songval=0; songval<[_songs count] ; songval++) {
        [self addPlaylistSong:_PosClick];
        
    }
}


-(void)initializePlaylistDataList:(NSString *)album
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.songs = list;
    
    NSMutableArray *listalbums = [[NSMutableArray alloc] init];
    self.albums = listalbums;
    [self checkConnnection];
  /*    [self initializeConnection];
     if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
     {
         NSLog(@"Connection error");
         mpd_connection_free(self.conn);
         [self initializeConnection];
         return;

     }*/
     
    const char *cAlbum = [album UTF8String];
    mpd_command_list_begin(self.conn, true);
    mpd_search_db_songs(self.conn, true);
 //   mpd_search_add_any_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, cAlbum);
  //  mpd_send_list_playlist(self.conn, cAlbum);
  //  mpd_search_commit(self.conn);
    mpd_send_load(self.conn,cAlbum);
    mpd_command_list_end(self.conn);
    
   
    
  /*  struct mpd_song *song;
    while((song=mpd_recv_song(self.conn))!=NULL)
    {
        char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
        if (szText == nil) {
            szText = "Unkown Title";
        }
        NSLog(@"CANCION: %@",[[NSString alloc] initWithUTF8String:szText]);
        [self.songs addObject:[[NSString alloc] initWithUTF8String:szText]];
        
        char* AlbumText = (char*)mpd_song_get_tag(song, MPD_TAG_ALBUM, 0);
        if (AlbumText == nil) {
            AlbumText = "Unkown album";
        }
        [self.albums addObject:[[NSString alloc] initWithUTF8String:AlbumText]];
    }
    */
    
  /*  struct mpd_playlist *playlist;
    while((playlist=mpd_recv_playlist(self.conn))!=NULL)
    {
       /* char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
        if (szText == nil) {
            szText = "Unkown Title";
        }
        NSLog(@"CANCION: %@",[[NSString alloc] initWithUTF8String:szText]);
        [self.songs addObject:[[NSString alloc] initWithUTF8String:szText]];
        
        char* AlbumText = (char*)mpd_song_get_tag(song, MPD_TAG_ALBUM, 0);
        if (AlbumText == nil) {
            AlbumText = "Unkown album";
        }
        [self.albums addObject:[[NSString alloc] initWithUTF8String:AlbumText]]; */
/*    }
    
    mpd_connection_free(self.conn);    */
}

-(void)addPlaylistSong: (NSUInteger)row
{
    
   
   /* [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    */
    
    /*
    for (int x=0; x<[_songs count]; x++) {
         [self checkConnnection];
       /* [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
            mpd_connection_free(self.conn);
            [self initializeConnection];
            return;
        } */
    /*    mpd_command_list_begin(self.conn, true);
        mpd_search_add_db_songs(self.conn, TRUE);
        
        
        mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_TITLE, [[_songs objectAtIndex:x] UTF8String]);
       // mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, [[_albums objectAtIndex:x] UTF8String]);
        //  mpd_run_playlist_add(self.conn,[[self.searchController playlistsAtIndex:row] UTF8String],(char*)@"");
        //   mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_TRACK, [[self.searchController playlistsAtIndex:row] UTF8String]);
        mpd_search_commit(self.conn);
        mpd_command_list_end(self.conn);
        mpd_connection_free(self.conn);
    }
 /*   mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_TITLE, [[_songs objectAtIndex:row] UTF8String]);
  //  mpd_run_playlist_add(self.conn,[[self.searchController playlistsAtIndex:row] UTF8String],(char*)@"");
 //   mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_TRACK, [[self.searchController playlistsAtIndex:row] UTF8String]);
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    mpd_connection_free(self.conn); */
   // mpd_connection_free(self.conn);*/
}


@end

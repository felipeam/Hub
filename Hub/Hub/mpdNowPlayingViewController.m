  //
//  mpdFirstViewController.m
//  MPpleD
//
//  Created by Kyle Hershey on 2/11/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "mpdNowPlayingViewController.h"
#import <mpd/client.h>
//#import "SettingsViewController.h"
//#import "PlayersViewController.h"
#import "PlayerInfo.h"
#import "GameUnit.h"
#import "AppDelegate.h"
//#import "AFUIImageReflection.h"
@interface mpdNowPlayingViewController ()

@end

@implementation mpdNowPlayingViewController
@synthesize LabelAlbumSong;
@synthesize LabelGroupSong;
@synthesize LabelNameSong;
@synthesize LabelNameSongMini;
@synthesize LabelAlbumSongMini;
@synthesize LabelCurrentTime;
@synthesize LabelTotalTime;
@synthesize BotonPlayPause;
@synthesize posScreen;
@synthesize VistaMenu;
@synthesize VistaPrincipal;
@synthesize VistaListado;
@synthesize buttonHublist;
@synthesize buttonNowPlaying;
@synthesize TableSongs;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (backgroundQueue==NULL) {
        backgroundQueue = dispatch_queue_create("FON.mpdNowPlayingViewController", NULL);
    }
    [self initializeConnection];
    dispatch_async(backgroundQueue, ^(void) {
        [self cargarTabla];
    });

    if (g_GameUnit.m_nSelServerPlayer < [g_GameUnit.m_arrayPlayers count]) {
        PlayerInfo* player = [g_GameUnit.m_arrayPlayers objectAtIndex:g_GameUnit.m_nSelServerPlayer];
        mpdConnectionData *globalConnection = [mpdConnectionData sharedManager];
        NSLog(@"PUESTO SERVER %@",player.m_strMPDServer);
        
        globalConnection.host = player.m_strMPDServer;
        globalConnection.port = [[NSNumber alloc] initWithInt:[player.m_strMPDPort intValue]];
    }
    posScreen = 1;
      /*  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargarTabla];
        });
    });
*/
    self.m_labelArtist = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 180, 20)];
    self.m_labelArtist.font = [UIFont systemFontOfSize:14];
    self.m_labelArtist.textAlignment = NSTextAlignmentCenter;
    self.m_labelArtist.backgroundColor = [UIColor clearColor];
    self.m_labelArtist.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.m_labelArtist];
    self.m_labelAlbum = [[UILabel alloc] initWithFrame:CGRectMake(90, 24, 180, 20)];
    self.m_labelAlbum.font = [UIFont systemFontOfSize:14];
    self.m_labelAlbum.textAlignment = NSTextAlignmentCenter;
    self.m_labelAlbum.backgroundColor = [UIColor clearColor];
    self.m_labelAlbum.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.m_labelAlbum];
    
    self.m_nVolume = 50;
//    [self updateView];
    self.artwork = [UIImage alloc];
    CGRect frame = self.m_segmentPlay.frame;
    frame.size.height = 44;
    self.m_segmentPlay.frame = frame;
    [self initVolumeView];
 //   [self hideSoundView]; FELIPE
    [self initSeekView];
    [self.m_viewCover removeFromSuperview];
    
    self.TableSongs.editing = YES;
    self.TableSongs.allowsSelectionDuringEditing = YES;
    
       
}


- (void)viewWillAppear:(BOOL)animated {
    [self initializeConnection];
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[self checkConnnection];
 //   [self cargarTabla];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
   // [self updateView];
    [self.m_tableView reloadData];
    [self changeEditSegImage];
    //Start the timers
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector:@selector(asyncupdate) userInfo: nil repeats:YES];
  //  self.updateTimerTabla = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector:@selector(asyncupdateTabla) userInfo: nil repeats:YES];
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector:@selector(artificialClock) userInfo: nil repeats:YES];
 //   self.connectTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector:@selector(checkConnnection) userInfo: nil repeats:YES];
   // self.updateTable = [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self selector:@selector(cargarTabla) userInfo: nil repeats:YES];
    
    [self changeVolumeImage:self.m_nVolume];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //Stop timers so doesn't waste resources
    [self.updateTimer invalidate];
    [self.clockTimer invalidate];
}

- (void)viewDidLayoutSubview {
    [super viewDidLayoutSubviews];
    CGRect frame = self.m_segmentPlay.frame;
    frame.size.height = 44;
    self.m_segmentPlay.frame = frame;
    [self.view setNeedsLayout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)onCover:(id)sender {
    if (self.m_bShowCover == NO)
        [self showSeekView];
    else
        [self hideSeekView];
}
/*
 * Passive Connection Data loading
 *
 */
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
        
        self.conn = mpd_connection_new(self.host, self.port, 10000);
    
    }
   [self showSeekView];
    
    
}

-(void)asyncupdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
}


-(void)asyncupdateTabla
{
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error - %d", mpd_connection_get_error(self.conn));
        mpd_connection_free(self.conn);
        [self initializeConnection];
        self.m_labelArtist.text = @"No Conectado";
        self.m_labelAlbum.text = @"";
        
        LabelNameSong.text = @"No Conectado";
        LabelAlbumSong.text = @"";
        LabelGroupSong.text = @"";
        
        
        self.isConnected = NO;
        return;
    }
    if(posScreen == 2)
    {
        if (backgroundQueue==NULL) {
            backgroundQueue = dispatch_queue_create("FON.mpdNowPlayingViewController", NULL);
        }
        [self initializeConnection];
        dispatch_async(backgroundQueue, ^(void) {
            [self cargarTabla];
        });
        
    }


    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cargarTabla];
        });
    }); */


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
        self.m_labelArtist.text = @"No Conectado";
        self.m_labelAlbum.text = @"";
        
        LabelNameSong.text = @"No Conectado";
        LabelAlbumSong.text = @"";
        LabelGroupSong.text = @"";
        
        LabelNameSongMini.text = @"No Conectado";
        LabelAlbumSongMini.text = @"";
        
        self.isConnected = NO;
        return;
    }
    
    NSLog(@"ERROR CONNECTION: %u",mpd_connection_get_error(self.conn));
    
    

    
    
    self.isConnected = YES;
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
        [self checkConnnection];
        NSLog(@"Connection error status");
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
        self.m_labelArtist.text = @"Stopped";
        self.m_labelAlbum.text = @"";
        
        LabelNameSong.text = @"No Conectado";
        LabelAlbumSong.text = @"";
        LabelGroupSong.text = @"";
        
        LabelNameSongMini.text = @"No Conectado";
        LabelAlbumSongMini.text = @"";
        
        return;
    }
    else{
        if(posScreen == 2)
        {
            if (backgroundQueue==NULL) {
                backgroundQueue = dispatch_queue_create("FON.mpdNowPlayingViewController", NULL);
            }
            [self initializeConnection];
            dispatch_async(backgroundQueue, ^(void) {
                [self cargarTabla];
            });
        }
        else
        {
            //get all of our status and song info
            //        [self.volume setValue:mpd_status_get_volume(status)];
            self.currentTime = mpd_status_get_elapsed_time(status);
            
            int seconds = self.currentTime % 60;
            int minutes = (self.currentTime - seconds) / 60;
            
            LabelCurrentTime.text =  [NSString stringWithFormat:@"%d:%.2d", minutes, seconds];//[@(mpd_status_get_elapsed_time(status)) stringValue];
            
            self.totalTime = mpd_status_get_total_time(status);
            
            
            seconds = self.totalTime % 60;
            minutes = (self.totalTime - seconds) / 60;
            
            
            LabelTotalTime.text = [NSString stringWithFormat:@"%d:%.2d", minutes, seconds];//[@(mpd_status_get_total_time(status)) stringValue];
            
            //        self.curPos.text = [NSString stringWithFormat:@"%u:%02u", self.currentTime/60,self.currentTime%60];
            self.totalTime = mpd_status_get_total_time(status);
            //        self.totTime.text = [NSString stringWithFormat:@"%u:%02u",self.totalTime/60,self.totalTime%60 ];
            //        self.progressSlider.maximumValue = self.totalTime;
            //        self.progressSlider.value = self.currentTime;
            
            enum mpd_state playerState;
            //If playing or paused, load all song info.  Else clear all fields.
            if((playerState= mpd_status_get_state(status)) == MPD_STATE_PLAY || mpd_status_get_state(status) == MPD_STATE_PAUSE)
            {
                if(playerState==MPD_STATE_PAUSE)
                {
                    //                self.play.image =[UIImage imageNamed:@"play.png"];
                    self.playing = false;
                    self.m_labelArtist.text = @"Paused";
                    self.m_labelAlbum.text = @"";
                    [BotonPlayPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                    [self.m_btnPlayMini setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                    
                                   }
                else
                {
                    //                self.play.image = [UIImage imageNamed:@"pause.png"];
                    //                self.m_labelArtist.text = @"Not connected to MPD Server";
                    //                self.m_labelAlbum.text = @"";
                    self.playing = true;
                    [BotonPlayPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                    [self.m_btnPlayMini setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
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
                        self.m_labelArtist.text = [[NSString alloc] initWithUTF8String:szText];
                        
                        
                        LabelGroupSong.text = [[NSString alloc] initWithUTF8String:szText];
                        
                    }
                    @catch (NSException *e) {
                        self.m_labelArtist.text = @"";
                        LabelGroupSong.text = @"";
                    }
                    @try {
                        //                self.albumText.text = [[NSString alloc] initWithUTF8String:mpd_song_get_tag(song, MPD_TAG_ALBUM, 0)];
                        char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_ALBUM, 0);
                        if (szText == nil) {
                            szText = "Album desconocido";
                        }
                        
                        LabelAlbumSong.text = [[NSString alloc] initWithUTF8String:szText];
                        LabelAlbumSongMini.text = [[NSString alloc] initWithUTF8String:szText];
                        self.m_labelAlbum.text = [[NSString alloc] initWithUTF8String:szText];
                    }
                    @catch (NSException *e) {
                        
                        self.m_labelAlbum.text = @"";
                        LabelAlbumSong.text = @"";
                        LabelAlbumSongMini.text = @"";
                    }
                    @try {
                        
                        char* szText = (char*)mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
                        if (szText == nil) {
                            szText = "Canción desconocida";
                        }
                        
                        LabelNameSong.text = [[NSString alloc] initWithUTF8String:szText];
                        LabelNameSongMini.text = [[NSString alloc] initWithUTF8String:szText];
                        
                        //                NSMutableString *trackString=[[NSMutableString alloc] initWithUTF8String:mpd_song_get_tag(song, MPD_TAG_TRACK, 0)];
                        //                [trackString appendString:@" of "];
                        //                [trackString appendString:[NSString stringWithFormat:@"%d",[self maxTrackNum:self.artistText.text album:self.albumText.text]]];
                        //                self.trackText.text = trackString;
                    }
                    @catch (NSException *e) {
                        LabelNameSong.text = @"";
                        LabelNameSongMini.text = @"";
                        //                self.trackText.text = @"";
                    }
                }
                //kgh
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getArtwork];
                        [self.m_imageThumb setImage:self.artwork];
                        [self.m_imageThumbMini setImage:self.artwork];
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
                self.m_labelArtist.text = @"Stopped";
                self.m_labelAlbum.text = @"";
                self.playing=false;
            }
            //        mpd_status_free(status);
            UIImage* img;
            if (self.playing)
                img = [UIImage imageNamed:@"pause-small.png"];
            else
                img = [UIImage imageNamed:@"play-small.png"];
            [self.m_segmentPlay setImage:img forSegmentAtIndex:2];
                
       
        }
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
    [fetcherString appendString:[self.m_labelArtist.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [fetcherString appendString:@"&album="];
    [fetcherString appendString:[self.m_labelAlbum.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = [[NSError alloc] init];
    NSString *lfmpage = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fetcherString] encoding:NSUTF8StringEncoding error:&error];
    //find the medium image url in the xml
    NSString *search = @"<image size=\"large\">";
    NSString *sub = [lfmpage substringFromIndex:NSMaxRange([lfmpage rangeOfString:search])];
    NSString *endSearch = @"</image>";
    sub=[sub substringToIndex:[sub rangeOfString:endSearch].location];
    
    id path = sub;
    //only fetch the artwork again if the album has changed.  Minimizes data usage.  only fetch each image once.
    if(path!=self.artworkPath)
    {
        self.artworkPath = path;
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

-(NSInteger)maxTrackNum:(NSString*)artist album:(NSString*)album
{
    //NSMutableArray *list = [[NSMutableArray alloc] init];
    NSInteger max=0;
    
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return 0;
    }
    NSLog(@"%s\n", __func__);
    
    const char *cArtist = [artist UTF8String];
    const char *cAlbum = [album UTF8String];
    mpd_command_list_begin(self.conn, true);
    mpd_search_db_tags(self.conn, MPD_TAG_TRACK);
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ARTIST, cArtist);
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, cAlbum);
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    
    struct mpd_pair *pair;
    
    
    while ((pair = mpd_recv_pair_tag(self.conn, MPD_TAG_TRACK)) != NULL)
    {
        NSString *trackNum = [[NSString alloc] initWithUTF8String:pair->value];
        if([trackNum intValue]>max)
        {
            max=[trackNum intValue];
        }
        mpd_return_pair(self.conn, pair);
    }
    mpd_enqueue_pair(self.conn, pair);
    
    
    
    
    //mpd_connection_free(self.conn);
    return max;
}


//updates the position bar and timers when playing
-(void)artificialClock
{
    if(self.playing)
    {
        if(self.currentTime<self.totalTime)
        {
            self.currentTime++;
//            self.curPos.text = [NSString stringWithFormat:@"%u:%02u", self.currentTime/60,self.currentTime%60];
            self.m_sliderProgress.maximumValue = self.totalTime;
            self.m_sliderProgress.value = self.currentTime;
        }
     /*   else
            [self updateView];//kgh */
    }
}

/*
 * User Interactions
 *
 */

-(void)playPausePush:(id)sender
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    
    
    struct mpd_status * status;
//    mpd_command_list_begin(self.conn, true);
//    mpd_send_status(self.conn);
//    mpd_command_list_end(self.conn);
//    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    if (status == NULL)
    {
        NSLog(@"Connection error status");
//        mpd_connection_free(self.conn);
        return;
    }
    else
    {
        //if status worked, this is the real action.
        if(mpd_status_get_state(status) == MPD_STATE_PLAY)
        {

            mpd_response_finish(self.conn);
//            mpd_status_free(status);
            mpd_run_toggle_pause(self.conn);
            [self.m_btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        }
        else
        {
            mpd_response_finish(self.conn);
//            mpd_status_free(status);
            mpd_run_play(self.conn);
            [self.m_btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        }
    }
//    mpd_connection_free(self.conn);
    //Rather than update all the info, we just update the view.
    //Doesn't duplicate code, and will only show a state change if call actually worked.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    //  [self updateView];
}

-(void)stopPush:(id)sender {
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_stop(self.conn);
//    mpd_connection_free(self.conn);
  //  [self updateView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
}

- (IBAction)NextSong:(id)sender {
    //    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_next(self.conn);
    //    mpd_connection_free(self.conn);
    //[self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];

}

- (IBAction)PrevSong:(id)sender {
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_previous(self.conn);
    //    mpd_connection_free(self.conn);
 //   [self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
    
}

- (IBAction)RandomSong:(id)sender {
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    else
    {
        if(self.randomState)
           mpd_run_random(self.conn, FALSE);
        else
           mpd_run_random(self.conn, TRUE);
       
    }

}

- (IBAction)RepeatSong:(id)sender {
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    else
    {
        if(self.repeatState)
        {
            mpd_run_repeat(self.conn, FALSE);
        }
        else
        {
            mpd_run_repeat(self.conn, TRUE);
        }

        
    }

    
}


-(void)nextPush:(id)sender
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_next(self.conn);
//    mpd_connection_free(self.conn);
  //  [self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
}

-(void)prevPush:(id)sender
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_previous(self.conn);
//    mpd_connection_free(self.conn);
 //   [self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
}

//Volume Slider
- (void) sliderValueChanged:(UISlider *)sender {
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_set_volume(self.conn, [sender value]);
//    mpd_connection_free(self.conn);
    [self.m_tableView reloadData];
}

//Track Time Position
-(void)positionValueChanged:(UISlider *)sender
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    struct mpd_status * status;
//    mpd_command_list_begin(self.conn, true);//kgh
//    mpd_send_status(self.conn);
//    mpd_command_list_end(self.conn);
//    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    if(status!=NULL)
    {
        mpd_run_seek_pos(self.conn, mpd_status_get_song_pos(status), [sender value]);
        self.currentTime=[sender value];
//        mpd_status_free(status);
    }

//    mpd_connection_free(self.conn);
}

-(void)artClick:(id)sender
{
    /*
    NSMutableString *fetcherString=[[NSMutableString alloc] initWithString:@"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=892d8cc27ce29468dc4da6d03afc5da9"];
    [fetcherString appendString:@"&artist="];
    [fetcherString appendString:[self.artistText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [fetcherString appendString:@"&album="];
    [fetcherString appendString:[self.albumText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = [[NSError alloc] init];
    NSString *lfmpage = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fetcherString] encoding:NSUTF8StringEncoding error:&error];
    //find the medium image url in the xml
    NSString *search = @"<url>";
    NSString *sub = [lfmpage substringFromIndex:NSMaxRange([lfmpage rangeOfString:search])];
    NSString *endSearch = @"</url>";
    sub=[sub substringToIndex:[sub rangeOfString:endSearch].location];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sub]];
    */
}

-(void)artistClick:(id)sender
{
    /*
    NSMutableString *fetcherString=[[NSMutableString alloc] initWithString:@"http://ws.audioscrobbler.com/2.0/?method=artist.getinfo"];
    [fetcherString appendString:@"&artist="];
    [fetcherString appendString:[self.artistText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [fetcherString appendString:@"&api_key=892d8cc27ce29468dc4da6d03afc5da9"];
    NSError *error = [[NSError alloc] init];
    NSString *lfmpage = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:fetcherString] encoding:NSUTF8StringEncoding error:&error];
    NSString *search = @"<url>";
    NSString *sub = [lfmpage substringFromIndex:NSMaxRange([lfmpage rangeOfString:search])];
    NSString *endSearch = @"</url>";
    sub=[sub substringToIndex:[sub rangeOfString:endSearch].location];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sub]];
    */
}

- (IBAction)CellButtonClick:(id)sender {
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:TableSongs];
    NSIndexPath *indexPath = [TableSongs indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Skip to here", @"Play next", @"Move to first", @"Move to last", @"Remove from playlist",nil];
        [sheet showInView:app.window];
    }


}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }
    else if (buttonIndex == 1) {
                
        
    }
    else if (buttonIndex == 2) {
        
    }
    else if (buttonIndex == 3) {
        
        
    }
    else if (buttonIndex == 4) {
        
        
    }
}


-(IBAction)segmentSettingsClick:(id)sender {
  /*  UISegmentedControl* seg = (UISegmentedControl*)sender;
    if (seg.selectedSegmentIndex == 0) {
        SettingsViewController* ctrl = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        PlayersViewController* ctrl = [[PlayersViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [self presentViewController:nav animated:YES completion:nil];
    } */
}

-(IBAction)segmentPlayItemsClick:(id)sender {
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self prevPush:nil];
            break;
        case 1:
            [self stopPush:nil];
            break;
        case 2:
            [self playPausePush:nil];
            break;
        case 3:
            [self nextPush:nil];
            break;
            
        default:
            break;
    }
    [self.m_tableView reloadData];
}




-(IBAction)segmentEditItemsClick:(id)sender {
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    if (seg.selectedSegmentIndex != 2) {
//        [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
            mpd_connection_free(self.conn);
            [self initializeConnection];
            return;
        }
        else
        {
            if (seg.selectedSegmentIndex == 0) {//repeat
                if(self.repeatState)
                {
                    mpd_run_repeat(self.conn, FALSE);
                }
                else
                {
                    mpd_run_repeat(self.conn, TRUE);
                }
            }
            else {
                if(self.randomState)
                    mpd_run_random(self.conn, FALSE);
                else
                    mpd_run_random(self.conn, TRUE);
            }
        }
//        mpd_connection_free(self.conn);
        [self changeEditSegImage];
    }
    else {
        NSString* str;
        if (self.m_tableView.editing) {
            self.m_tableView.editing = NO;
            str = @"Edit";
        }
        else {
            AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Select action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edite Playlist", @"Clear Playlist", nil];
            [sheet showInView:app.window];
            str = @"Done";
        }
        [self.m_segmentEdit setTitle:str forSegmentAtIndex:2];
    }
}
-(IBAction)segmentVolumeItemsClick:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSoundView) object:nil];
    self.m_viewVolume.hidden = NO;
    CGFloat fTick = 5;
    UISegmentedControl* seg = (UISegmentedControl*)sender;
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        if (seg.selectedSegmentIndex == 0)
            self.m_nVolume -= fTick;
        else
            self.m_nVolume += fTick;
    }
    else {
        //get song and status
//        struct mpd_status * status;
//        mpd_command_list_begin(self.conn, true);
//        mpd_send_status(self.conn);
//        mpd_send_current_song(self.conn);
//        mpd_command_list_end(self.conn);
//        status = mpd_recv_status(self.conn);
//        if (status == NULL)
//        {
//            NSLog(@"Connection error status");
//            if (seg.selectedSegmentIndex == 0)
//                self.m_nVolume -= fTick;
//            else
//                self.m_nVolume += fTick;
//        }
//        else
        {
            //get all of our status and song info
//            self.m_nVolume = mpd_status_get_volume(status);
            if (seg.selectedSegmentIndex == 0)
                self.m_nVolume -= fTick;
            else
                self.m_nVolume += fTick;
        }
        NSLog(@"volume : %d", self.m_nVolume);
        bool ret = mpd_run_set_volume(self.conn, self.m_nVolume);
        NSLog(@"%d", ret);
    }
//    mpd_connection_free(self.conn);
    if (self.m_nVolume < 0)
        self.m_nVolume = 0;
    else if (self.m_nVolume >= 100)
        self.m_nVolume = 100;
    [self changeVolumeImage:self.m_nVolume];
    [self performSelector:@selector(hideSoundView) withObject:nil afterDelay:3];
}

-(void) changeEditSegImage {
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
    }
    else {
        //get song and status
        struct mpd_status * status;
//        mpd_command_list_begin(self.conn, true);
//        mpd_send_status(self.conn);
//        mpd_command_list_end(self.conn);
//        status = mpd_recv_status(self.conn);
        status = mpd_run_status(self.conn);
        if (status == NULL)
        {
            NSLog(@"Connection error status");
        }
        else{
            //get all of our status and song info
            self.randomState = mpd_status_get_random(status);
            self.repeatState = mpd_status_get_repeat(status);
//            mpd_status_free(status);
        }
    }
//    mpd_connection_free(self.conn);
    UIImage* img;
    if (self.repeatState)
        img = [UIImage imageNamed:@"repeat.png"];
    else
        img = [UIImage imageNamed:@"repeat-off.png"];
    [self.m_segmentEdit setImage:img forSegmentAtIndex:0];
    if (self.randomState)
        img = [UIImage imageNamed:@"random.png"];
    else
        img = [UIImage imageNamed:@"random-off.png"];
    [self.m_segmentEdit setImage:img forSegmentAtIndex:1];
}
/*
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.m_tableView.editing = YES;
    }
    else if (buttonIndex == 1) {
        [self clearQueue:nil];
    }
}
 */
- (void) initVolumeView {
    self.m_viewVolume.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    CGFloat x, y, w, h;
    w = h = 5;
    y = 180;
    x = 22;
    CGFloat offsetX = (200-44 - 20*w)/20;
    for (int i = 0; i < 20; i ++) {
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        img.image = [UIImage imageNamed:@"volumebox_dark.png"];
        img.tag = 0x20+i;
        [self.m_viewVolume addSubview:img];
        x += w+offsetX;
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.m_viewVolume.center = CGPointMake(size.width/2, size.height/2);
}
- (void) changeVolumeImage:(int)volume {
//    int max = 100;
 /*   UIImage* imgB = [UIImage imageNamed:@"volumebox_dark.png"];
    UIImage* imgW = [UIImage imageNamed:@"volumebox_white.png"];
    for (int i = 0; i < 20; i ++) {
        UIImageView* imgView = (UIImageView*)[self.m_viewVolume viewWithTag:0x20+i];
        if (i*5 < volume)
            imgView.image = imgW;
        else
            imgView.image = imgB;
    }
    if (volume <= 0) {
        [self.m_imgVolume setImage:[UIImage imageNamed:@"volumeicon_00.png"]];
    }
    else if (volume == 5) {
        [self.m_imgVolume setImage:[UIImage imageNamed:@"volumeicon_75.png"]];
    }

//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
    }
    else {
        NSLog(@"%s\n", __func__);
        //get song and status
        struct mpd_status * status;
//        mpd_command_list_begin(self.conn, true);
//        mpd_send_status(self.conn);
//        mpd_command_list_end(self.conn);
//        status = mpd_recv_status(self.conn);
        status = mpd_run_status(self.conn);
        if (status != NULL)
        {
            //get all of our status and song info
            self.m_nVolume = mpd_status_get_volume(status);
//            mpd_status_free(status);
        }
    }*/
//    mpd_connection_free(self.conn);
}

- (void) hideSoundView {
    self.m_viewVolume.hidden = YES;
}

#pragma mark - cover view
//cover view
- (void) initSeekView {
    self.m_viewSeek.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.m_sliderProgress setThumbImage:[UIImage imageNamed:@"slidercenter.png"] forState:UIControlStateNormal];
    [self.m_sliderProgress setMinimumTrackImage:[UIImage imageNamed:@"sliderlefthand.png"] forState:UIControlStateNormal];
    [self.m_sliderProgress setMaximumTrackImage:[UIImage imageNamed:@"sliderrighthand.png"] forState:UIControlStateNormal];
    [self.m_sliderProgress setThumbImage:[UIImage imageNamed:@"slidercenter@2x.png"] forState:UIControlStateHighlighted];
    
    [self setCoverImage];
}
- (void) setCoverImage {
    UIImage* image = [UIImage imageNamed:@"no_cover.png"];
  //  UIImage* imgRe = [image addImageReflection:0.4];
    [self.m_imageThumb setImage:image];
    [self.m_imageThumbMini setImage:image];
}
- (void) showSeekView {
//    [UIView transitionWithView:self.m_viewCover
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^{ [self.view addSubview:self.m_viewCover]; }
//                    completion:^(BOOL f){
//                        [self.m_viewList removeFromSuperview];
//                    }
//     ];
    self.m_sliderProgress.enabled = self.isConnected;
    self.m_btnPlay.enabled = self.isConnected;
    self.m_btnStop.enabled = self.isConnected;
    if (self.isConnected == NO) {
        self.m_sliderProgress.maximumValue = 0;
        self.m_sliderProgress.minimumValue = 0;
        self.m_sliderProgress.value = 0;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView transitionFromView:self.m_viewList toView:self.m_viewCover duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    [UIView commitAnimations];
    self.m_bShowCover = YES;
}
- (void) hideSeekView {
//    [UIView transitionWithView:self.m_viewList
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    animations:^{ [self.view addSubview:self.m_viewList]; }
//                    completion:^(BOOL f){
//                        [self.m_viewCover removeFromSuperview];
//                    }
//     ];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView transitionFromView:self.m_viewCover toView:self.m_viewList duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    [UIView commitAnimations];
    self.m_bShowCover = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger pos;
    NSLog(@"%s\n", __func__);
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error - %d", mpd_connection_get_error(self.conn));
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
        return 0;
    }
    struct mpd_status * status;
//    mpd_command_list_begin(self.conn, true);//kgh
//    mpd_send_status(self.conn);
//    mpd_command_list_end(self.conn);
//    
//    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    
    if (status == NULL)
    {
        NSLog(@"Connection error status");
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
        return 0;
    }
    
    pos = mpd_status_get_queue_length(status);
//    mpd_connection_free(self.conn);
//    mpd_status_free(status);
    self.prevRowCount = self.rowCount;
    self.rowCount = pos;
    return pos;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CeldaIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    [self updateRowCount];
    //should probably use queue number instead, but this works fine, especially with the timer
    if(self.rowCount!=self.prevRowCount)
    {
        [self.m_tableView reloadData];
    }
    int contador = 0;
    while (self.rowCount>[SongTitle count]) {
        
        sleep(2);
        if (contador>0) {
            [self cargarTabla];
        }
        contador++;
    }
    
    
    if(indexPath.row <[tableView numberOfRowsInSection:0])
    {
//        [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
//            mpd_connection_free(self.conn);
//            [self initializeConnection];
            return cell;
        }
        /*
        struct mpd_song *nextSong = malloc(sizeof(struct mpd_song));
        nextSong=mpd_run_get_queue_song_pos(self.conn, indexPath.row);
//        [[cell detailTextLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_ARTIST, 0)]];
//        [[cell textLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_TITLE, 0)]]; */
        
             
      
        UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
        UILabel* labelAlbum = (UILabel*)[cell.contentView viewWithTag:3];
        
        NSLog(@"SONGS COUNT %i",[SongTitle count]);
        NSLog(@"indexPath %i",indexPath.row);
        
        if([SongTitle count]>indexPath.row)
        {
            labelTitle.text = [[SongTitle objectAtIndex:indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            labelAlbum.text = [[SongAlbum objectAtIndex:indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
      
  /*       UILabel* labelArtist = (UILabel*)[cell.contentView viewWithTag:3];

        labelArtist.text = [[SongArtist objectAtIndex:indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UILabel* labelTime = (UILabel*)[cell.contentView viewWithTag:4];

        labelTime.text = [[SongTime objectAtIndex:indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        */
    }
 /*   struct mpd_status * status;
//    mpd_send_status(self.conn);
//    
//    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    
    if (status != NULL)
    {
        UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:1];
    //    if(mpd_status_get_song_pos(status)==indexPath.row)
        if([[SongStatus objectAtIndex:indexPath.row] intValue]==indexPath.row)
        {
            imgView.image = [UIImage imageNamed:@"nowplaying.png"];
        }
        else
        {
            imgView.image = nil;
        }
    }
    
    */
//    mpd_connection_free(self.conn);
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor darkGrayColor]];
    for(UIView* view in cell.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            // Creates a new subview the size of the entire cell
            UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            // Adds the reorder control view to our new subview
            [movedReorderControl addSubview:view];
            // Adds our new subview to the cell
            [cell addSubview:movedReorderControl];
            // CGStuff to move it to the left
            NSLog(@"pos MOVE: %f",movedReorderControl.frame.size.width - view.frame.size.width);
            CGSize moveLeft = CGSizeMake(277.000000, movedReorderControl.frame.size.height - view.frame.size.height);
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
            // Performs the transform
            [movedReorderControl setTransform:transform];
        }
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error");
            mpd_connection_free(self.conn);
            [self initializeConnection];
            return;
        }
        
        if(mpd_run_delete(self.conn, indexPath.row)){
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
//        mpd_connection_free(self.conn);
//        [self updateView];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_move(self.conn, fromIndexPath.row, toIndexPath.row);
//    mpd_connection_free(self.conn);
    [self.m_tableView reloadData];
}


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate


//Plays song at that position
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint hitPoint = [[tableView cellForRowAtIndexPath:indexPath] convertPoint:CGPointZero toView:tableView];
    NSIndexPath *hitIndex = [tableView indexPathForRowAtPoint:hitPoint];
    
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    
    mpd_run_play_pos(self.conn,indexPath.row);
    mpd_connection_free(self.conn);
    [self.m_tableView reloadData];
}

-(void)updateRowCount
{
    NSInteger pos;
    NSLog(@"%s\n", __func__);
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
        return;
    }
    struct mpd_status * status;
//    mpd_command_list_begin(self.conn, true);//kgh
//    mpd_send_status(self.conn);
//    mpd_command_list_end(self.conn);
//    
//    status = mpd_recv_status(self.conn);
    status = mpd_run_status(self.conn);
    
    if (status == NULL)
    {
        NSLog(@"Connection error status");
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
        return;
    }
    
    pos = mpd_status_get_queue_length(status);
//    mpd_status_free(status);
//    mpd_connection_free(self.conn);
    self.prevRowCount = self.rowCount;
    self.rowCount = pos;
    
}


//Clear the Play Queue
-(void)clearQueue:(id)sender
{
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_send_clear(self.conn);
//    mpd_connection_free(self.conn);
 //   [self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
}



- (void) deleteQueue:(int)pos {
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    mpd_run_delete(self.conn, pos);
//    mpd_connection_free(self.conn);
 //   [self updateView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    });
    
    [self.m_tableView reloadData];
}

- (void) cargarTabla{
    
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        
    }
    else
    {
    
   //     NSMutableArray * internalElement = [[NSMutableArray alloc] init];
    
   
        
        NSInteger pos;
        NSLog(@"%s\n", __func__);
        //    [self initializeConnection];
        if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
        {
            NSLog(@"Connection error - %d", mpd_connection_get_error(self.conn));
            //        mpd_connection_free(self.conn);
            //        [self initializeConnection];
            pos = 0;
        }
        struct mpd_status * status;
        //    mpd_command_list_begin(self.conn, true);//kgh
        //    mpd_send_status(self.conn);
        //    mpd_command_list_end(self.conn);
        //
        //    status = mpd_recv_status(self.conn);
        status = mpd_run_status(self.conn);
        
        if (status == NULL)
        {
            NSLog(@"Connection error status");
            //        mpd_connection_free(self.conn);
            //        [self initializeConnection];
            pos = 0;
            
        }
        else
        {
            pos = mpd_status_get_queue_length(status);
            //    mpd_connection_free(self.conn);
            //    mpd_status_free(status);
            self.prevRowCount = self.rowCount;
            self.rowCount = pos;
            
           SongTitle = [[NSMutableArray alloc] init];
           SongAlbum = [[NSMutableArray alloc] init];
                        
            NSMutableArray * SongTitle_tmp = [[NSMutableArray alloc] init];
            NSMutableArray * SongArtist_tmp = [[NSMutableArray alloc] init];
            NSMutableArray * SongTime_tmp = [[NSMutableArray alloc] init];
            NSMutableArray * SongStatus_tmp = [[NSMutableArray alloc] init];
            
            for (int x=0; x<pos; x++) {
                struct mpd_song *nextSong = malloc(sizeof(struct mpd_song));
                nextSong=mpd_run_get_queue_song_pos(self.conn, x);
                //        [[cell detailTextLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_ARTIST, 0)]];
                //        [[cell textLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_TITLE, 0)]];
                if(nextSong!=NULL)
                {
                    char* szTitle = (char*)mpd_song_get_tag(nextSong, MPD_TAG_TITLE, 0);
                    if (szTitle == nil) {
                        szTitle = "Unkown Title";
                    }
                 //   [SongTitle_tmp addObject:[[NSString alloc] initWithUTF8String:szTitle]];
                    [SongTitle addObject:[[NSString alloc] initWithUTF8String:szTitle]];
                    
                    char* szAlbum = (char*)mpd_song_get_tag(nextSong, MPD_TAG_ALBUM, 0);
                    if (szAlbum == nil) {
                        szAlbum = "Album desconocido";
                    }
                    
                    [SongAlbum addObject:[[NSString alloc] initWithUTF8String:szAlbum]];
                    
                    char* szArtist = (char*)mpd_song_get_tag(nextSong, MPD_TAG_ARTIST, 0);
                    if (szArtist == nil)
                        szArtist = "Unkown Aritist";
                    //  labelArtist.text = [[NSString alloc] initWithUTF8String:szArtist];
                    
                    [SongArtist_tmp addObject:[[NSString alloc] initWithUTF8String:szArtist]];
                    
                    //   UILabel* labelTime = (UILabel*)[cell.contentView viewWithTag:4];
                    int totalTime = mpd_song_get_duration(nextSong);
                    [SongTime_tmp addObject:[NSString stringWithFormat:@"%u:%02u", totalTime/60, totalTime%60 ]];
                    //   labelTime.text = [NSString stringWithFormat:@"%u:%02u", totalTime/60, totalTime%60 ];
                    
                    // struct mpd_status * status;
                    
                    // status = mpd_run_status(self.conn);
                    [SongStatus_tmp addObject:[NSNumber numberWithInteger:mpd_status_get_song_pos(status)]];
                
                }
                
                
            }
            //  NSLog(@"%@",self.SongArtist);
            
            SongTime = SongTime_tmp;
       //     SongTitle = SongTitle_tmp;
            SongArtist = SongArtist_tmp;
            SongStatus = SongStatus_tmp;
            
            //  [self.m_tableView reloadData];
            
            /*   NSMutableArray *SongTitle;
             NSMutableArray *SongArtist;
             NSMutableArray *SongTime;
             NSMutableArray *SongStatus;
             
             [internalElement addObject:[json valueForKey:@"title"]];
             [internalElement addObject:[json valueForKey:@"introtext"]];
             [internalElement addObject:[json valueForKey:@"imagen"]];
             [internalElement addObject:[json valueForKey:@"latitud"]];
             [internalElement addObject:[json valueForKey:@"longitud"]];
             [internalElement addObject:[json valueForKey:@"catid"]];
             [internalElement addObject:[json valueForKey:@"catname"]];
             [internalElement addObject:[json valueForKey:@"filtro"]];
             [internalElement addObject:[json valueForKey:@"title"]];
             
             [internalElement addObject:[json valueForKey:@"filtrocompras"]];
             [internalElement addObject:[json valueForKey:@"horario_comercio"]];
             [internalElement addObject:[json valueForKey:@"telefono"]];
             [internalElement addObject:[json valueForKey:@"email"]];
             [internalElement addObject:[json valueForKey:@"web"]];
             [internalElement addObject:[json valueForKey:@"sugerir"]];
             [internalElement addObject:[json valueForKey:@"pintxo"]];
             [internalElement addObject:[json valueForKey:@"5dto"]];
             [internalElement addObject:[json valueForKey:@"10dto"]];
             [internalElement addObject:[json valueForKey:@"cine"]];
             [internalElement addObject:[json valueForKey:@"tipodato"]];
             [internalElement addObject:[json valueForKey:@"fechainicio"]];
             [internalElement addObject:[json valueForKey:@"fechafin"]];
             */
            [self.m_tableView reloadData];
            
            
            //      NSLog(@"%lu",(unsigned long)[internalElement count]);
            
            //   self.SongData = internalElement;

        }
    }

}

- (IBAction)SwipeLeft:(id)sender
{
    if(posScreen==0)
    {
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaPrincipal.frame;
            theFrame.origin.x = 0.f;
            
            VistaPrincipal.frame = theFrame;
            
            
        }];
        
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaMenu.frame;
            theFrame.origin.x = -280.f;
            
            VistaMenu.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonNowPlaying.frame;
            theFrame.origin.x = 104.f;
            
            buttonNowPlaying.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonHublist.frame;
            theFrame.origin.x = 235.f;
            
            buttonHublist.frame = theFrame;
            
            
        }];

        
        posScreen = 1;

    }
    else if(posScreen==1)
    {
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaPrincipal.frame;
            theFrame.origin.x = -320.f;
            
            VistaPrincipal.frame = theFrame;
            
            
        }];
        
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaListado.frame;
            theFrame.origin.x = 0.f;
            
            VistaListado.frame = theFrame;
            
            
        }];
        
        
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonNowPlaying.frame;
            theFrame.origin.x = 0.f;
            
            buttonNowPlaying.frame = theFrame;
            
            
        }];
        
        [TableSongs reloadData];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonHublist.frame;
            theFrame.origin.x = 120.f;
            
            buttonHublist.frame = theFrame;
            
            
        }];
        [buttonHublist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
        [buttonHublist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonNowPlaying setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
        [buttonNowPlaying setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        
        posScreen = 2;
    }
}

- (IBAction)SwipeRight:(id)sender
{
    
    if(posScreen==1)
    {
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaPrincipal.frame;
            theFrame.origin.x = 279.f;
            
            VistaPrincipal.frame = theFrame;
            
            
        }];
        
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaMenu.frame;
            theFrame.origin.x = 0.f;
            
            VistaMenu.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonNowPlaying.frame;
            theFrame.origin.x = 383.f;
            
            buttonNowPlaying.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonHublist.frame;
            theFrame.origin.x = 504.f;
            
            buttonHublist.frame = theFrame;
            
            
        }];
        
        posScreen = 0;

    }
    else if(posScreen==2)
    {
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaPrincipal.frame;
            theFrame.origin.x = 0.f;
            
            VistaPrincipal.frame = theFrame;
            
            
        }];
        
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = VistaListado.frame;
            theFrame.origin.x = 320.f;
            
            VistaListado.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonNowPlaying.frame;
            theFrame.origin.x = 104.f;
            
            buttonNowPlaying.frame = theFrame;
            
            
        }];
        
        [UIButton animateWithDuration:.3f animations:^{
            CGRect theFrame = buttonHublist.frame;
            theFrame.origin.x = 235.f;
            
            buttonHublist.frame = theFrame;
            
            
        }];

        [buttonNowPlaying setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
        [buttonNowPlaying setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonHublist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
        [buttonHublist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        posScreen = 1;
        
    }


}


- (IBAction)ActionNowPlaying:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaPrincipal.frame;
        theFrame.origin.x = 0.f;
        
        VistaPrincipal.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaListado.frame;
        theFrame.origin.x = 320.f;
        
        VistaListado.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonNowPlaying.frame;
        theFrame.origin.x = 104.f;
        
        buttonNowPlaying.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonHublist.frame;
        theFrame.origin.x = 235.f;
        
        buttonHublist.frame = theFrame;
        
        
    }];
    
    [buttonNowPlaying setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
    [buttonNowPlaying setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonHublist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
    [buttonHublist setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    posScreen = 1;
    
    
}

- (IBAction)ActionHublist:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaPrincipal.frame;
        theFrame.origin.x = -320.f;
        
        VistaPrincipal.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaListado.frame;
        theFrame.origin.x = 0.f;
        
        VistaListado.frame = theFrame;
        
        
    }];
    
    [TableSongs reloadData];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonNowPlaying.frame;
        theFrame.origin.x = 0.f;
        
        buttonNowPlaying.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonHublist.frame;
        theFrame.origin.x = 120.f;
        
        buttonHublist.frame = theFrame;
        
        
    }];
    
    [buttonHublist setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie.png"] forState:UIControlStateNormal];
    [buttonHublist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNowPlaying setBackgroundImage:[UIImage imageNamed:@"fondo_btn_pie_unselect.png"] forState:UIControlStateNormal];
    [buttonNowPlaying setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    posScreen = 2;

    
}

- (IBAction)ActionBuscar:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaPrincipal.frame;
        theFrame.origin.x = 0.f;
        
        VistaPrincipal.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaMenu.frame;
        theFrame.origin.x = -280.f;
        
        VistaMenu.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonNowPlaying.frame;
        theFrame.origin.x = 104.f;
        
        buttonNowPlaying.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonHublist.frame;
        theFrame.origin.x = 235.f;
        
        buttonHublist.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = _VistaBuscar.frame;
        theFrame.origin.x = 0.f;
        
        _VistaBuscar.frame = theFrame;
        
        
    }];
    
    posScreen = 1;
}

- (IBAction)CerrarBusqueda:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = _VistaBuscar.frame;
        theFrame.origin.x = -320.f;
        
        _VistaBuscar.frame = theFrame;
        
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = _VistaBuscar.frame;
        theFrame.origin.x = -320.f;        
        _VistaBuscar.frame = theFrame;        
        
    }];
    
    if(![textField.text isEqualToString:@""])
    {
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.Busqueda = textField.text;
        [_BotonBuscarVista sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    return YES;
    
}

- (IBAction)showMenuconfig:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaPrincipal.frame;
        theFrame.origin.x = 279.f;
        
        VistaPrincipal.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaMenu.frame;
        theFrame.origin.x = 0.f;
        
        VistaMenu.frame = theFrame;
        
        
    }];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = VistaListado.frame;
        theFrame.origin.x = 320.f;
        
        VistaListado.frame = theFrame;
        
        
    }];
    
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonNowPlaying.frame;
        theFrame.origin.x = 383.f;
        
        buttonNowPlaying.frame = theFrame;
        
        
    }];
    
    [UIButton animateWithDuration:.3f animations:^{
        CGRect theFrame = buttonHublist.frame;
        theFrame.origin.x = 504.f;
        
        buttonHublist.frame = theFrame;
        
        
    }];
    
    posScreen = 0;

}

// Override to support conditional editing of the table view.



- (void)dealloc {
    dispatch_release(backgroundQueue);
    [LabelGroupSong release];
    [LabelNameSong release];
    [LabelAlbumSong release];
    [LabelCurrentTime release];
    [LabelTotalTime release];
    [BotonPlayPause release];
    [VistaPrincipal release];
    [VistaMenu release];
    [VistaListado release];
    [buttonNowPlaying release];
    [buttonHublist release];
    [TableSongs release];
    
    [LabelNameSongMini release];
    [LabelAlbumSongMini release];
    [_m_imageThumbMini release];
    [_m_btnPlayMini release];
    [_VistaBuscar release];
    [_BotonLibrary release];
    [_BotonBuscarVista release];
    [super dealloc];
}
@end

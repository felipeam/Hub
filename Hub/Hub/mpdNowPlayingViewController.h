//
//  mpdFirstViewController.h
//  MPpleD
//
//  Created by Kyle Hershey on 2/11/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mpd/client.h>
#import <mpd/status.h>
#import "mpdConnectionData.h"
#import <dispatch/dispatch.h>

@interface mpdNowPlayingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIActionSheetDelegate>
{
    NSMutableArray *SongTitle;
    NSMutableArray *SongAlbum;
    NSMutableArray *SongArtist;
    NSMutableArray *SongTime;
    NSMutableArray *SongStatus;
    dispatch_queue_t backgroundQueue;
}



@property (nonatomic,retain) NSArray *SongTitle;
@property (nonatomic,retain) NSArray *SongAlbum;
@property (nonatomic,retain) NSArray *SongArtist;
@property (nonatomic,retain) NSArray *SongTime;
@property (nonatomic,retain) NSArray *SongStatus;

//Outlets
//@property (weak, nonatomic) IBOutlet UILabel *songTitle;
//@property (weak, nonatomic) IBOutlet UILabel *artistText;
//@property (weak, nonatomic) IBOutlet UILabel *albumText;
//@property (weak, nonatomic) IBOutlet UILabel *trackText;
//@property (weak, nonatomic) IBOutlet UILabel *curPos;
//@property (weak, nonatomic) IBOutlet UILabel *totTime;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *prev;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *play;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *next;
//@property (weak, nonatomic) IBOutlet UISlider *volume;
//@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//@property (strong, nonatomic) IBOutlet UIImageView *artViewer;

@property (strong, nonatomic) IBOutlet UIView *m_viewList;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl* m_segmentPlay;
@property (strong, nonatomic) IBOutlet UISegmentedControl* m_segmentEdit;
@property (strong, nonatomic) IBOutlet UISegmentedControl* m_segmentVolume;
@property (strong, nonatomic) UILabel *m_labelArtist;
@property (strong, nonatomic) UILabel *m_labelAlbum;
@property (strong, nonatomic) IBOutlet UIView *m_viewVolume;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgVolume;
//cover view
@property (strong, nonatomic) IBOutlet UIView *m_viewCover;
@property (strong, nonatomic) IBOutlet UIImageView *m_imageThumb;
@property (retain, nonatomic) IBOutlet UIImageView *m_imageThumbMini;
@property (strong, nonatomic) IBOutlet UIView *m_viewSeek;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (retain, nonatomic) IBOutlet UIButton *m_btnPlayMini;
@property (strong, nonatomic) IBOutlet UIButton *m_btnStop;
@property (strong, nonatomic) IBOutlet UISlider *m_sliderProgress;

//@property (strong, nonatomic) NSString *artistText;
//@property (strong, nonatomic) NSString *albumText;

//Connection Settings:
@property struct mpd_connection *conn;
@property const char* host;
@property int port;

@property int posScreen;

@property (retain, nonatomic) IBOutlet UILabel *LabelGroupSong;
@property (retain, nonatomic) IBOutlet UILabel *LabelNameSong;
@property (retain, nonatomic) IBOutlet UILabel *LabelAlbumSong;
@property (retain, nonatomic) IBOutlet UILabel *LabelNameSongMini;
@property (retain, nonatomic) IBOutlet UILabel *LabelAlbumSongMini;


@property (retain, nonatomic) IBOutlet UILabel *LabelCurrentTime;
@property (retain, nonatomic) IBOutlet UILabel *LabelTotalTime;
@property (retain, nonatomic) IBOutlet UIButton *BotonPlayPause;
@property (retain, nonatomic) IBOutlet UIView *VistaPrincipal;
@property (retain, nonatomic) IBOutlet UIView *VistaMenu;
@property (retain, nonatomic) IBOutlet UIView *VistaListado;
@property (retain, nonatomic) IBOutlet UIButton *buttonNowPlaying;
@property (retain, nonatomic) IBOutlet UIButton *buttonHublist;

@property (retain, nonatomic) IBOutlet UITableView *TableSongs;



//Timers
@property NSTimer *connectTimer;
@property NSTimer *updateTimer;
@property NSTimer *updateTimerTabla;
@property NSTimer *clockTimer;
@property NSTimer *updateTable;

//Data
@property BOOL playing;
@property BOOL isConnected;

@property int currentTime;
@property int totalTime;

@property UIImage *artwork;
@property id artworkPath;

//Data
@property NSInteger rowCount;
@property NSInteger prevRowCount;

@property BOOL randomState;
@property BOOL repeatState;

@property int m_nVolume;

@property BOOL m_bShowCover;
@property (retain, nonatomic) IBOutlet UIView *VistaBuscar;
@property (retain, nonatomic) IBOutlet UIButton *BotonLibrary;
@property (retain, nonatomic) IBOutlet UIButton *BotonBuscarVista;

//Actions
-(IBAction)clearQueue:(id)sender;
- (IBAction)showMenuconfig:(id)sender;

//Actions
-(IBAction)playPausePush:(id)sender;
-(IBAction)stopPush:(id)sender;
- (IBAction)NextSong:(id)sender;
- (IBAction)PrevSong:(id)sender;
- (IBAction)RandomSong:(id)sender;
- (IBAction)RepeatSong:(id)sender;
- (IBAction)ActionNowPlaying:(id)sender;
- (IBAction)ActionHublist:(id)sender;
- (IBAction)ActionBuscar:(id)sender;
- (IBAction)CerrarBusqueda:(id)sender;



- (IBAction)SwipeLeft:(id)sender;
- (IBAction)SwipeRight:(id)sender;

-(void)nextPush:(id)sender;
-(void)prevPush:(id)sender;
-(void)sliderValueChanged:(id)sender; //Volume
-(IBAction)positionValueChanged:(UISlider *)sender;
-(void)artClick:(id)sender;
-(void)artistClick:(id)sender;
- (IBAction)CellButtonClick:(id)sender;

//setting action
-(IBAction)segmentSettingsClick:(id)sender;
-(IBAction)segmentPlayItemsClick:(id)sender;
-(IBAction)segmentEditItemsClick:(id)sender;
-(IBAction)segmentVolumeItemsClick:(id)sender;

-(IBAction)onCover:(id)sender;
-(void) changeEditSegImage;

//cover view
- (void) initSeekView;
- (void) setCoverImage;
- (void) showSeekView;
- (void) hideSeekView;

//volume View

- (void) initVolumeView;
- (void) changeVolumeImage:(int)volume;
- (void) hideSoundView;

- (void) mpd_connection_new;
- (void) mpd_connection_free;
- (BOOL) mpd_connection_fail;

@end

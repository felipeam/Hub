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

@interface mpdNowPlayingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

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
@property (weak, nonatomic) IBOutlet UISegmentedControl* m_segmentPlay;
@property (weak, nonatomic) IBOutlet UISegmentedControl* m_segmentEdit;
@property (weak, nonatomic) IBOutlet UISegmentedControl* m_segmentVolume;
@property (strong, nonatomic) UILabel *m_labelArtist;
@property (strong, nonatomic) UILabel *m_labelAlbum;
@property (strong, nonatomic) IBOutlet UIView *m_viewVolume;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgVolume;
//cover view
@property (strong, nonatomic) IBOutlet UIView *m_viewCover;
@property (strong, nonatomic) IBOutlet UIImageView *m_imageThumb;
@property (strong, nonatomic) IBOutlet UIView *m_viewSeek;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (strong, nonatomic) IBOutlet UIButton *m_btnStop;
@property (strong, nonatomic) IBOutlet UISlider *m_sliderProgress;

//@property (strong, nonatomic) NSString *artistText;
//@property (strong, nonatomic) NSString *albumText;

//Connection Settings:
@property struct mpd_connection *conn;
@property const char* host;
@property int port;

//Timers
@property NSTimer *connectTimer;
@property NSTimer *updateTimer;
@property NSTimer *clockTimer;

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

//Actions
-(IBAction)clearQueue:(id)sender;

//Actions
-(IBAction)playPausePush:(id)sender;
-(IBAction)stopPush:(id)sender;
-(void)nextPush:(id)sender;
-(void)prevPush:(id)sender;
-(void)sliderValueChanged:(id)sender; //Volume
-(IBAction)positionValueChanged:(UISlider *)sender;
-(void)artClick:(id)sender;
-(void)artistClick:(id)sender;

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

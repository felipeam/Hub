//
//  artistList.h
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/21/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mpd/status.h>
#import <mpd/client.h>
#import "mpdConnectionData.h"

@interface playlistsList : NSObject

//Connection Settings
@property struct mpd_connection *conn;
@property const char* host;
@property int port;

@property int nTagType;

//Data
@property NSMutableArray *playlists;

//Functions
-(NSString*)playlistsAtIndex:(NSUInteger)row;
-(NSUInteger)playlistsCount;
-(void)addSongAtIndexToQueue:(NSUInteger)row;

-(void)initializeDataList:(NSString*)strSearch tagtype:(int)type;

@end

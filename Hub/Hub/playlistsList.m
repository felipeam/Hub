//
//  artistList.m
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/21/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "playlistsList.h"
#import "mpdConnectionData.h"

@interface playlistsList ()

- (void)initializeDefaultDataList;

@end

@implementation playlistsList

- (id)init {
    
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    
    return nil;
    
}

-(void)initializeConnection
{
    mpdConnectionData *connection = [mpdConnectionData sharedManager];
    self.host = [connection.host UTF8String];
    self.port = [connection.port intValue];
    self.conn = mpd_connection_new(self.host, self.port, 30000);
}


-(void)initializeDefaultDataList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.playlists = list;
    
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
//    struct mpd_pair *pair;
//    
//    if (!mpd_search_db_tags(self.conn, MPD_TAG_ARTIST) ||
//        !mpd_search_commit(self.conn))
//        return;
//    
//    while ((pair = mpd_recv_pair_tag(self.conn, MPD_TAG_ARTIST)) != NULL)
//    {
//        NSString *artistString = [[NSString alloc] initWithUTF8String:pair->value];
//        [self.browses addObject:artistString];
//        mpd_return_pair(self.conn, pair);
//    }

    if (!mpd_send_list_playlists(self.conn))
        return;
    
    struct mpd_playlist *playlist;
    while ((playlist = mpd_recv_playlist(self.conn)) != NULL) {
        NSString *artistString = [[NSString alloc] initWithUTF8String:mpd_playlist_get_path(playlist)];
        [self.playlists addObject:artistString];
       // mpd_playlist_free(playlist);
    }

    mpd_connection_free(self.conn);
   // [self.playlists sortUsingSelector:@selector(compare:)];
}

-(void)initializeDataList:(NSString*)strSearch tagtype:(int)type {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.playlists = list;
    
//    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    struct mpd_pair *pair;
    
    const char *cSearch = [strSearch UTF8String];
    self.nTagType = type;
    mpd_command_list_begin(self.conn, true);
    mpd_search_db_songs(self.conn, true);
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, type, cSearch);
    
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    
    while ((pair = mpd_recv_pair_tag(self.conn, type)) != NULL)
    {
        NSString *artistString = [[NSString alloc] initWithUTF8String:pair->value];
        NSRange range = [artistString rangeOfString:strSearch options:NSCaseInsensitiveSearch];
        if(range.length > 0) {
            [self.playlists addObject:artistString];
//            NSLog(@"%@", artistString);
        }
        mpd_return_pair(self.conn, pair);
    }
    mpd_enqueue_pair(self.conn, pair);
    
//    mpd_connection_free(self.conn);
//    [self.browses sortUsingSelector:@selector(compare:)];
}
-(NSString*)playlistsAtIndex:(NSUInteger)row
{
    return [self.playlists objectAtIndex:row];
}

-(NSUInteger)playlistsCount
{
    return [self.playlists count];
}

-(void)addSongAtIndexToQueue:(NSUInteger)row
{
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    
    mpd_command_list_begin(self.conn, true);
    mpd_search_queue_songs(self.conn, TRUE);
    
    mpd_search_add_any_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, [[self.playlists objectAtIndex:row] UTF8String]);
    
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    mpd_connection_free(self.conn);
    
}

-(void)addAlbumAtSectionAndIndexToQueue:(NSUInteger)section row:(NSUInteger)row /*artist:(NSString *)artist */
{
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
   /*
    mpd_command_list_begin(self.conn, true);
    
    mpd_search_add_db_songs(self.conn, TRUE);
    
    if(artist!=NULL) //we are in an artists list, so add that constraint
    {
        mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ARTIST, [artist UTF8String]);
    }
    if(![[self albumAtSectionAndIndex:section row:row] isEqualToString:@"All"])  //only add album if it is not all
    {
        mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, [[self albumAtSectionAndIndex:section row:row] UTF8String]);
    }
    */
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    mpd_connection_free(self.conn);
    
}

@end

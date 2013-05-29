//
//  artistList.m
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/21/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "playingList.h"
#import "mpdConnectionData.h"

@interface playingList ()

- (void)initializeDefaultDataList;

@end

@implementation playingList

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
    self.playings = list;
}

-(void)initializeDataList:(struct mpd_connection *)connection {
    /*
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.playings = list;
    
    self.conn = connection;
    
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        return;
    }
    struct mpd_pair *pair;
    struct mpd_status * status;
    mpd_command_list_begin(self.conn, true);//kgh
    mpd_send_status(self.conn);
    mpd_command_list_end(self.conn);
    
    status = mpd_recv_status(self.conn);
    
    if (status == NULL)
    {
        NSLog(@"Connection error status");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return 0;
    }
    
    pos = mpd_status_get_queue_length(status);

    struct mpd_song *nextSong = malloc(sizeof(struct mpd_song));
    nextSong=mpd_run_get_queue_song_pos(self.conn, indexPath.row);
    //        [[cell detailTextLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_ARTIST, 0)]];
    //        [[cell textLabel] setText:[[NSString alloc] initWithUTF8String:mpd_song_get_tag(nextSong, MPD_TAG_TITLE, 0)]];
    UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
    
    char* szTitle = (char*)mpd_song_get_tag(nextSong, MPD_TAG_TITLE, 0);
    if (szTitle == nil) {
        szTitle = "Unkown Title";
    }
    labelTitle.text = [[NSString alloc] initWithUTF8String:szTitle];
    UILabel* labelArtist = (UILabel*)[cell.contentView viewWithTag:3];
    char* szArtist = (char*)mpd_song_get_tag(nextSong, MPD_TAG_ARTIST, 0);

    if (!mpd_search_db_tags(self.conn, MPD_TAG_ARTIST) ||
        !mpd_search_commit(self.conn))
        return;
    
    while ((pair = mpd_recv_pair_tag(self.conn, MPD_TAG_ARTIST)) != NULL)
    {
        NSString *artistString = [[NSString alloc] initWithUTF8String:pair->value];
        NSRange range = [artistString rangeOfString:strSearch options:NSCaseInsensitiveSearch];
        if(range.length > 0)
            [self.playings addObject:artistString];
        mpd_return_pair(self.conn, pair);
    }
    
    mpd_connection_free(self.conn);
     */
}
-(NSString*)artistAtSectionAndIndex:(NSUInteger)section row:(NSUInteger)row
{
    return [[self sectionArray:section] objectAtIndex:row];
}

-(NSUInteger)artistCount
{
    return [self.playings count];
}

-(void)addArtistAtSectionAndIndexToQueue:(NSUInteger)section row:(NSUInteger)row;
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
    mpd_search_add_db_songs(self.conn, TRUE);
    
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, MPD_TAG_ARTIST, [[self artistAtSectionAndIndex:section row:row] UTF8String]);
    
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    mpd_connection_free(self.conn);
    
}

@end

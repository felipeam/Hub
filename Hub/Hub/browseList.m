//
//  artistList.m
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/21/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "browseList.h"
#import "mpdConnectionData.h"

@interface browseList ()

- (void)initializeDefaultDataList;

@end

@implementation browseList

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
    self.browses = list;
    
    return;
//    [self initializeConnection];
//    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
//    {
//        NSLog(@"Connection error");
//        mpd_connection_free(self.conn);
//        [self initializeConnection];
//        return;
//    }
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
//    
//    mpd_connection_free(self.conn);
//    [self.browses sortUsingSelector:@selector(compare:)];
}

-(void)initializeDataList:(NSString*)strSearch tagtype:(int)type {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.browses = list;
    
    [self initializeConnection];
    if (mpd_connection_get_error(self.conn) != MPD_ERROR_SUCCESS)
    {
        NSLog(@"Connection error");
        mpd_connection_free(self.conn);
        [self initializeConnection];
        return;
    }
    struct mpd_pair *pair;
    
//    if (!mpd_search_db_tags(self.conn, type) ||
//        !mpd_search_commit(self.conn))
//        return;
    const char *cSearch = [strSearch UTF8String];
    self.nTagType = type;
    mpd_command_list_begin(self.conn, true);
    mpd_search_db_songs(self.conn, true);
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, type, cSearch);
    
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    
    while ((pair = mpd_recv_pair_tag(self.conn, type)) != NULL)
    {
//        if (self.conn->pair_state != PAIR_STATE_FLOATING)
//            continue;
        NSString *artistString = [[NSString alloc] initWithUTF8String:pair->value];
        [self.browses addObject:artistString];
//        NSRange range = [artistString rangeOfString:strSearch options:NSCaseInsensitiveSearch];
//        if(range.length > 0) {
//            [self.browses addObject:artistString];
////            NSLog(@"%@", artistString);
//        }
//        else {
//            NSLog(@"key - %@", artistString);
//        }
        mpd_return_pair(self.conn, pair);
    }
    mpd_enqueue_pair(self.conn, pair);
    mpd_connection_free(self.conn);
//    [self.browses sortUsingSelector:@selector(compare:)];
}
-(NSString*)browseAtIndex:(NSUInteger)row
{
    if ([self.browses count] <= row) {
        NSLog(@"error-0");
        return @"";
    }
    return [self.browses objectAtIndex:row];
}

-(NSUInteger)browseCount
{
    return [self.browses count];
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
    mpd_search_add_db_songs(self.conn, TRUE);
    
    mpd_search_add_tag_constraint(self.conn, MPD_OPERATOR_DEFAULT, self.nTagType, [[self.browses objectAtIndex:row] UTF8String]);
    
    mpd_search_commit(self.conn);
    mpd_command_list_end(self.conn);
    mpd_connection_free(self.conn);
    
}

@end

//
//  mpdConnectionData.h
//  MPpleD
//
//  Created by Kyle Hershey on 2/16/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mpd/client.h>
#import <mpd/status.h>

@interface mpdConnectionData : NSObject{
    NSString *host;
    NSNumber *port;
}

@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSNumber *port;

@property struct mpd_connection *conn;

+ (id)sharedManager;

- (void) createConnection;
- (void) releaseConnection;
- (BOOL) isConnected;

@end

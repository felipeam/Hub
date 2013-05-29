//
//  PlayerInfo.m
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

+ (NSString*) getPlayerSettingText:(int)type {
    NSString* str = nil;
    switch (type) {
        case kPlayerName:
            str = @"Name";
            break;
        case kPlayerConnectionMode:
            str = @"Connect mode";
            break;
        case kPlayerMPDServer:
            str = @"Server";
            break;
        case kPlayerMPDPort:
            str = @"Port";
            break;
        case kPlayerMPDPassword:
            str = @"Password";
            break;
        case kPlayerMPDUseLocalCache:
            str = @"Use local cache";
            break;
        default:
            break;
    }
    return str;
}

+ (NSString*) getPlayerConnectionModeText:(int)type {
    NSString* str;
    if (type == CONNECTIONMODE_REMOTE)
        str = @"Remote";
    else
        str = @"On the go";
    return str;
}
+ (NSString*) getPlayerUseLocalCacheText:(BOOL)bType {
    NSString* str;
    if (bType)
        str = @"Yes";
    else
        str = @"No";
    return str;
}

- (id) init {
    if ((self = [super init])) {
        self.m_strMPDPort = @"6600";
        self.m_bMPDLocalCache = YES;
#if 1
        self.m_strMPDServer = @"192.168.1.148";
#endif
    }
    return self;
}

- (id) initWithPlayer:(PlayerInfo*)player {
    self = [self init];
    if (player.m_strName != nil)
        self.m_strName = [NSString stringWithString:player.m_strName];
    self.m_nConnectionMode = player.m_nConnectionMode;
    if (player.m_strMPDServer != nil)
        self.m_strMPDServer = [NSString stringWithString:player.m_strMPDServer];
    if (player.m_strMPDPort != nil)
        self.m_strMPDPort = [NSString stringWithString:player.m_strMPDPort];
    if (player.m_strMPDPassword != nil)
        self.m_strMPDPassword = [NSString stringWithString:player.m_strMPDPassword];
    self.m_bMPDLocalCache = player.m_bMPDLocalCache;
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dic {
    self = [self init];
    NSString* str = [dic objectForKey:@"name"];
    if (str != nil)
        self.m_strName = [NSString stringWithString:str];
    self.m_nConnectionMode = [[dic objectForKey:@"ConnectionMode"] intValue];
    str = [dic objectForKey:@"MPDServer"];
    if (str != nil)
        self.m_strMPDServer = [NSString stringWithString:str];
    str = [dic objectForKey:@"MPDPort"];
    if (str != nil)
        self.m_strMPDPort = [NSString stringWithString:str];
    str = [dic objectForKey:@"MPDPassword"];
    if (str != nil)
        self.m_strMPDPassword = [NSString stringWithString:str];
    self.m_bMPDLocalCache = [[dic objectForKey:@"MPDLocalCache"] intValue];
    return self;
}
- (NSDictionary*) getDictionayData {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    NSString* str = self.m_strName;
    if (str == nil)
        str = @"";
    [dic setObject:str forKey:@"name"];
    [dic setObject:[NSNumber numberWithInt:self.m_nConnectionMode] forKey:@"ConnectionMode"];
    str = self.m_strMPDServer;
    if (str == nil)
        str = @"";
    [dic setObject:str forKey:@"MPDServer"];
    str = self.m_strMPDPort;
    if (str == nil)
        str = @"";
    [dic setObject:str forKey:@"MPDPort"];
    str = self.m_strMPDPassword;
    if (str == nil)
        str = @"";
    [dic setObject:str forKey:@"MPDPassword"];
    [dic setObject:[NSNumber numberWithInt:self.m_bMPDLocalCache] forKey:@"MPDLocalCache"];
    return dic;
}
@end

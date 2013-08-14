//
//  PlayerInfo.h
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <Foundation/Foundation.h>

enum  {
    kPlayerName = 0,
    kPlayerConnectionMode,
    kPlayerMPDServer,
    kPlayerMPDPort,
    kPlayerMPDPassword,
    kPlayerMPDUseLocalCache,
};

enum CONNECTIONMODE_TYPE {
    CONNECTIONMODE_REMOTE = 0,
    CONNECTIONMODE_ONTHEGO
    };

@interface PlayerInfo : NSObject {
}

@property (nonatomic, strong)NSString* m_strName;
@property (nonatomic)int m_nConnectionMode;
@property (nonatomic, strong)NSString* m_strMPDServer;
@property (nonatomic, strong)NSString* m_strMPDPort;
@property (nonatomic, strong)NSString* m_strMPDPassword;
@property (nonatomic)int m_bMPDLocalCache;

+ (NSString*) getPlayerSettingText:(int)type;
+ (NSString*) getPlayerConnectionModeText:(int)type;
+ (NSString*) getPlayerUseLocalCacheText:(BOOL)bType;

- (id) initWithPlayer:(PlayerInfo*)player;
- (id) initWithDictionary:(NSDictionary*)dic;
- (NSDictionary*) getDictionayData;

@end

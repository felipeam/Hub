//
//  GameOptionInfo.h
//  Sudoku
//
//  Created by Kwang on 11/05/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInfo.h"

#define NEW_PLAYER  -1

enum SERVICE_TYPE {
    SERVICE_SPOTOFY = 1,
    SERVICE_RDIO,
    SERVICE_SOUNDCLOUD,
};
@interface GameUnit : NSObject {
}

@property (nonatomic, strong) NSMutableArray* m_arrayPlayers;
@property (nonatomic, strong) PlayerInfo* m_player;
@property (nonatomic) int m_nSelPlayerInfoId;
@property (nonatomic) BOOL m_bNewCreatePlayer;
@property (nonatomic) int m_nSelPlayer;
@property (nonatomic) int m_nSelServerPlayer;
@property (nonatomic) int m_nSelectServices;

-(void) loadData;
-(void) saveData;

- (NSString*) getRootDirPath;
- (NSString*) getSaveDataFilePath;
- (NSString*) getDataFileFullPath:(NSString*)filename;
- (BOOL) isExistFile:(NSString*)strFilePath;
- (void) removeFile:(NSString*)strFilePath;

@end

extern GameUnit* g_GameUnit;

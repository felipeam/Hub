//
//  GameOptionInfo.m
//  Sudoku
//
//  Created by Kwang on 11/05/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUnit.h"
#import "ProfileInfo.h"

GameUnit* g_GameUnit;

#define _FILE_SAVEDATA_     @"SaveData.plist"

@implementation GameUnit

//@synthesize m_bLogin;
//@synthesize m_arrayContacts, m_nSelContactIndex;
//@synthesize m_userInfo;

-(id) init {
	if ((self = [super init])) {
		[self loadData];
	}
	return self;
}
-(void) loadData {
    NSLog(@"%s\n", __func__);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL bFirst = [defaults boolForKey:@"FirstStartApp"];
    self.m_arrayPlayers = [[NSMutableArray alloc] init];
	if (!bFirst) {
        self.m_nSelServerPlayer = 0;
	}
	else {
        self.m_nSelServerPlayer = [defaults integerForKey:@"ServerPlayer"];
        NSString* strPath = [self getDataFileFullPath:_FILE_SAVEDATA_];
        NSArray* array = [NSArray arrayWithContentsOfFile:strPath];
        for (id obj in array) {
            NSDictionary* dic = (NSDictionary*)obj;
            PlayerInfo* player = [[PlayerInfo alloc] initWithDictionary:dic];
            [self.m_arrayPlayers addObject:player];
        }
	}
}
-(void) saveData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:@"FirstStartApp"];
    [defaults setInteger:self.m_nSelServerPlayer forKey:@"ServerPlayer"];
    NSString* strPath = [self getDataFileFullPath:_FILE_SAVEDATA_];
    NSMutableArray* array = [NSMutableArray array];
    for (id obj in self.m_arrayPlayers) {
        PlayerInfo* player = (PlayerInfo*)obj;
        [array addObject:[player getDictionayData]];
    }
    [array writeToFile:strPath atomically:YES];
}


- (NSString*) createContactImageFileName {
    NSDate* date = [NSDate date];
    NSTimeInterval tm = [date timeIntervalSince1970];
    int nId = (int)tm;
    return [NSString stringWithFormat:@"%d.jpg", nId];
}
- (NSString*) getRootDirPath {
    return NSTemporaryDirectory();
}
- (NSString*) getSaveDataFilePath {
    return [[self getRootDirPath] stringByAppendingPathComponent:_FILE_SAVEDATA_];
}
- (NSString*) getDataFileFullPath:(NSString*)filename {
    return [[self getRootDirPath] stringByAppendingPathComponent:filename];
}
- (BOOL) isExistFile:(NSString*)strFilePath {
    if(![[NSFileManager defaultManager] fileExistsAtPath:strFilePath])
        return NO;
    return YES;
}
- (void) removeFile:(NSString*)strFilePath {
    if ([self isExistFile:strFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:strFilePath error:nil];
    }
}

@end

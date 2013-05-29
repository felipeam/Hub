//
//  SettingInfo.h
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SETTINGSECTION_TYPE {
    SETTINGSECTION_HELP = 0,
    SETTINGSECTION_SERVERACTIONS,
    SETTINGSECTION_DATA,
    SETTINGSECTION_PLAY,
    SETTINGSECTION_COVERART,
    SETTINGSECTION_COUNT
};

//enum SETTINGINFO_TYPE {
//    kSettingAbout = 0,
//    kSettingHelp,
//    kSettingRefresh,
//    kSetting,
//    kSetting,
//    kSetting,
//    kSetting,
//    kSetting,
//    };
@interface SettingInfo : NSObject {
    int m_nSettingSection;
    int m_nSettingSectionRow;
}

@property (nonatomic) int m_nSettingSection;
@property (nonatomic) int m_nSettingSectionRow;

//- (NSString*) getCellText:(NSIndexPath *)indexPath;
@end

extern SettingInfo* g_SettingInfo;
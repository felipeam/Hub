//
//  PlayerSettingViewController.h
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerInfo;
@interface PlayerSettingViewController : UITableViewController {
//    PlayerInfo* m_playerEdit;
}

@property (nonatomic, strong) PlayerInfo* m_playerBackup;

- (NSString*) getCellText:(NSIndexPath *)indexPath;
- (NSString*) getCellValueText:(NSIndexPath *)indexPath;
@end

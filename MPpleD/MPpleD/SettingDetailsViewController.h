//
//  SettingDetailsViewController.h
//  MPpleD
//
//  Created by Apple on 13-4-20.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingDetailsViewController : UITableViewController

- (NSString*) getCellText:(NSIndexPath *)indexPath;
- (int) getRowCount;
- (NSString*) getFootString:(NSIndexPath *)indexPath;

@end

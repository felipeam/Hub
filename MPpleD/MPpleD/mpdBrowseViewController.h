//
//  mpdBrowseViewController.h
//  MPpleD
//
//  Created by Apple on 13-5-10.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "browseList.h"

@interface mpdBrowseViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>

//Data
@property (strong, nonatomic) browseList *searchController;

@end

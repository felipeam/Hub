//
//  mpdArtistViewController.h
//  MPpleD
//
//  Created by KYLE HERSHEY on 2/20/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "artistList.h"

@interface mpdArtistViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>

//Data
@property (strong, nonatomic) artistList *dataController;
@property (strong, nonatomic) artistList *searchController;
@property NSArray *sections;

//@property (nonatomic, strong) UISearchDisplayController *aSearchDisplayController;

//Actions
-(IBAction)backToArtistClick:(UIStoryboardSegue *)segue;

@end

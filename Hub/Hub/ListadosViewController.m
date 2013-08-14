//
//  ListadosViewController.m
//  Hub
//
//  Created by Desarrollo on 27/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "ListadosViewController.h"

@interface ListadosViewController ()


@end

@implementation ListadosViewController
@synthesize posScreen;
@synthesize VistaAlbums;
@synthesize VistaArtists;
@synthesize VistaFiles;
@synthesize VistaPlaylist;
@synthesize buttonAlbums;
@synthesize buttonArtist;
@synthesize buttonFiles;
@synthesize buttonPlaylist;
@synthesize searchController;
@synthesize tablePlaylist;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchController = [[playlistsList alloc] init];
    posScreen = 0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.searchController playlistsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"CeldaIdentifier";
        UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //	if (cell == nil)
        //	{
        //		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //	}
        
        // Configure the cell...
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
            
            
            labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
            
            //  [[cell textLabel] setText:[self.searchController playlistsAtIndex:indexPath.row]];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UILabel* labelTitle = (UILabel*)[cell.contentView viewWithTag:2];
            
            
            labelTitle.text = [self.searchController playlistsAtIndex:indexPath.row];
            //   [[cell textLabel] setText:[self.searchController playlistsAtIndex:indexPath.row]];
        }
        
        
        //    UILongPressGestureRecognizer *longPressGesture =
        //    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        //    [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    
    
    
}






- (void)dealloc {
    [VistaPlaylist release];
    [VistaAlbums release];
    [VistaArtists release];
    [VistaFiles release];
    [buttonPlaylist release];
    [buttonAlbums release];
    [buttonArtist release];
    [buttonFiles release];
    [tablePlaylist release];
    [super dealloc];
}
- (IBAction)Swipeleft:(id)sender {
    switch (posScreen) {
        case 0:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -320.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 0.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 640.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 220.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 330.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];

            
            posScreen = 1;
            break;
        case 1:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -640.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 0.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 320.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 0.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 110.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 220.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            posScreen = 2;
            break;
        case 2:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -960.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -640.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = -320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 0.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -220.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = -110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 0.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 110.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            posScreen = 3;
            break;
        
    }
    
}

- (IBAction)Swiperight:(id)sender {
    switch (posScreen) {
        case 1:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 640.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 960.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 220.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 330.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 440.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            posScreen = 0;
            break;
        case 2:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -320.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = 0.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 320.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 640.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = 0.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 110.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 220.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 330.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            posScreen = 1;
            break;
        case 3:
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaPlaylist.frame;
                theFrame.origin.x = -640.f;
                
                VistaPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaAlbums.frame;
                theFrame.origin.x = -320.f;
                
                VistaAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaArtists.frame;
                theFrame.origin.x = 0.f;
                
                VistaArtists.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = VistaFiles.frame;
                theFrame.origin.x = 320.f;
                
                VistaFiles.frame = theFrame;
                
                
            }];
            
            //-----------------------------------------------
            
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonPlaylist.frame;
                theFrame.origin.x = -110.f;
                
                buttonPlaylist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonAlbums.frame;
                theFrame.origin.x = 0.f;
                
                buttonAlbums.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonArtist.frame;
                theFrame.origin.x = 110.f;
                
                buttonArtist.frame = theFrame;
                
                
            }];
            [UIView animateWithDuration:.3f animations:^{
                CGRect theFrame = buttonFiles.frame;
                theFrame.origin.x = 220.f;
                
                buttonFiles.frame = theFrame;
                
                
            }];
            
            posScreen = 2;
            break;
    }
}
@end

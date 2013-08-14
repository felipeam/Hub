//
//  ServicesViewController.m
//  Hub
//
//  Created by Desarrollo on 22/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "ServicesViewController.h"
#import "AppDelegate.h"

@interface ServicesViewController ()

@end

@implementation ServicesViewController
@synthesize Spotifybtn;
@synthesize SoundCloudbtn;

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
    [self comprobarservicios];
        
	// Do any additional setup after loading the view.
}

-(void)comprobarservicios
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (![appDelegate.SpotifyUser isEqual:@""])
    {
        UIImage * buttonImage = [UIImage imageNamed:@"spotify_icon_selected.png"];
        [Spotifybtn setImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage * buttonImage = [UIImage imageNamed:@"spotify_icon_gray.png"];
        [Spotifybtn setImage:buttonImage forState:UIControlStateNormal];

    }
    
    if (![appDelegate.SoundCloudUser isEqual:@""])
    {
        UIImage * buttonImage = [UIImage imageNamed:@"soundcloud_icon_selected.png"];
        [SoundCloudbtn setImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        UIImage * buttonImage = [UIImage imageNamed:@"soundcloud_icon_gray.png"];
        [SoundCloudbtn setImage:buttonImage forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [Spotifybtn release];
    [SoundCloudbtn release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comprobarservicios];
}

@end

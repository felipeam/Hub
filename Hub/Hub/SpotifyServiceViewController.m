//
//  SpotifyServiceViewController.m
//  Hub
//
//  Created by Desarrollo on 22/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "SpotifyServiceViewController.h"
#import "AppDelegate.h"
#import "ServicesViewController.h"

@interface SpotifyServiceViewController ()

@end

@implementation SpotifyServiceViewController
@synthesize txtSpotifyLabel;
@synthesize txtSpotifyPass;
@synthesize btnVolver;


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
	// Do any additional setup after loading the view.
    self.txtSpotifyLabel.delegate = self;
    self.txtSpotifyPass.delegate = self;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (![appDelegate.SpotifyUser isEqual:@""])
    {
        txtSpotifyLabel.text = appDelegate.SpotifyUser;
        txtSpotifyPass.text = appDelegate.SpotifyPass;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [txtSpotifyLabel release];
    [txtSpotifyPass release];

    [btnVolver release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)OnLogin:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    appDelegate.SpotifyUser = txtSpotifyLabel.text;
    appDelegate.SpotifyPass = txtSpotifyPass.text;    
    
    [btnVolver sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}
@end

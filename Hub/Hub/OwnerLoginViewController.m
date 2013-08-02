//
//  OwnerLoginViewController.m
//  Hub
//
//  Created by Desarrollo on 21/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import "OwnerLoginViewController.h"
#import "AppDelegate.h"

@interface OwnerLoginViewController ()

@end

@implementation OwnerLoginViewController

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
    FBLoginView *loginview = [[FBLoginView alloc] init];
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
  //  [[[self sharedDirector] openGLView] addSubview:loginview];

}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
     //   [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
     //   [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                              //        appDelegate.session.accessTokenData.accessToken]];
    } else {
        // login-needed account UI is shown whenever the session is closed
     //   [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
     //   [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FacebookLogin:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"User ID: %@",user.id);
                 appDelegate.FBuserID = user.id;
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }];
        
    }
    else
    {
    
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            if (appDelegate.session.isOpen) {
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection,
                   NSDictionary<FBGraphUser> *user,
                   NSError *error) {
                     if (!error) {
                         NSLog(@"User ID: %@",user.id);
                         appDelegate.FBuserID = user.id;
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                 }];
            
            }
            [self updateView];
        }];
    }

}


@end

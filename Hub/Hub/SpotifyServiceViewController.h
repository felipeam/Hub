//
//  SpotifyServiceViewController.h
//  Hub
//
//  Created by Desarrollo on 22/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotifyServiceViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txtSpotifyLabel;
@property (retain, nonatomic) IBOutlet UITextField *txtSpotifyPass;
@property (retain, nonatomic) IBOutlet UIButton *btnVolver;

- (IBAction)OnLogin:(id)sender;
@end

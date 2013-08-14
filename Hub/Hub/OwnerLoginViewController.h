//
//  OwnerLoginViewController.h
//  Hub
//
//  Created by Desarrollo on 21/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface OwnerLoginViewController : UIViewController<FBLoginViewDelegate>

- (IBAction)FacebookLogin:(id)sender;

@end

//
//  AppDelegate.h
//  Hub
//
//  Created by Desarrollo on 21/07/13.
//  Copyright (c) 2013 Fon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSString *FBuserID;

@property (strong, nonatomic) NSString *SpotifyUser;
@property (strong, nonatomic) NSString *SpotifyPass;

@property (strong, nonatomic) NSString *SoundCloudUser;
@property (strong, nonatomic) NSString *SoundCloudPass;

@property (strong, nonatomic) NSString *DefaultHost;

@end

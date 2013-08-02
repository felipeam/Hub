//
//  mpdSearchingHubViewController.h
//  MPpleD
//
//  Created by Apple on 13-6-7.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mpdSearchingHubViewController : UIViewController {
    IBOutlet UIImageView*   m_imgActivity;
    IBOutlet UIActivityIndicatorView*   m_activityView;
    NSTimer*    m_timer;
    NSTimer*    reset_timer;
    int     m_nRotate;
}

- (void) startTimer;
- (void) endTimer;
- (void) onTimer;
//--------------------
- (void) connect;

@property (nonatomic, strong) NSMutableData *responseData;

@end

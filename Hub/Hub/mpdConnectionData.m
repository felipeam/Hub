//
//  mpdConnectionData.m
//  MPpleD
//
//  Created by Kyle Hershey on 2/16/13.
//  Copyright (c) 2013 Kyle Hershey. All rights reserved.
//

#import "mpdConnectionData.h"

@implementation mpdConnectionData

@synthesize host;
@synthesize port;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static mpdConnectionData *sharedmpdConnectionData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedmpdConnectionData = [[self alloc] init];
    });
    return sharedmpdConnectionData;
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"HOST ADDRESS %@", address);
    return address;
}

- (id)init {
    if (self = [super init]) {
        host = @"192.168.182.1";//[self getIPAddress];
        port = [[NSNumber alloc] initWithInt:6600];
    }
    host = @"192.168.182.1";//[self getIPAddress];
    port = [[NSNumber alloc] initWithInt:6600];
    
     UIApplication *myApp = [UIApplication sharedApplication];
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:myApp];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
     if ([fileManager fileExistsAtPath:filePath] == YES)
     {
         NSMutableArray *data = [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]];

     }
    
    
    return self;
}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    mpdConnectionData *globalConnection = [mpdConnectionData sharedManager];
    //NSLog(@"here");
    NSArray *data = [[NSArray alloc] initWithObjects:globalConnection.host, globalConnection.port, nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullFileName = [NSString stringWithFormat:@"%@/data.plist", docDir];
    [NSKeyedArchiver archiveRootObject:data toFile:fullFileName];

    
    
}


@end



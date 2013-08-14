//
//  mpdSearchingHubViewController.m
//  MPpleD
//
//  Created by Apple on 13-6-7.
//  Copyright (c) 2013年 Kyle Hershey. All rights reserved.
//

#import "mpdSearchingHubViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface mpdSearchingHubViewController ()

@end

#define degreesToRadian(a) (M_PI*a/180.0)

@implementation mpdSearchingHubViewController
@synthesize responseData;

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
    self.responseData = [NSMutableData data];
    
	// Do any additional setup after loading the view.
    // --------------------
    // - Conectamos -------
    // --------------------
   // [self connect];
    //---------------------
    
        
    
    [self startTimer];
    [m_activityView startAnimating];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}
- (void) endTimer {
    if (m_timer)
        [m_timer invalidate];
    m_timer = nil;
    if (reset_timer)
        [reset_timer invalidate];
    reset_timer = nil;
}
- (void) onTimer {
//    m_nRotate += 5;
//    m_imgActivity.transform = CGAffineTransformMakeRotation(degreesToRadian(m_nRotate));
 //   [self performSegueWithIdentifier:@"searhing_push" sender:nil];
    
    // --------------------
    // - Conectamos -------
    // --------------------

    [self connect];
        
}

- (void) connect{
   
    
  
   // NSString *post = [NSString stringWithFormat:@"{\"owner\": {\"mac\": \"B8-27-EB-8D-41-C8\"}, \"sources\": {\"spotify\": {\"username\": \"\", \"password\": \"\", \"enabled\": false}, \"soundcloud\": {\"username\": \"\", \"auth_token\": \"\", \"password\": \"\", \"enabled\": false}}}"];
    
   /* NSString *jsonRequest = @"{\"owner\": {\"mac\": \"B8-27-EB-8D-41-C8\"}, \"sources\": {\"spotify\": {\"username\": \"labs@fon.com\", \"password\": \"fonfonfon\", \"enabled\": true}, \"soundcloud\": {\"username\": \"\", \"auth_token\": \"\", \"password\": \"\", \"enabled\": false}}}";
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://192.168.182.1:8080/ws/source/"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
    
   // [NSURLConnection connectionWithRequest:request delegate:self];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    if (connection) {
        NSLog(@"POST: %@", jsonRequest);
    }
    else {
    NSLog(@"POST: %@", jsonRequest);
    }
    */
    
   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    /*
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (POSTReply!=nil)
    {*/
     //   NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
     //   NSLog(@"Reply: %@", theReply);
    
    
        NSString *urlString = [NSString stringWithFormat:@"http://192.168.182.1:8080/ws/status/"];
    
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
        NSError *error;
   
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
        if([[json valueForKey:@"hub_is_up"] boolValue])
        {
            if([[json valueForKey:@"has_services"] boolValue])
            {
                NSArray *ads = [json valueForKey:@"owner"];
                NSLog(@"%@",[[ads valueForKey:@"enabled"]objectAtIndex:0]);
                
                Boolean Logeado = true;
                
                if([[[ads valueForKey:@"enabled"]objectAtIndex:0] intValue] == 0 )
                {
                    if([[[ads valueForKey:@"enabled"]objectAtIndex:1] intValue]  == 0 )
                    {
                        
                        Logeado = false;
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OwnerLogin"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                }
                
                if(Logeado)
                {
                    NSString *urlString = [NSString stringWithFormat:@"http://192.168.182.1:8080/ws/source/"];
                    
                    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                    
                    NSError *error;
                    
                    NSDictionary *jsonSource = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    NSArray *adsources = [jsonSource valueForKey:@"sources"];
                    
                    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                    
                    appDelegate.SpotifyUser = @"";
                    appDelegate.SpotifyPass = @"";
                    
                    appDelegate.SoundCloudUser = @"";
                    appDelegate.SoundCloudPass = @"";
                    
                    
                    
                    if([[[adsources valueForKey:@"spotify"] valueForKey:@"enabled"] boolValue] == false )
                    {
                      //  if([[[adsources valueForKey:@"soundcloud"] valueForKey:@"enabled"] boolValue]  == false )
                      //  {
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginServices"];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                      //  }
                      //  else
                      //  {
                      //      appDelegate.SoundCloudUser = [[adsources valueForKey:@"soundcloud"] valueForKey:@"username"];
                      //      appDelegate.SoundCloudPass = [[adsources valueForKey:@"soundcloud"] valueForKey:@"password"];
                      //  }
                    }
                    else
                    {
                        appDelegate.SpotifyUser = [[adsources valueForKey:@"spotify"] valueForKey:@"username"];
                        appDelegate.SpotifyPass = [[adsources valueForKey:@"spotify"] valueForKey:@"password"];
                        if([[[adsources valueForKey:@"enabled"]objectAtIndex:1] boolValue]  == true )
                        {
                            appDelegate.SoundCloudUser = [[adsources valueForKey:@"soundcloud"] valueForKey:@"username"];
                            appDelegate.SoundCloudPass = [[adsources valueForKey:@"soundcloud"] valueForKey:@"password"];
                        }
                        
                        [self endTimer];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NowPlaying"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                
            }
            else
            {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"El HUB no tiene los servicios activados"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [errorAlert show];
            
            }
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"El HUB no esta activado"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [errorAlert show];
        }
        NSLog(@"%@",json);
  /*  }
    else
    {
        printf("POST Fallido");
    }*/
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    printf("Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    printf("connectionDidFinishLoading");
    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"\nkey: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        printf("icon: %@", icon);
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (![appDelegate.FBuserID isEqual:@""]) {
                
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"owner\": [{\"enabled\": true, \"name\": \"facebook\", \"id\": \"%@\"}, {\"enabled\": false, \"name\": \"google\", \"id\": \"0\"}], \"hub_is_up\": true, \"has_services\": true}",appDelegate.FBuserID];
        
        NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://192.168.182.1:8080/ws/status/"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
        
        // [NSURLConnection connectionWithRequest:request delegate:self];
        NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self];
        appDelegate.FBuserID = @"";
        [self connect];
        
                
    }else if (![appDelegate.SpotifyUser isEqual:@""]) {
        
        if (![appDelegate.SoundCloudUser isEqual:@""])
        {
            NSString *jsonRequest = [NSString stringWithFormat:@"{\"owner\": {\"mac\": \"B8-27-EB-8D-41-C8\"}, \"sources\": {\"spotify\": {\"username\": \"%@\", \"password\": \"%@\", \"enabled\": true}, \"soundcloud\": {\"username\": \"%@\", \"auth_token\": \"%@\", \"password\": \"%@\", \"enabled\": true}}}",appDelegate.SpotifyUser,appDelegate.SpotifyPass,appDelegate.SoundCloudUser,@"1-41730-45838116-d607fce7c43b4c0",appDelegate.SoundCloudPass];
            NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://192.168.182.1:8080/ws/source/"]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:requestData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
            
            // [NSURLConnection connectionWithRequest:request delegate:self];
            NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                         delegate:self];
          /*
            if (connection) {
                NSLog(@"POST: %@", jsonRequest);
            }
            else {
                NSLog(@"POST: %@", jsonRequest);
            }
           */
            reset_timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onResetTimer) userInfo:nil repeats:NO];
        }
        else{
            NSString *jsonRequest = [NSString stringWithFormat:@"{\"owner\": {\"mac\": \"B8-27-EB-8D-41-C8\"}, \"sources\": {\"spotify\": {\"username\": \"%@\", \"password\": \"%@\", \"enabled\": true}, \"soundcloud\": {\"username\": \"\", \"auth_token\": \"\", \"password\": \"\", \"enabled\": false}}}",appDelegate.SpotifyUser,appDelegate.SpotifyPass];
            NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://192.168.182.1:8080/ws/source/"]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:requestData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
            
            // [NSURLConnection connectionWithRequest:request delegate:self];
            NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                         delegate:self];
            
            
            reset_timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onResetTimer) userInfo:nil repeats:NO];
        }
            
        
    }else if (![appDelegate.SoundCloudUser isEqual:@""]) {
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"owner\": {\"mac\": \"B8-27-EB-8D-41-C8\"}, \"sources\": {\"spotify\": {\"username\": \"\", \"password\": \"\", \"enabled\": true}, \"soundcloud\": {\"username\": \"%@\", \"auth_token\": \"%@\", \"password\": \"%@\", \"enabled\": false}}}",appDelegate.SoundCloudUser,@"1-41730-45838116-d607fce7c43b4c0",appDelegate.SoundCloudPass];
        NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://192.168.182.1:8080/ws/source/"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d",[requestData length]] forHTTPHeaderField:@"Content-Length"];
        
        // [NSURLConnection connectionWithRequest:request delegate:self];
        NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self];
        
        reset_timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(onResetTimer) userInfo:nil repeats:NO];;

    }
    
}

- (void) onResetTimer {
    [self connect];
}

@end

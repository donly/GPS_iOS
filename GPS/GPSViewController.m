//
//  GPSViewController.m
//  GPS
//
//  Created by Donly Chan on 12-5-22.
//  Copyright (c) 2012年 MAGICALBOY. All rights reserved.
//

#import "GPSViewController.h"

@interface GPSViewController ()

@end

@implementation GPSViewController

@synthesize latitudeLabel;
@synthesize longitudeLabel;


- (void)dealloc {
    [locationManager release];
    
    self.latitudeLabel = nil;
    self.longitudeLabel = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom methods

- (IBAction)openGPS:(id)sender {
    // Create a location manager instance to determine if location services are enabled. This manager instance will be
    // immediately released afterwards.
    if (![CLLocationManager locationServicesEnabled]) {
        [self showOpenLocationServiceAlertView];
    }
    else {
        if (locationManager == nil) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // more accurate, the more power
        }
        
        [locationManager startUpdatingLocation];
        
        // Once configured, the location manager must be "started"
        //
        // for iOS 8, specific user level permission is required,
        // "when-in-use" authorization grants access to the user's location
        //
        // important: be sure to include NSLocationWhenInUseUsageDescription along with its
        // explanation string in your Info.plist or startUpdatingLocation will not work.
        //
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [self showOpenLocationServiceAlertView];
        }

    }
}

- (void)showOpenLocationServiceAlertView {
    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                    message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:@"Setting", nil];
    [servicesDisabledAlert show];
    [servicesDisabledAlert release];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
        case kCLErrorLocationUnknown:
            NSLog(@"The location manager was unable to obtain a location value right now.");
            break;
        case kCLErrorDenied:
            NSLog(@"Access to the location service was denied by the user.");
            break;
        case kCLErrorNetwork:
            NSLog(@"The network was unavailable or a network error occurred.");
            break;
        default:
            NSLog(@"undefine");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"oldLocation.coordinate.timestamp:%@", oldLocation.timestamp);
    NSLog(@"oldLocation.coordinate.longitude:%f", oldLocation.coordinate.longitude);
    NSLog(@"oldLocation.coordinate.latitude:%f", oldLocation.coordinate.latitude);
    
    NSLog(@"newLocation.coordinate.timestamp:%@", newLocation.timestamp);
    NSLog(@"newLocation.coordinate.longitude:%f", newLocation.coordinate.longitude);
    NSLog(@"newLocation.coordinate.latitude:%f", newLocation.coordinate.latitude);
    
    NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    NSLog(@"%lf", interval);
    
    if (interval < 3) {
        [locationManager stopUpdatingLocation];
    }
    
    latitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    longitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self openSettings];
    }
}

- (void)openSettings
{
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end

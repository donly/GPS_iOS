//
//  GPSViewController.h
//  GPS
//
//  Created by Donly Chan on 12-5-22.
//  Copyright (c) 2012年 MAGICALBOY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
}

- (IBAction)openGPS:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *longitudeLabel;

@end

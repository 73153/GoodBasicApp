//
//  LocationViewController.h
//  peter
//
//  Created by Peter on 12/25/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"
#import <CoreLocation/CoreLocation.h>


@interface LocationViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (nonatomic,strong) IBOutlet UITextField *txtPinCode;

- (IBAction)btnContinuePressed:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;

@end


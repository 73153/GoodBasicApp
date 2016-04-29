//
//  LocationViewController.m
//  peter
//
//  Created by Peter on 12/25/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import "LocationViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"
#import "DEMOLeftMenuViewController.h"
#import "DashboardViewController.h"
#import "DEMORightMenuViewController.h"
#import "UIView+Toast.h"
#import "Constant.h"
#import "Users.h"


@interface LocationViewController ()<RESideMenuDelegate,UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    Globals *OBJGlobal,*objPinCode;
    __block NSString *strPincode;
    
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        locationManager = [[CLLocationManager alloc] init];
        self.txtPinCode.delegate=self;
        [OBJGlobal setTextFieldWithSpace:self.txtPinCode];
        
        [OBJGlobal setTextFieldWithSpace: self.txtPinCode];
        
        //TextField Spacing Code
        UIView *paddingTxtfieldView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 42)]; // what ever you want
        self.txtPinCode.leftView = paddingTxtfieldView1;
        self.txtPinCode.leftViewMode = UITextFieldViewModeAlways;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)setUpContentData
{
    @try{
        UINib * mainView = [UINib nibWithNibName:@"CommonPopUpView" bundle:nil];
        OBJGlobal.objMainPopUp = (CommonPopUpView *)[mainView instantiateWithOwner:self options:nil][0];
        if(IS_IPHONE_6_PLUS)
        {
            OBJGlobal.objMainPopUp.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20);
        }else
            OBJGlobal.objMainPopUp.frame=CGRectMake(0, 5, self.view.frame.size.width, OBJGlobal.objMainPopUp.frame.size.height+60);
        [self.view addSubview:OBJGlobal.objMainPopUp];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        objPinCode= [Globals sharedManager];
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Location";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        NSString *strLocation =  GETOBJECT(@"Location");
        if(strLocation.length>0){
            _txtPinCode.text = strLocation;
            [self navigationForDashboard];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)zipCodeAvailabilityMethod
{
    @try{
        [APPDATA showLoader];
        Users *objzipCode=[[Users alloc]init];
        objzipCode.zipCode = [_txtPinCode.text mutableCopy];
        [objzipCode zipCodeAvailability:^(NSDictionary *user, NSString *str, int status)
         {
             
             if (status == 1) {
                 
                 [APPDATA hideLoader];
                 //                 [self.view makeToast:[user valueForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 SETOBJECT(_txtPinCode.text, @"Location");
                 SYNCHRONIZE;
                 [self navigationForDashboard];
                 
                 NSLog(@"success");
             }
             else {
                 if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                     [self.view makeToast:[user valueForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
-(void)navigationForDashboard
{
    @try{
        
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DashboardViewController *second=(DashboardViewController *)[storybord  instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        
        /* it holds our main slidingVC viewController */
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:second];
        
        /* it holds LeftViewController */
        DEMOLeftMenuViewController *leftMenuViewController = [[DEMOLeftMenuViewController alloc] init];
        
        DEMORightMenuViewController *rigtMenuViewController = [[DEMORightMenuViewController alloc] init];
        
        /*it Manage Both ViewCOntroller [slidingVC & LeftViewController] */
        
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController rightMenuViewController:rigtMenuViewController];
        
        sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
        
        sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowOpacity =0;
        
        /* REsideMenu become RootViewCOntroller and manage both VC */
        
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appdel.window.rootViewController = sideMenuViewController;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
//put one space before text
- (IBAction)btnContinuePressed:(id)sender {
    @try{
        [self.view endEditing:true];
        objPinCode.pin=_txtPinCode.text;
        if(_txtPinCode.text.length==0)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:@"Please enter your location PIN or tap on location button to get current loaction PIN."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        else
            [self zipCodeAvailabilityMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
- (void)requestWhenInUseAuthorization
{
    @try{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Settings", nil];
            [alertView show];
        }
        else if (status == kCLAuthorizationStatusNotDetermined) {
            [locationManager requestWhenInUseAuthorization];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [self requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGPoint point = textField.frame.origin;
//    //    NSLog(@"super view frame %@", NSStringFromCGPoint(point));
//    CGFloat height = SCREEN_HEIGHT;
//    CGFloat space = (height - point.y - 100) - 250;
//    if (space < 0) {
//        CGRect rect = self.view.frame;
//        rect.origin.y += space;
//        self.view.frame = rect;
//    }
//
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGRect rect = self.view.frame;
//    rect.origin = CGPointZero;
//    self.view.frame = rect;
//
//}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    @try{
        NSLog(@"didUpdateToLocation: %@", newLocation);
        CLLocation *currentLocation = newLocation;
        
        NSString *strLatLong = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        [self getAddressFromLatLong:strLatLong];
        if (currentLocation != nil) {
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)getAddressFromLatLong : (NSString *)latLng {
    @try{
        NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //http://maps.googleapis.com/maps/api/geocode/json?sensor=false&latlng=23.0391789,72.5053698&language=english
        //http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@
        //NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=false&latlng=%@&language=english", esc_addr];
        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=false&latlng=%@", esc_addr];
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        if (result == nil) {
            
            [locationManager stopUpdatingLocation];
            return;
        }
        NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
        if ([dataArray count]) {
            //appData.LocationAddress = [[dataArray valueForKey:@"formatted_address"] firstObject];
            NSArray *arrAddcomp = [[dataArray valueForKey:@"address_components"] objectAtIndex:1];
            [arrAddcomp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                NSLog(@"The object at index %lu is %@",(unsigned long)idx,obj);
                
                NSArray *arr = [obj valueForKey:@"types"];
                [arr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop){
                    NSLog(@"The object at index %lu is %@",(unsigned long)idx,obj);
                    if ([obj1 isEqualToString: @"postal_code"])
                        strPincode = [obj valueForKey:@"long_name"];
                    
                }];
            }];
        }
        NSLog( @"Pincode %@",strPincode);
        _txtPinCode.text = strPincode;
        objPinCode.pin=_txtPinCode.text;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end

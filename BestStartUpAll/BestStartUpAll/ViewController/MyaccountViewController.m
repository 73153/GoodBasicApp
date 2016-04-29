//
//  MyaccountViewController.m
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "MyaccountViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "APICall.h"
#import "DashboardViewController.h"
#import "UIView+Toast.h"
#import "Users.h"
#import "LoginViewController.h"
#import "MyOrdesViewController.h"
#import "DelivaryAddressViewController.h"
#import "ProfileEditViewController.h"


@interface MyaccountViewController ()
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    NSDictionary *dicProfileData;
    NSString *strFname;
    NSString *strLaname;
    NSMutableArray *aryOrderHistory;
    NSMutableArray *aryAccountData;
}

@end

@implementation MyaccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @try{
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        //  btnBadgeCount =[self setUpImageSecondRightButton:@"menu" secondImage:@"cart" thirdImage:@"search" badgeCount:[[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] integerValue]];
        
        //[self setUpImageProfileEditButton:@"logout"];
        if(GETBOOL(@"isUserHasLogin")==false){
            [self.view makeToast:@"Login first"];
            return;
            LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:objLoginViewController animated:NO];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setnavigationImage:(NSString *)strImageName
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"My Account";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        if(GETBOOL(@"isUserHasLogin")==true){
            [self myProfileMethod];
        }
        else{
            [self.view makeToast:@"Please login to view my account details"];
            return;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)myProfileMethod
{
    @try{
        [APPDATA showLoader];
        Users *objMyProfile = OBJGlobal.user;
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] )
        {
            
            objMyProfile.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        [objMyProfile MyProfile:^(NSDictionary *user, NSString *str, int status)
         {
             [self deliveryAddressmethod];
             
             if (status == 1) {
                 
                 dicProfileData=[[NSDictionary alloc]init];
                 dicProfileData =[user objectForKey:@"data"];
                 if([OBJGlobal isNotNull:[dicProfileData valueForKey:@"email"]])
                     _lblEmail.text=[dicProfileData valueForKey:@"email"];
                 
                 _lblNumber.text=[dicProfileData valueForKey:@""];
                 if([OBJGlobal isNotNull:[dicProfileData valueForKey:@"firstname"]])
                     
                     strFname=[dicProfileData valueForKey:@"firstname"];
                 if([OBJGlobal isNotNull:[dicProfileData valueForKey:@"lastname"]])
                     
                     strLaname=[dicProfileData valueForKey:@"lastname"];
                 strFname=[strFname stringByAppendingString:@" "];
                 strFname=[strFname stringByAppendingString:strLaname];
                 
                 _lblName.text=strFname;
                 
                 _lblLastAccount.numberOfLines=0;
                 _lblLastAccount.lineBreakMode=NSLineBreakByWordWrapping;
                 _lblLastAccount.text=[NSString stringWithFormat:@"%@ \n%@",strFname,_lblEmail.text];
                 
                 NSLog(@"success");
                 [APPDATA hideLoader];
             }
             else {
                 //[self.view makeToast:[user objectForKey:@"msg"]];
                 NSLog(@"Failed");
                 [self myProfileMethod];
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)deliveryAddressmethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            Users *objMyProfile = OBJGlobal.user;
            
            // [APPDATA showLoader];
            [objMyProfile addressList:^(NSDictionary *user, NSString *str, int status)
             {
                 // [APPDATA hideLoader];
                 
                 [self orderHistoryMethod];
                 
                 if (status == 1) {
                     
                     if([OBJGlobal isNotNull:[user objectForKey:@"data"]]){
                         OBJGlobal.aryDeliveryList =[[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                         OBJGlobal.isFirstTimeFetchKartData=false;
                         NSDictionary *dictLastAddress = [OBJGlobal.aryDeliveryList lastObject];
                         NSString *strCity=@"";
                         NSString *strState=@"";
                         NSString *strZip=@"";
                         if([OBJGlobal isNotNull:[dictLastAddress valueForKey:@"city"]])
                             strCity = [dictLastAddress valueForKey:@"city"];
                         if([OBJGlobal isNotNull:[dictLastAddress valueForKey:@"region"]])
                             strState = [dictLastAddress valueForKey:@"region"];
                         if([OBJGlobal isNotNull:[dictLastAddress valueForKey:@"postcode"]])
                             strZip = [dictLastAddress valueForKey:@"postcode"];
                         
                         NSString *strLastAddress = [NSString stringWithFormat:@"%@ %@ %@", strCity,strState,strZip];
                         
                         _lblLastAddress.numberOfLines=0;
                         _lblLastAddress.lineBreakMode=NSLineBreakByWordWrapping;
                         _lblLastAddress.text = strLastAddress;
                     }
                     
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                         //                           [self.view makeToast:[user objectForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]duration:1.0f position:CSToastPositionCenter];
                     NSLog(@"Failed");
                     // [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please login to view all address"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)orderHistoryMethod
{
    @try{
        
        if(GETBOOL(@"isUserHasLogin")==true){
            
            Users *objorderHistory = OBJGlobal.user;
            
            // [APPDATA showLoader];
            [objorderHistory orderHistory:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                     
                     if([OBJGlobal isNotNull:[user objectForKey:@"data"]]){
                         aryOrderHistory =[[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                         
                         NSDictionary *dictLastAddress = [aryOrderHistory firstObject];
                         NSString *strorderName=@"";
                         NSString *strorderDate=@"";
                         
                         if([OBJGlobal isNotNull:[dictLastAddress valueForKey:@"order_name"]])
                             strorderName = [dictLastAddress valueForKey:@"order_name"];
                         
                         //Date Format Start
                         if([OBJGlobal isNotNull:[dictLastAddress valueForKey:@"order_date"]])
                             strorderDate = [dictLastAddress valueForKey:@"order_date"];
                         
                         
                         NSArray *substrings = [strorderDate componentsSeparatedByString:@" "];
                         NSString *strDate = [substrings objectAtIndex:0];
                         NSString *strTime = [substrings objectAtIndex:1];
                         
                         //Date Formatter
                         NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                         [dateFormat setDateFormat:@"yyyy-MM-dd"];
                         NSDate *date = [dateFormat dateFromString:strDate];
                         [dateFormat setDateFormat:@"MMMM dd, YYYY"];
                         strDate = [dateFormat stringFromDate:date];
                         
                         //Time Formatter
                         NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
                         [timeFormat setDateFormat:@"HH:mm:ss"];
                         NSDate *time = [timeFormat dateFromString:strTime];
                         
                         // Convert date object to desired output format
                         [timeFormat setDateFormat:@"hh:mm a"];
                         strTime = [timeFormat stringFromDate:time];
                         
                         
                         NSString *strFinalDateTime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                         
                         //End
                         
                         NSString *strLastAddress = [NSString stringWithFormat:@"%@ %@", strorderName,strFinalDateTime];
                         
                         _lblLastOrder.numberOfLines=0;
                         _lblLastOrder.lineBreakMode=NSLineBreakByWordWrapping;                      _lblLastOrder.text = strLastAddress;
                     }
                     
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
                     NSLog(@"Failed");
                     // [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please login to view all orders"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



- (IBAction)btnViewAllOrdersPressed:(id)sender
{
    @try{
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MyOrdesViewController *objMessageVC=(MyOrdesViewController *)[storybord  instantiateViewControllerWithIdentifier:@"MyOrdesViewController"];
        
        
        [self.navigationController pushViewController:objMessageVC animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (IBAction)btnViewAllAddressPressed:(id)sender {
    @try{
        DelivaryAddressViewController *objDelivaryAddressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DelivaryAddressViewController"];
        objDelivaryAddressViewController.strmyaccountAddress=@"My Account Address";
        [self.navigationController pushViewController:objDelivaryAddressViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
- (IBAction)btnEditAddressPressed:(id)sender
{
    @try{
        ProfileEditViewController *objProfileEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditViewController"];
        objProfileEditViewController.strLastAddressList1=_lblLastAddress.text;
        objProfileEditViewController.strLastorder1=_lblLastOrder.text;
        objProfileEditViewController.strLastAccount1=_lblLastAccount.text;
        objProfileEditViewController.strFirstName=[dicProfileData valueForKey:@"firstname"];
        objProfileEditViewController.strLastName=[dicProfileData valueForKey:@"lastname"];
        objProfileEditViewController.strEmailID=[dicProfileData valueForKey:@"email"];
        objProfileEditViewController.strHashPassword = [dicProfileData valueForKey:@"password"];
        [self.navigationController pushViewController:objProfileEditViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end

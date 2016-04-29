//
//  RegisterViewController.m
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"
#import "LoginViewController.h"
//#import "ToastView.h"
#import "FMDBDataAccess.h"
#import "DashboardViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dbAccess;
    
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        dbAccess = [FMDBDataAccess new];
        
        self.txtFirstName.delegate=self;
        self.txtLastName.delegate=self;
        self.txtConfirmPassword.delegate=self;
        self.txtEmailid.delegate=self;
        self.txtPassword.delegate=self;
        
        
        [OBJGlobal setTextFieldWithSpace:self.txtFirstName];
        [OBJGlobal setTextFieldWithSpace:self.txtLastName];
        [OBJGlobal setTextFieldWithSpace:self.txtConfirmPassword];
        [OBJGlobal setTextFieldWithSpace:self.txtEmailid];
        [OBJGlobal setTextFieldWithSpace:self.txtPassword];
        [self setUpImageBackButton:@"left-arrow"];
        dicRegisterData=[[NSMutableDictionary alloc]init];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    //   btnBadgeCount = [self setUpImageSecondRightButton:@"menu" secondImage:@"search" thirdImage:@"logo" badgeCount:[[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        // label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Register";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        //self.navigationItem.title = @"Register";
        //        REGISTER
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    @try{
        if(textField==self.txtFirstName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtFirstName];
        }
        else if (textField==self.txtLastName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtFirstName];
        }
        else if (textField==self.txtEmailid)
        {
            [OBJGlobal makeTextFieldNormal:self.txtLastName];
        }
        else if (textField==self.txtPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtEmailid];
        }
        else if (textField==self.txtConfirmPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtPassword];
        }
        if (textField==self.txtConfirmPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtConfirmPassword];
        }
        //            return NO;
        //        else
        return YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnSubmitPressed:(id)sender {
    @try{
        [self.view endEditing:TRUE];
        BOOL isValid=true;
        if (![Validations checkMinLength:self.txtFirstName.text withLimit:2 ]) {
            isValid=false;
            
            [OBJGlobal makeTextFieldBorderRed:self.txtFirstName];
            [self.view makeToast:ERROR_FNAME];
            return;
        }
        else if (![Validations checkMinLength:self.txtLastName.text withLimit:2]) {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtLastName];
            [self.view makeToast:ERROR_LNAME];
            return;
            
        }
        else if(![APPDATA validateEmail:self.txtEmailid.text])
        {
            [OBJGlobal makeTextFieldBorderRed:self.txtEmailid];
            isValid=false;
            [self.view makeToast:ERROR_EMAIL];
            return;
            
        }
        else if(![Validations checkMinLength:self.txtPassword.text withLimit:6 ])
        {
            [OBJGlobal makeTextFieldBorderRed:self.txtPassword];
            isValid=false;
            [self.view makeToast:ERROR_PASSWORD];
            return;
            
        }
        else if(![Validations checkMinLength:self.txtConfirmPassword.text withLimit:6 ])
        {
            [OBJGlobal makeTextFieldBorderRed:self.txtConfirmPassword];
            isValid=false;
            [self.view makeToast:ERROR_CONFIRMPASSWORD];
            return;
            
        }
        
        if (isValid == TRUE){
            
            [APPDATA showLoader];
            
            Users *objRegister = OBJGlobal.user;
            objRegister.Email=[_txtEmailid.text mutableCopy];
            objRegister.firstname=[_txtFirstName.text mutableCopy];
            objRegister.lastname=[_txtLastName.text mutableCopy];
            objRegister.password=[_txtPassword.text mutableCopy];
            
            [objRegister registerUser:^(NSDictionary *user, NSString *str, int status) {
                
                if (status == 1) {
                    
                    // APPDATA.user.msg=[user objectForKey:@"msg"];
                    
                    //  dicRegisterData =[user objectForKey:@"userdetails"];
                    //                [self.view makeToast:[NSString stringWithFormat:@"%@",APPDATA.user.msg]];
                    //    [self.view makeToast:@"login successfully"];
                    //  sleep(3);
                    
                    [APPDATA showLoader];
                    SETOBJECT(objRegister.Email, @"emailid");
                    SETOBJECT(objRegister.password, @"Password");
                    SETBOOL(true, @"isUserHasLogin");
                    [APPDATA hideLoader];
                    
                    objRegister.userid = [[NSString stringWithFormat:@"%@",[user valueForKey:@"userid"]] mutableCopy] ;
                    
                    SETOBJECT(objRegister.Email, @"EmailID");
                    SYNCHRONIZE;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSString stringWithFormat:@"%@",objRegister.userid] mutableCopy] forKey:@"userid"];
                    
                    OBJGlobal.isFirstTimeFetchKartData=false;
                    
                    [APPDATA showLoader];
                    
                    [self pushLocalkartDataOnline];
                    OBJGlobal.isFirstTimeFetchKartData=false;
                    OBJGlobal.dictLastKartProduct=nil;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                        [self changeTheCountForBadgeOnLogin];
                    });
                    
                    OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
                    OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
                    
                    //  [self.view makeToast:@"You have login successful"];
                    
                    APPDATA.user.msg=[user objectForKey:@"msg"];
                    
                    SYNCHRONIZE;
                    NSLog(@"success");
                }
                else {
                    [self.view makeToast:@"Email and Password Invalid"];
                    NSLog(@"Failed");
                    [APPDATA hideLoader];
                }
            }];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)pushLocalkartDataOnline{
    @try{
        //[APPDATA showLoader];
        NSArray *aryLocalkartData = [OBJGlobal.aryKartDataGlobal mutableCopy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            
            [aryLocalkartData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Users *objUsers = OBJGlobal.user;
                
                if ([[obj allKeys] containsObject:@"id"])
                    objUsers.prodid = [obj valueForKey:@"id"];
                else if([[obj allKeys] containsObject:@"prod_id"])
                    objUsers.prodid = [obj valueForKey:@"prod_id"];
                
                objUsers.sku =[[NSString stringWithFormat:@"%@",[obj valueForKey:@"sku"]] mutableCopy];
                objUsers.qty=[[NSString stringWithFormat:@"%@",[obj valueForKey:@"qty"]] mutableCopy];
                if(!OBJGlobal)
                    OBJGlobal = [Globals sharedManager];
                
                objUsers.flag = [OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:OBJGlobal.dictLastKartProduct];
                
                if([obj valueForKey:@"prod_in_cart"])
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                        objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                        [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                         {
                             if (status == 1) {
                                 NSLog(@"success count: added local data");
                                 NSLog(@"success added to kart");
                                 
                                 OBJGlobal.dictLastKartProduct = obj;
                                 
                                 static int j = 0;
                                 NSLog(@"success count:%d",j);
                                 j++;
                                 
                                 return ;
                                 
                                 
                             }
                             else {
                                 // [self.view makeToast:[user objectForKey:@"msg"]];
                                 NSLog(@"Failed");
                                 //  [APPDATA hideLoader];
                             }
                         }];
                    }
                
            }];
        });
        
        [self performSelector:@selector(popCurrentController) withObject:nil afterDelay:2];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)popCurrentController
{
    @try{
        if(!dbAccess)
            dbAccess = [FMDBDataAccess new];
        [dbAccess deleteAllProductData];
        OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
        
        OBJGlobal.isUserHasGotLogin=true;
        DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)changeTheCountForBadgeOnLogin
{
    @try{
        Users *objmyCart = OBJGlobal.user;
        
        [objmyCart myCartList:^(NSDictionary *result, NSString *str, int status)
         {
             if (status == 1) {
                 OBJGlobal.isFirstTimeFetchKartData=true;
                 
                 if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                     
                     OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                     OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                     [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                 }
                 else{
                     //                     [self.view makeToast:@"Please Login to view cart data or you have not added product to cart" duration:5.0f position:CSToastPositionBottom title:@"Alert"];
                     
                 }
                 
                 NSLog(@"success");
             }
             else {
                 NSLog(@"Failed");
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)moveToDashBoard
{
    [APPDATA hideLoader];
    
}
@end

//
//  LoginViewController.m
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "APICall.h"
#import "DashboardViewController.h"
#import "UIView+Toast.h"
#import "Users.h"
#import "RegisterViewController.h"
#import "UIView+Toast.h"
#import "FMDBDataAccess.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    NSArray *aryforgotpass;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dbAccess;
    NSTimer *timer;
}
@end

@implementation LoginViewController
@synthesize viewforgotPass;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        dbAccess = [FMDBDataAccess new];
        OBJGlobal = [Globals sharedManager];
        [OBJGlobal setTextFieldWithSpace:self.txtEmail];
        [OBJGlobal setTextFieldWithSpace:self.txtPassword];
        [OBJGlobal setTextFieldWithSpace:self.txtForEmail];
        self.txtEmail.delegate=self;
        self.txtPassword.delegate=self;
        
        [self setUpImageBackButton:@"left-arrow"];
        dicLoginDetails=[[NSMutableDictionary alloc]init];
        aryforgotpass=[[NSArray alloc]init];
        [self.viewforgotPass setHidden:YES];
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
                     OBJGlobal.aryKartDataGlobal=nil;
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

-(void)setnavigationImage:(NSString *)strImageName
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        label.text = @"Login";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        OBJGlobal.aryKartDataGlobal =  [[NSMutableArray alloc] initWithArray:[[dbAccess fetchAllProductDataFromLocalDB] mutableCopy]];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(IBAction)btnLoginPressed:(id)sender {
    @try{
        [self.view endEditing:true];
        
        BOOL isValid=true;
        
        if(![APPDATA validateEmail:self.txtEmail.text])
        {
            _btnFogotPassword.hidden = NO;
            
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtEmail];
            [APPDATA hideLoader];
            [self.view makeToast:ERROR_EMAIL];
            return;
        }
        else if(![Validations checkMinLength:self.txtPassword.text withLimit:6])
        {
            _btnFogotPassword.hidden = NO;
            isValid=false;
            [APPDATA hideLoader];
            [OBJGlobal makeTextFieldBorderRed:self.txtPassword];
            [self.view makeToast:ERROR_PASSWORD];
            return;
        }
        
        if (isValid == TRUE) {
            [APPDATA showLoader];
            Users *objLogin=[[Users alloc]init];
            objLogin.Email = [self.txtEmail.text mutableCopy];
            objLogin.password = [self.txtPassword.text mutableCopy];
            [objLogin loginUser:^(NSDictionary *user,NSString *str, int status) {
                
                if (status == 1) {
                    SETOBJECT(self.txtEmail.text, @"emailid");
                    SETOBJECT(self.txtPassword.text, @"Password");
                    SETBOOL(true, @"isUserHasLogin");
                    [APPDATA hideLoader];
                    
                    
                    dicLoginDetails =[user objectForKey:@"userdetails"];
                    objLogin.userid = [[NSString stringWithFormat:@"%@",[dicLoginDetails valueForKey:@"userid"]] mutableCopy] ;
                    
                    SETOBJECT([dicLoginDetails valueForKey:@"email"], @"EmailID");
                    SYNCHRONIZE;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSString stringWithFormat:@"%@",objLogin.userid] mutableCopy] forKey:@"userid"];
                    
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
                    
                    //                [self.view makeToast:[NSString stringWithFormat:@"%@",APPDATA.user.msg]];
                    //    [self.view makeToast:@"login successfully"];
                    //  sleep(3);
                    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    @try{
        
        if(textField==self.txtEmail)
        {
            [OBJGlobal makeTextFieldNormal:self.txtEmail];
        }
        else if (textField==self.txtPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtEmail];
        }
        if (textField==self.txtPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtPassword];
        }
        return YES;
        
        
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

-(void)pushData:(id)obj  waitBlock:(void(^)(void))waitBlock
{
    @try{
        __block Users *objUsers = OBJGlobal.user;
        
        if ([[obj allKeys] containsObject:@"id"])
            objUsers.prodid = [obj valueForKey:@"id"];
        else if([[obj allKeys] containsObject:@"prod_id"])
            objUsers.prodid = [obj valueForKey:@"prod_id"];
        
        objUsers.sku =[[NSString stringWithFormat:@"%@",[obj valueForKey:@"sku"]] mutableCopy];
        objUsers.qty=[[NSString stringWithFormat:@"%@",[obj valueForKey:@"qty"]] mutableCopy];
        if(!OBJGlobal)
            OBJGlobal = [Globals sharedManager];
        
        objUsers.flag =[OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:obj];
        
        
        if([obj valueForKey:@"prod_in_cart"])
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                if(waitBlock){
                    [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                     {
                         if (status == 1) {
                             OBJGlobal.dictLastKartProduct = obj;
                             if([OBJGlobal isNotNull:[user valueForKey:@"cartitems"]]){
                                 OBJGlobal.aryKartDataGlobal=nil;
                                 OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[user valueForKey:@"cartitems"]];
                                 OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
                             }
                             
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                             
                             
                             NSLog(@"success added to kart");
                             
                             return ;
                             
                             
                         }
                         else {
                             // [self.view makeToast:[user objectForKey:@"msg"]];
                             NSLog(@"Failed");
                             //  [APPDATA hideLoader];
                         }
                     }];
                }
            }
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

-(void)forgotPasswoardMethod
{
    @try{
        [APPDATA showLoader];
        Users *objforgotPass=[[Users alloc]init];
        objforgotPass.forgotEmail = [self.txtForEmail.text mutableCopy];
        //  objLogin.password = [self.txtPassword.text mutableCopy];
        [objforgotPass forgotPassword:^(NSDictionary *user, NSString *str, int status) {
            
            if (status == 1) {
                [APPDATA showLoader];
                //  SETOBJECT(self.txtForEmail.text, @"emailid");
                // SETOBJECT(self.txtPassword.text, @"Password");
                //  SETBOOL(true, @"isLogin");
                // SYNCHRONIZE;
                
                aryforgotpass=[user valueForKey:@"msg"];
                
                [self.viewforgotPass setHidden:YES];
                [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"success");
                [APPDATA hideLoader];
            }
            else {
                [self.view makeToast:@"Email and Password Invalid"];
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(IBAction)btnFogotPasswordPressed:(id)sender
{
    @try{
        [self.view endEditing:true];
        [self.view insertSubview:self.viewforgotPass atIndex:10000];
        [self.viewforgotPass setHidden:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(IBAction)btnCancelPressed:(id)sender;
{
    
    [self.viewforgotPass setHidden:YES];
}

-(IBAction)btnSubmitPressed:(id)sender
{
    @try{
        [self.view endEditing:true];
        
        BOOL isValid=true;
        
        if(![APPDATA validateEmail:self.txtForEmail.text])
        {
            _btnFogotPassword.hidden = NO;
            
            isValid=false;
            [self.view makeToast:ERROR_EMAIL];
            [APPDATA hideLoader];
        }
        if (isValid == TRUE) {
            [self forgotPasswoardMethod];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(IBAction)btnRegisterPressed:(id)sender
{
    @try{
        RegisterViewController *objRegisterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
        [self.navigationController pushViewController:objRegisterViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


@end

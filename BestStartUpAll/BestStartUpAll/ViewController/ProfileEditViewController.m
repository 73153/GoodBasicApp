//
//  ProfileEditViewController.m
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "APICall.h"
#import "DashboardViewController.h"
#import "UIView+Toast.h"
#import "Users.h"
#import "MyOrdesViewController.h"
#import "DelivaryAddressViewController.h"
#import "NSString+Md5.h"

@interface ProfileEditViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
}
@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        
        [OBJGlobal setTextFieldWithSpace:self.txtFirstName];
        [OBJGlobal setTextFieldWithSpace:self.txtLastName];
        [OBJGlobal setTextFieldWithSpace:self.txtConfirmNewPassword];
        [OBJGlobal setTextFieldWithSpace:self.txtEmailid];
        [OBJGlobal setTextFieldWithSpace:self.txtNewPassword];
        [OBJGlobal setTextFieldWithSpace:self.txtPassword];
        
        self.txtFirstName.delegate=self;
        self.txtLastName.delegate=self;
        self.txtConfirmNewPassword.delegate=self;
        self.txtNewPassword.delegate=self;
        self.txtEmailid.delegate=self;
        self.txtPassword.delegate=self;
        
        self.txtFirstName.text = _strFirstName;
        self.txtLastName.text = _strLastName;
        self.txtEmailid.text = _strEmailID;
        
        [self setUpImageBackButton:@"left-arrow"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setnavigationImage:(NSString *)strImageName
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"My Profile";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        _lblLastAddress.text=_strLastAddressList1;
        _lblLastAddress.numberOfLines=0;
        _lblLastAddress.lineBreakMode=NSLineBreakByWordWrapping;
        
        _lblLastOrder.text=_strLastorder1;
        _lblLastOrder.numberOfLines=0;
        _lblLastOrder.lineBreakMode=NSLineBreakByWordWrapping;
        
        _lblLastAccount.text=_strLastAccount1;
        _lblLastAccount.numberOfLines=0;
        _lblLastAccount.lineBreakMode=NSLineBreakByWordWrapping;
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
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtEmailid];
            
            [self.view makeToast:ERROR_EMAIL];
            return;
        }
        else if(![Validations checkMinLength:self.txtPassword.text withLimit:6 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtPassword];
            
            [self.view makeToast:ERROR_PASSWORD];
            return;
        }
        else if(![Validations checkMinLength:self.txtNewPassword.text withLimit:6 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtNewPassword];
            
            [self.view makeToast:ERROR_PASSWORD];
            return;
        }
        else if(![Validations checkMinLength:self.txtConfirmNewPassword.text withLimit:6 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtConfirmNewPassword];
            
            [self.view makeToast:ERROR_PASSWORD];
            return;
        }
        
        if (isValid == TRUE){
            
            [self comparePassword];
            if (isCorrectPassword == true) {
                [APPDATA showLoader];
                
                Users *objProfileEdit = OBJGlobal.user;
                objProfileEdit.Email=[_txtEmailid.text mutableCopy];
                objProfileEdit.firstname=[_txtFirstName.text mutableCopy];
                objProfileEdit.lastname=[_txtLastName.text mutableCopy];
                objProfileEdit.password=[_txtNewPassword.text mutableCopy];
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] )
                {
                    
                    objProfileEdit.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                }
                
                [objProfileEdit profileEdit:^(NSDictionary *user, NSString *str, int status) {
                    
                    
                    if (status == 1) {
                        
                        [APPDATA hideLoader];
                        APPDATA.user.msg=[user objectForKey:@"msg"];
                        DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                        [self.navigationController pushViewController:objDashboardViewController animated:NO];
                        NSLog(@"success");
                    }
                    else {
                        [self.view makeToast:@"Email and Password Invalid"];
                        NSLog(@"Failed");
                        [APPDATA hideLoader];
                    }
                }];
                
            }
            
        }
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
        if (textField==self.txtPassword)
        {
            [OBJGlobal makeTextFieldNormal:self.txtPassword];
        }
        return YES;
        
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


-(void)comparePassword{
    @try{
        NSString *tempPassword = GETOBJECT(@"Password");
        if ([tempPassword isEqualToString:_txtPassword.text]) {
            if ([_txtNewPassword.text isEqualToString:_txtConfirmNewPassword.text]) {
                isCorrectPassword = true;
            }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
@end

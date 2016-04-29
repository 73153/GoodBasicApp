//
//  ContactUsViewController.m
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ContactUsViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "APICall.h"
#import "DashboardViewController.h"
#import "UIView+Toast.h"
#import "Users.h"


@interface ContactUsViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        [OBJGlobal setTextFieldWithSpace:self.txtEmail];
        [OBJGlobal setTextFieldWithSpace:self.txtPhone];
        [OBJGlobal setTextFieldWithSpace:self.txtName];
        [OBJGlobal setTextFieldWithSpace:self.txtLastName];
        
        self.txtEmail.delegate=self;
        self.txtPhone.delegate=self;
        self.txtName.delegate=self;
        self.txtLastName.delegate=self;
        
        [self setUpImageBackButton:@"left-arrow"];
        _txtCommentView.placeholder = @"Comment";
        _txtCommentView.backgroundColor=[UIColor clearColor];
        _txtCommentView.textColor = [UIColor blackColor];
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
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Contact Us";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)contactUsMethod
{
    @try{
        [APPDATA showLoader];
        Users *objContactUs=[[Users alloc]init];
        objContactUs.Email = [self.txtEmail.text mutableCopy];
        objContactUs.phone = [self.txtPhone.text mutableCopy];
        objContactUs.comment = [self.txtViewComment.text mutableCopy];
        
        NSString *myString = self.txtName.text;
        NSString *test = [myString stringByAppendingString:@" "];
        test = [test stringByAppendingString:self.txtLastName.text];
        objContactUs.username = [test mutableCopy];
        [objContactUs contactUs:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 
                 [APPDATA hideLoader];
                 [self.view makeToast:[user objectForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 
                 NSLog(@"success");
             }
             else {
                 [self.view makeToast:[user objectForKey:@"msg"]];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(IBAction)btnSubmitPressed:(id)sender
{
    @try{
        [self.view endEditing:TRUE];
        BOOL isValid=true;
        if (![Validations checkMinLength:self.txtName.text withLimit:2 ]) {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtName];
            
            [self.view makeToast:ERROR_FNAME];
            return;
        }
        else if (![Validations checkMinLength:self.txtLastName.text withLimit:2]) {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtLastName];
            
            [self.view makeToast:ERROR_LNAME];
            return;
        }
        else if(![APPDATA validateEmail:self.txtEmail.text])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtEmail];
            [self.view makeToast:ERROR_EMAIL];
            return;
            
        }
        else if(![Validations checkCvvNumber:self.txtPhone.text withLimit:12])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtPhone];
            [self.view makeToast:ERROR_Number];
            return;
        }
        else if(![Validations checkMinLength:self.txtViewComment.text withLimit:2 ])
        {
            isValid=false;
            [self.view makeToast:ERROR_COMMENT];
        }
        
        if (isValid == TRUE)
        {
            [self contactUsMethod];
            _txtEmail.text=@"";
            _txtName.text=@"";
            _txtLastName.text=@"";
            _txtCommentView.text=@"";
            _txtPhone.text=@"";
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    @try{
        
        if(textField==self.txtEmail)
        {
            [OBJGlobal makeTextFieldNormal:self.txtEmail];
        }
        else if (textField==self.txtPhone)
        {
            [OBJGlobal makeTextFieldNormal:self.txtEmail];
        }
        else if (textField==self.txtName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtPhone];
        }
        else if (textField==self.txtLastName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtName];
        }
        if (textField==self.txtLastName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtLastName];
        }
        
        return YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    @try{
        
        if(textField.text.length==2 && self.txtPhone==textField ){
            static int currentLength = 0;
            if ((currentLength += [string length]) == 1) {
                currentLength = 0;
                [textField setText:[NSString stringWithFormat:@"%@%@%c", [textField text], string, '-']];
                return NO;
            }
            
        }
        else if ( textField.text.length==6 && self.txtPhone==textField )
        {
            static int currentLength = 0;
            if ((currentLength += [string length]) == 1) {
                currentLength = 0;
                [textField setText:[NSString stringWithFormat:@"%@%@%c", [textField text], string, '-']];
                return NO;
            }
            
            
        }
        
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end

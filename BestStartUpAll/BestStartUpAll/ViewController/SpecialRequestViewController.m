//
//  SpecialRequestViewController.m
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "SpecialRequestViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"


@interface SpecialRequestViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    
}
@end

@implementation SpecialRequestViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        [OBJGlobal setTextFieldWithSpace:self.txtEmail];
        [OBJGlobal setTextFieldWithSpace:self.txtPhone];
        [OBJGlobal setTextFieldWithSpace:self.txtName];
        [OBJGlobal setTextFieldWithSpace:self.txtLastName];
        [OBJGlobal setTextFieldWithSpace:self.txtProduct];
        self.txtEmail.delegate=self;
        self.txtPhone.delegate=self;
        self.txtName.delegate=self;
        self.txtLastName.delegate=self;
        self.txtProduct.delegate=self;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Special Request";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        [self setUpImageBackButton:@"left-arrow"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
        label.numberOfLines = 0;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Special Request";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        if(OBJGlobal.numberOfCartItems<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)productRequestMethod
{
    @try{
        [APPDATA showLoader];
        Users *objProductRequest=[[Users alloc]init];
        objProductRequest.Email = [self.txtEmail.text mutableCopy];
        objProductRequest.phone = [self.txtPhone.text mutableCopy];
        objProductRequest.product = [self.txtProduct.text mutableCopy];
        NSString *myString = self.txtName.text;
        NSString *test = [myString stringByAppendingString:@" "];
        test = [test stringByAppendingString:self.txtLastName.text];
        objProductRequest.username = [test mutableCopy];
        
        [objProductRequest productRequest:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 
                 [APPDATA hideLoader];
                 [self.view makeToast:[user objectForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 
                 [self performSelector:@selector(popCurrentController) withObject:nil afterDelay:6.0];
                 
                 dicProductRequest =[user objectForKey:@"msg"];
                 NSLog(@"success");
             }
             else {
                 // [self.view makeToast:@"Email and Password Invalid"];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)popCurrentController
{
    [APPDATA hideLoader];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSendRequestPressed:(id)sender
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
        else if(![Validations checkMinLength:self.txtPhone.text withLimit:12])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtPhone];
            [self.view makeToast:ERROR_Number];
            return;
        }
        else if(![Validations checkMinLength:self.txtProduct.text withLimit:2 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtProduct];
            [self.view makeToast:ERROR_PRODUCTNAME];
            return;
        }
        
        if (isValid == TRUE)
        {
            [self productRequestMethod];
            _txtEmail.text=@"";
            _txtName.text=@"";
            _txtLastName.text=@"";
            _txtProduct.text=@"";
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
        else if (textField==self.txtProduct)
        {
            [OBJGlobal makeTextFieldNormal:self.txtLastName];
        }
        else if (textField==self.txtProduct)
        {
            [OBJGlobal makeTextFieldNormal:self.txtProduct];
        }
        if (textField==self.txtProduct)
        {
            [OBJGlobal makeTextFieldNormal:self.txtProduct];
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

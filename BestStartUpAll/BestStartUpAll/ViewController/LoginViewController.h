//
//  LoginViewController.h
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface LoginViewController : UIViewController
{
    NSMutableDictionary *dicLoginDetails;
}
@property (nonatomic,strong) IBOutlet UITextField *txtEmail;
@property (nonatomic,strong) IBOutlet UITextField *txtPassword;
@property (nonatomic,strong) IBOutlet UIButton *btnFogotPassword;
@property (nonatomic,strong) IBOutlet UIView *viewforgotPass;
@property (nonatomic,strong) IBOutlet UITextField *txtForEmail;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmit;

-(IBAction)btnCancelPressed:(id)sender;
-(IBAction)btnLoginPressed:(id)sender;
-(IBAction)btnFogotPasswordPressed:(id)sender;
-(IBAction)btnRegisterPressed:(id)sender;
-(IBAction)btnSubmitPressed:(id)sender;

-(void)forgotPasswoardMethod;




@end

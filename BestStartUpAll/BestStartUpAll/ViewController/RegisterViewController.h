//
//  RegisterViewController.h
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"
#import "Constant.h"

@interface RegisterViewController : UIViewController
{
    NSMutableDictionary *dicRegisterData;
}

@property (nonatomic,strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic,strong) IBOutlet UITextField *txtLastName;
@property (nonatomic,strong) IBOutlet UITextField *txtConfirmPassword;
@property (nonatomic,strong) IBOutlet UITextField *txtEmailid;
@property (nonatomic,strong) IBOutlet UITextField *txtPassword;
@property (nonatomic,strong) IBOutlet UIButton *btnSignUp;

- (IBAction)btnSubmitPressed:(id)sender;

@end

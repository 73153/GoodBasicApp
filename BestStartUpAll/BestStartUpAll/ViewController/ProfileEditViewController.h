//
//  ProfileEditViewController.h
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface ProfileEditViewController : UIViewController
{
    NSMutableDictionary *dicProfileEditData;
    BOOL isCorrectPassword;
}
@property (nonatomic,strong)  NSString *strLastAddressList1;
@property (nonatomic,strong)  NSString *strLastorder1;
@property (nonatomic,strong)  NSString *strLastAccount1;
@property (nonatomic,strong)  NSString *strFirstName;
@property (nonatomic,strong)  NSString *strLastName;
@property (nonatomic,strong)  NSString *strEmailID;
@property (nonatomic,strong)  NSString *strHashPassword;
@property (nonatomic,strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic,strong) IBOutlet UITextField *txtLastName;
@property (nonatomic,strong) IBOutlet UITextField *txtEmailid;
@property (nonatomic,strong) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmNewPassword;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblLastAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblLastOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblLastAccount;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnViewAllOrdersPressed:(id)sender;
- (IBAction)btnViewAllAddressPressed:(id)sender;
- (IBAction)btnSubmitPressed:(id)sender;

-(void)comparePassword;

@end

//
//  CheckoutViewController.h
//  peter
//
//  Created by Peter on 1/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "LocationSearchViewController.h"
#import "UIPlaceHolderTextView.h"
#import "PopUpTableViewController.h"

@interface CheckoutViewController : UIViewController<SearchDelegate1,PopUpDelegate>
{
    NSMutableArray *aryCheckoutData;
    NSString *strRegion_id;
    NSString *strNewAddress_id;
    NSMutableArray *aryStateList;
    NSDictionary *tempAddress;
    // BOOL isEditAddress;
}
@property BOOL isEditAddress;
@property NSString *straddress_id;
@property (nonatomic,strong) IBOutlet UIButton *btnContinue;
@property (nonatomic,strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic,strong) IBOutlet UITextField *txtLastName;
@property (nonatomic,strong) IBOutlet UITextField *txtStreetAdress;
@property (nonatomic,strong) IBOutlet UITextField *txtApt;
@property (nonatomic,strong) IBOutlet UITextField *txtCity;
@property (nonatomic,strong) IBOutlet UITextField *txtState;
@property (nonatomic,strong) IBOutlet UITextField *txtZipCode;
@property (nonatomic,strong) IBOutlet UITextField *txtMobileNumber;
@property (nonatomic,strong) IBOutlet UITextField *txtTelephone;
@property (nonatomic,strong) IBOutlet UIButton *btnEditAddress;
@property (nonatomic,strong) IBOutlet UIButton *btnSaveChanges;
@property (nonatomic, retain) NSDictionary *tempAddress;
@property (nonatomic, retain) NSString *strMyNewAddress;
@property (nonatomic,strong)  NSString *strCheckoutAddress;
@property (nonatomic,strong)  NSString *strMyEditAddress;
@property (nonatomic, strong) LocationSearchViewController *locationTableController;
@property (nonatomic, strong) PopUpTableViewController *dropDownForState;
@property (nonatomic,strong) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *txtCommentView;

- (IBAction)btnShiptoDifferentAdreassPressed:(id)sender;
- (IBAction)btnEditAdreassPressed:(id)sender;
- (IBAction)btnSaveChangesAdreassPressed:(id)sender;
- (IBAction)btnSubmitPressed:(id)sender;

-(void)existingAddress;
-(void)checkOutAddressMethod;

@end

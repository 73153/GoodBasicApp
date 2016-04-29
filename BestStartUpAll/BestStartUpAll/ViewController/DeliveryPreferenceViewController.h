//
//  DeliveryPreferenceViewController.h
//  peter
//
//  Created by Bhumesh on 02/03/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "PopUpTableViewController.h"
#import "PayPalMobile.h"
#import "ZZFlipsideViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DeliveryPreferenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, ZZFlipsideViewControllerDelegate, UIPopoverControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtSelectDate;
@property (strong, nonatomic) IBOutlet UITextField *txtSelectTime;
@property (strong, nonatomic) IBOutlet UIView *popUpDateView;
@property (strong, nonatomic) IBOutlet UITableView *popUpDateTableView;
@property (strong, nonatomic) IBOutlet UIView *popUpTimeView;
@property (strong, nonatomic) IBOutlet UITableView *tblViewDeliveryPreference;
@property (nonatomic, strong) PopUpTableViewController *dropDownForState;
@property (strong, nonatomic) IBOutlet UITableView *btnTimePressed;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property (weak, nonatomic) IBOutlet UIView *viewPopUpPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewDateTime;

- (IBAction)btnDonePicker:(id)sender;
- (IBAction)btnSelectDatePressed:(id)sender;
- (IBAction)btnSelectTimePressed:(id)sender;
- (IBAction)btnTimePressed:(id)sender;

-(void)fetchDate;
-(void)fetchTime;
-(void)dateFormatter:(NSMutableArray *)date;

@end

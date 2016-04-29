//
//  DeliveryPreferenceViewController.m
//  peter
//
//  Created by Bhumesh on 02/03/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "DeliveryPreferenceViewController.h"
#import "DeliveryPreferneceTableViewCell.h"
#import "Users.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"
#import "CardDetailViewController.h"
#import "CheckoutViewController.h"
#import "ZZMainViewController.h"
#import "PaymentViewController.h"
#import "Globals.h"

#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@interface DeliveryPreferenceViewController ()<PopUpDelegate>
{
    NSMutableArray *aryData,*actualArray;
    NSInteger lastSelectedIndex;
    NSMutableArray *aryDate,*aryTime;
    bool isZero, isFirst, isSecond, isThird;
    PopUpTableViewController *objPop;
    NSMutableDictionary *tmpDic;
    NSString *strCheckName, *strTime, *strDeliveryHour;
    Globals *OBJGlobal;
    Users *objorderHistory;
    BOOL isAuthorise, isCall , isText , isReceive;
    NSMutableArray *arrFinalData;
    NSString *strAmount, *strTempDate, *strTempTime;
    UIButton *btnDateTimeTag;
    
}
@end

@implementation DeliveryPreferenceViewController

@synthesize tblViewDeliveryPreference,popUpDateView,popUpDateTableView,popUpTimeView,viewPopUpPicker;
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try{
        OBJGlobal = [Globals sharedManager];
        _successView.hidden=true;
        lastSelectedIndex=0;
        aryDate = [[NSMutableArray alloc]init];
        aryTime = [[NSMutableArray alloc]init];
        arrFinalData = [[NSMutableArray alloc]init];
        strTempDate = [[NSString alloc]init];
        strTempTime = [[NSString alloc]init];
        strDeliveryHour = [[NSString alloc]init];
        [self getOptions];
        tblViewDeliveryPreference.delegate=self;
        tblViewDeliveryPreference.dataSource=self;
        popUpDateTableView.delegate=self;
        popUpDateTableView.dataSource=self;
        popUpDateView.hidden=YES;
        popUpTimeView.hidden=YES;
        viewPopUpPicker.hidden=YES;
        objorderHistory=[[Users alloc]init];
        [self setUpImageBackButton:@"left-arrow"];
        
        _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
        _payPalConfig.acceptCreditCards = YES;
#else
        _payPalConfig.acceptCreditCards = NO;
#endif
        _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        
        
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        
        
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
        
        self.successView.hidden = YES;
        
        
        self.environment = kPayPalEnvironment;
        
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
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
        label.text = @"Delivery Preference";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void) getOptions{
    @try{
        NSMutableDictionary *option1=[[NSMutableDictionary alloc] initWithObjects:@[@"1",@"I authorise for the replacment of a  product if it is not available or out  of stock.",@"false"] forKeys:@[keyID,keyName,keySelected]];
        NSMutableDictionary *option2=[[NSMutableDictionary alloc] initWithObjects:@[@"2",@"Call me regarding any replacement  issue.",@"false"] forKeys:@[keyID,keyName,keySelected]];
        NSMutableDictionary *option3=[[NSMutableDictionary alloc] initWithObjects:@[@"3",@"Text me regarding any replacement issue.",@"false"] forKeys:@[keyID,keyName,keySelected]];
        NSMutableDictionary *option4=[[NSMutableDictionary alloc] initWithObjects:@[@"4",@"Receive sms/email updates regarding oreder status.",@"false"] forKeys:@[keyID,keyName,keySelected]];
        aryData = [[NSMutableArray alloc] initWithObjects:option1,option2,option3,option4, nil];
        actualArray= [[NSMutableArray alloc] initWithObjects:option1,option2,option3,option4, nil];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Mark-Table Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView==tblViewDeliveryPreference) {
        return aryData.count;
    }
    else if(tableView==popUpDateTableView)
    {
        return aryDate.count;
    }
    else{
        return aryTime.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        DeliveryPreferneceTableViewCell *cell = [tblViewDeliveryPreference dequeueReusableCellWithIdentifier:@"DeliveryCell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
        cell.lblDeliveryAddress.numberOfLines=0;
        cell.lblDeliveryAddress.lineBreakMode=NSLineBreakByWordWrapping;
        
        [cell.lblDeliveryAddress setText:[NSString stringWithFormat:@"%@",[[aryData objectAtIndex:indexPath.row] valueForKey:keyName]]];
        
        for (int i=0; i<aryData.count; i++) {
            NSString *strTempTrue=[NSString stringWithFormat:@"false"];
            NSString *strarrValueTrue=[NSString stringWithFormat:@"%@",[[aryData objectAtIndex:indexPath.row ]valueForKey:keySelected]];
            
            if ([strarrValueTrue isEqualToString:strTempTrue]) {
                
                [cell.btnPressedLabel setImage:[UIImage imageNamed:@"uncheckPurple"] forState:UIControlStateNormal];
                [cell.btnPressedLabel setSelected:NO];
                NSString *strMessage = [[aryData objectAtIndex:indexPath.row] valueForKey:keyName];
                NSLog(@"%@",strMessage);
                if ([strMessage isEqualToString:@"I authorise for the replacment of a  product if it is not available or out  of stock."]) {
                    isAuthorise=false;
                }
                else if ([strMessage isEqualToString:@"Call me regarding any replacement  issue."]) {
                    isCall=false;
                }
                else if ([strMessage isEqualToString:@"Text me regarding any replacement issue."]) {
                    isText=false;
                }
                else if ([strMessage isEqualToString:@"Receive sms/email updates regarding oreder status."]) {
                    isReceive=false;
                }
                
                
            }
            else{
                [ cell.btnPressedLabel setImage:[UIImage imageNamed:@"checkPurple"] forState:UIControlStateNormal];
                [cell.btnPressedLabel setSelected:NO];
                NSString *strMessage = [[aryData objectAtIndex:indexPath.row] valueForKey:keyName];
                NSLog(@"%@",strMessage);
                if ([strMessage isEqualToString:@"I authorise for the replacment of a  product if it is not available or out  of stock."]) {
                    isAuthorise=true;
                }
                else if ([strMessage isEqualToString:@"Call me regarding any replacement  issue."]) {
                    isCall=true;
                }
                else if ([strMessage isEqualToString:@"Text me regarding any replacement issue."]) {
                    isText=true;
                }
                else if ([strMessage isEqualToString:@"Receive sms/email updates regarding oreder status."]) {
                    isReceive=true;
                }
                
            }
            
        }
        cell.btnPressedLabel.tag=indexPath.row+2000;
        [cell.btnPressedLabel addTarget:self action:@selector(btnPressedLabel:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if (tableView==tblViewDeliveryPreference) {
            DeliveryPreferneceTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
            
            tmpDic=[aryData objectAtIndex:indexPath.row];
            
            if ([[tmpDic valueForKey:keyID] isEqualToString:@"1"]) {
                
                
                if ([[tmpDic valueForKey:keySelected] isEqualToString:@"false"]) {
                    
                    [tmpDic setValue:@"true" forKey:keySelected] ;
                    
                    aryData[indexPath.row]=tmpDic;
                    for (int i=0; i<[actualArray count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:[actualArray objectAtIndex:i]];
                        if ([[dic valueForKey:keyID] isEqualToString:@"2"]) {
                            [aryData removeObject:dic];
                        }
                        else if ([[dic valueForKey:keyID] isEqualToString:@"3"]) {
                            [aryData removeObject:dic];
                        }
                    }
                    
                }
                else{
                    [tmpDic setValue:@"false" forKey:keySelected];
                    [self getOptions];
                }
            }
            else if ([[tmpDic valueForKey:keyID] isEqualToString:@"2"]) {
                // Remove 1
                if ([[tmpDic valueForKey:keySelected] isEqualToString:@"false"]) {
                    [tmpDic setValue:@"true" forKey:keySelected];
                    aryData[indexPath.row]=tmpDic;
                    for (int i=0; i<[actualArray count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:[actualArray objectAtIndex:i]];
                        if ([[dic valueForKey:keyID] isEqualToString:@"1"]) {
                            [aryData removeObject:dic];
                        }
                    }
                    
                }
                else{
                    [tmpDic setValue:@"false" forKey:keySelected];
                    [self getOptions];
                }
                
            }
            else if ([[tmpDic valueForKey:keyID] isEqualToString:@"3"]) {
                // Remove 1
                if ([[tmpDic valueForKey:keySelected] isEqualToString:@"false"]) {
                    [tmpDic setValue:@"true" forKey:keySelected];
                    aryData[indexPath.row]=tmpDic;
                    for (int i=0; i<[actualArray count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:[actualArray objectAtIndex:i]];
                        if ([[dic valueForKey:keyID] isEqualToString:@"1"]) {
                            [aryData removeObject:dic];
                        }
                    }
                    
                }
                else{
                    [tmpDic setValue:@"false" forKey:keySelected];
                    [self getOptions];
                }
                
            }
            else if ([[tmpDic valueForKey:keyID] isEqualToString:@"4"]) {
                //
                if ([[tmpDic valueForKey:keySelected] isEqualToString:@"false"]) {
                    [tmpDic setValue:@"true" forKey:keySelected];
                }
                else{
                    [tmpDic setValue:@"false" forKey:keySelected];
                }
            }
            
            // Hide logic
            [self.tblViewDeliveryPreference reloadData];
        }
        else if (tableView==popUpDateTableView)
        {
            _txtSelectDate.text=[[aryDate objectAtIndex:indexPath.row]valueForKey:@"Date"];
            popUpDateView.hidden=YES;
            tblViewDeliveryPreference.alpha=1;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    @try{
        popUpDateView.hidden=YES;
        viewPopUpPicker.hidden=NO;
        return 0;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


- (IBAction)btnContinuePressed:(id)sender {
    
    @try{
        
        BOOL isValid=true;
        
        if([Validations isEmpty:self.txtSelectDate.text])
        {
            isValid=false;
            [self.view makeToast:ERROR_DATEEMPTY];
            
        }
        else if([Validations isEmpty:self.txtSelectTime.text])
        {
            isValid=false;
            [self.view makeToast:ERROR_TIMEEMPTY];
            
        }
        
        
        if (isValid == TRUE)
        {
            [APPDATA showLoader];
            [self OrderDelivery];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnSelectDatePressed:(id)sender {
    
    @try{
        btnDateTimeTag = sender;
        [self fetchDate];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnSelectTimePressed:(id)sender {
    @try{
        btnDateTimeTag = sender;
        [self fetchTime];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
    
}


-(void)didSelectedRegionString:(NSString *)selectedString tableView:(id)tableView
{
    @try{
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    @try{
        [super touchesBegan:touches withEvent:event];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnTimePressed:(id)sender {
    
    
}

-(void)btnPressedLabel:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-2000;
        
        NSString *strMessage = [[aryData objectAtIndex:btnTag] valueForKey:keyName];
        if(btnTag==0 && [strMessage isEqualToString:@"I authorise for the replacment of a  product if it is not available or out  of stock."]) {
            isAuthorise=true;
            
        }
        if (btnTag==1 && [strMessage isEqualToString:@"Receive sms/email updates regarding oreder status."]){
            isReceive=true;
            
        }
        
        if (btnTag==0 && [strMessage isEqualToString:@"Call me regarding any replacement  issue."]){
            isCall=true;
            
        }
        if (btnTag==1 && [strMessage isEqualToString:@"Text me regarding any replacement issue."]){
            isText=true;
            
        }
        if (btnTag==2 && [strMessage isEqualToString:@"Receive sms/email updates regarding oreder status."]){
            isReceive=true;
        }
        if (btnTag==1 && [strMessage isEqualToString:@"Call me regarding any replacement  issue."]){
            isCall=true;
        }
        if (btnTag==2 && [strMessage isEqualToString:@"Text me regarding any replacement issue."]){
            isText=true;
            
        }
        if (btnTag==3 && [strMessage isEqualToString:@"Receive sms/email updates regarding oreder status."]){
            isReceive=true;
            
        }
        
        
        NSDictionary *dictDetail = [aryData objectAtIndex:btnTag];
        strCheckName=[dictDetail valueForKey:keyName];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)OrderDelivery
{
    @try{
        //Change Date Format
        NSString *strDate = [NSString stringWithFormat:@"%@",_txtSelectDate.text];
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM dd, yyyy"];
        NSDate *date = [dateFormat dateFromString:strDate];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        strDate = [dateFormat stringFromDate:date];
        
        [APPDATA showLoader];
        
        Users *objDeliveryPreference = OBJGlobal.user;
        objDeliveryPreference.select_date=[NSMutableString stringWithFormat:@"%@",strDate];
        objDeliveryPreference.select_time=[NSMutableString stringWithFormat:@"%@",_txtSelectTime.text];
        objDeliveryPreference.strAuthorise=[NSMutableString stringWithFormat:@"%d",isAuthorise];
        objDeliveryPreference.strCall=[NSMutableString stringWithFormat:@"%d",isCall];
        objDeliveryPreference.strText=[NSMutableString stringWithFormat:@"%d",isText];
        objDeliveryPreference.strReceive=[NSMutableString stringWithFormat:@"%d",isReceive];
        
        [objDeliveryPreference deliveryPreference:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                
                [APPDATA hideLoader];
                
                arrFinalData =[user objectForKey:@"data"];
                if([OBJGlobal isNotNull:arrFinalData])
                    [OBJGlobal.arrPaypalData addObject:arrFinalData];
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                
                CardDetailViewController *objCardDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
                [self.navigationController pushViewController:objCardDetailViewController animated:NO];
                
                
                NSLog(@"success");
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



#pragma mark PAYPAL DELEGATE METHODS
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    @try{
        NSLog(@"PayPal Payment Success!");
        self.resultText = [completedPayment description];
        [self showSuccess];
        
        [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
        [self dismissViewControllerAnimated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    @try{
        NSLog(@"PayPal Payment Canceled");
        self.resultText = nil;
        self.successView.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    [self showSuccess];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}

#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    @try{
        [self.view makeToast:@"Payment done successful"];
        NSLog(@"PayPal Profile Sharing Authorization Success!");
        self.resultText = [profileSharingAuthorization description];
        [self showSuccess];
        
        [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
        [self dismissViewControllerAnimated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}


#pragma mark - Helpers

- (void)showSuccess {
    @try{
        self.successView.hidden = false;
        self.successView.alpha = 1.0f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:2.0];
        self.successView.alpha = 0.0f;
        [UIView commitAnimations];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark - Flipside View Controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushSettings"]) {
        [[segue destinationViewController] setDelegate:(id)self];
    }
}

#pragma Mark - PickerView Delegate Method
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    @try{
        if (btnDateTimeTag.tag == 2000) {
            return [aryDate count];
        }
        else{
            return [aryTime count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    @try{
        if (btnDateTimeTag.tag == 2000) {
            return [aryDate objectAtIndex:row];
        }
        else{
            return [aryTime objectAtIndex:row];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnDonePicker:(id)sender {
    @try{
        viewPopUpPicker.hidden=YES;
        
        if (btnDateTimeTag.tag == 2000) {
            _txtSelectDate.text=[aryDate objectAtIndex:[_pickerViewDateTime selectedRowInComponent:0]];
            btnDateTimeTag = 0;
        }
        else{
            _txtSelectTime.text=[aryTime objectAtIndex:[_pickerViewDateTime selectedRowInComponent:0]];
            btnDateTimeTag = 0;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
    
}

-(void)fetchDate
{
    
    @try{
        
        [APPDATA showLoader];
        Users *objCheckoutDeliveryDate=[[Users alloc]init];
        objCheckoutDeliveryDate.zipCode = GETOBJECT(@"Location");
        [objCheckoutDeliveryDate checkoutDeliveryDate:^(NSDictionary *user, NSString *str, int status)
         {
             
             
             if (status == 1) {
                 
                 [APPDATA hideLoader];
                 aryDate = [user valueForKey:@"delivery_dates"];
                 [self dateFormatter:aryDate];
                 viewPopUpPicker.hidden=NO;
                 _pickerViewDateTime.delegate=self;
                 _pickerViewDateTime.dataSource=self;
                 NSLog(@"success");
             }
             else {
                 if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                     [self.view makeToast:[user valueForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
    
}

-(void)fetchTime{
    @try{
        if([OBJGlobal isNotNull:_txtSelectDate.text])
        {
            [APPDATA showLoader];
            Users *objCheckoutDeliveryTime=[[Users alloc]init];
            objCheckoutDeliveryTime.zipCode = GETOBJECT(@"Location");
            objCheckoutDeliveryTime.checkOutSelectedDate = [NSMutableString stringWithFormat:@"%@",_txtSelectDate.text];
            [objCheckoutDeliveryTime checkoutDeliveryTime:^(NSDictionary *user, NSString *str, int status)
             {
                 
                 
                 if (status == 1) {
                     
                     [APPDATA hideLoader];
                     aryTime = [user valueForKey:@"delivery_time"];
                     viewPopUpPicker.hidden=NO;
                     _pickerViewDateTime.delegate=self;
                     _pickerViewDateTime.dataSource=self;
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                         [self.view makeToast:[user valueForKey:@"msg"]];
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
        }
        else{
            [self.view endEditing:TRUE];
            [self.view makeToast:@"Please select Date First"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(void)dateFormatter:(NSMutableArray *)date{
    @try{
        aryDate = [[NSMutableArray alloc]init];
        for (int i=0; i<date.count; i++) {
            
            NSString *strDate = [NSString stringWithFormat:@"%@",[date objectAtIndex:i]];
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:strDate];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"MMMM dd, YYYY"];
            strDate = [dateFormat stringFromDate:date];
            
            
            [aryDate addObject:strDate];
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}

-(void)setPayPalEnvironment:(NSString *)environment
{
    
}
-(void)btnClosePopUp
{
    
}
@end

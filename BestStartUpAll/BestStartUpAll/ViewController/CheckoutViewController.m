//
//  CheckoutViewController.m
//  peter
//
//  Created by Peter on 1/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CheckoutViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "CheckoutViewController.h"
#import "PaymentViewController.h"
#import "UIView+Toast.h"
#import "MNAutoComplete.h"
#import "ShippingViewController.h"
#import "DeliveryPreferenceViewController.h"
#import "DelivaryAddressViewController.h"
#import "AppDelegate.h"

@interface CheckoutViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    MNAutoComplete *_autoComplete;
    NSString *regionId;
    BOOL isValid;
    AppDelegate *objApp;
}
@end

@implementation CheckoutViewController
@synthesize tempAddress;


- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        [self loadStateListTable];
        [self setUpImageBackButton:@"left-arrow"];
        [OBJGlobal setTextFieldWithSpace:self.txtFirstName];
        [OBJGlobal setTextFieldWithSpace:self.txtLastName];
        [OBJGlobal setTextFieldWithSpace:self.txtStreetAdress];
        [OBJGlobal setTextFieldWithSpace:self.txtApt];
        [OBJGlobal setTextFieldWithSpace:self.txtCity];
        [OBJGlobal setTextFieldWithSpace:self.txtState];
        [OBJGlobal setTextFieldWithSpace:self.txtZipCode];
        [OBJGlobal setTextFieldWithSpace:self.txtMobileNumber];
        [OBJGlobal setTextFieldWithSpace:self.txtTelephone];
        
        self.txtState.delegate=self;
        self.txtState.tag=333;
        self.txtCity.tag=444;
        self.txtCity.delegate=self;
        self.txtFirstName.delegate=self;
        self.txtLastName.delegate=self;
        self.txtStreetAdress.delegate=self;
        self.txtApt.delegate=self;
        self.txtZipCode.delegate=self;
        self.txtMobileNumber.delegate=self;
        self.txtTelephone.delegate=self;
        
        objApp = [[UIApplication sharedApplication]delegate];
        [self stateListMethod];
        
        NSLog(@"Dict:%@",tempAddress);
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 44, 56)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Billing Address";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        //My Account Condition
        if (![tempAddress isEqual:@""] && [_strMyEditAddress isEqualToString:@"My Edit Address"]) {
            [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
            _btnContinue.hidden=YES;
            _btnEditAddress.hidden=YES;
            _btnSaveChanges.hidden=NO;
            label.text = @"Edit Address";
            //         EDIT ADDRESS
            [self fillAddressField];
        }
        
        else if ([OBJGlobal isNotNull:tempAddress]) {
            
            _btnEditAddress.hidden=NO;
            _btnContinue.hidden=YES;
            label.text = @"Billing Address";
            [self fillAddressField];
        }
        
        
        if ([_strMyNewAddress isEqualToString:@"My Account"]) {
            [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
            label.text = @"My Address";
            _btnSaveChanges.hidden=NO;
            _btnContinue.hidden=YES;
            _btnEditAddress.hidden=YES;
        }
        
        else if ([_strCheckoutAddress isEqualToString:@"Checkout Address"])
        {
            label.text = @"Billing Address";
            _btnContinue.hidden=NO;
            _btnEditAddress.hidden=YES;
            
        }
        if ([OBJGlobal isNotNull:objApp.dictAppNewAddress]) {
            [self existingAddress];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)existingAddress
{
    @try{
        _txtFirstName.text = [objApp.dictAppNewAddress valueForKey:@"firstname"];
        _txtLastName.text = [objApp.dictAppNewAddress valueForKey:@"lastname"];
        _txtStreetAdress.text = [objApp.dictAppNewAddress valueForKey:@"street"];
        _txtApt.text = [objApp.dictAppNewAddress valueForKey:@"apt"];
        _txtCity.text = [objApp.dictAppNewAddress valueForKey:@"city"];
        _txtState.text = [objApp.dictAppNewAddress valueForKey:@"state"];
        _txtZipCode.text = [objApp.dictAppNewAddress valueForKey:@"zipcode"];
        _txtMobileNumber.text = [objApp.dictAppNewAddress valueForKey:@"mobile"];
        _txtTelephone.text = [objApp.dictAppNewAddress valueForKey:@"telephone"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)fillAddressField
{
    @try{
        _txtFirstName.text=[tempAddress valueForKey:@"firstname"];
        _txtLastName.text=[tempAddress valueForKey:@"lastname"];
        
        
        if([OBJGlobal isNotNull:[tempAddress valueForKey:@"street"]]){
            
            __block NSString *str1=@"";
            __block NSString *str2=@"";
            
            if([[tempAddress allKeys]containsObject:@"street"]){
                NSArray *arystreetAddress = [tempAddress valueForKey:@"street"];
                if(arystreetAddress.count>0){
                    if([OBJGlobal isNotNull:[arystreetAddress objectAtIndex:0 ]])
                        str1  = [arystreetAddress objectAtIndex:0];
                    if(arystreetAddress.count==2)
                        if([OBJGlobal isNotNull:[arystreetAddress objectAtIndex:1 ]])
                            str2 = [arystreetAddress objectAtIndex:1];
                    
                    _txtStreetAdress.text = [NSString stringWithFormat:@"%@",str1];
                    _txtApt.text = [NSString stringWithFormat:@"%@",str2];
                }
                
                
            }
            
        }
        
        _txtCity.text=[tempAddress valueForKey:@"city"];
        _txtState.text=[tempAddress valueForKey:@"region"];
        _txtZipCode.text=[tempAddress valueForKey:@"postcode"];
        _txtTelephone.text=[tempAddress valueForKey:@"telephone"];
        
        if([OBJGlobal isNotNull:[tempAddress valueForKey:@"mobile"]])
            _txtMobileNumber.text=[tempAddress valueForKey:@"mobile"];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (IBAction)btnShiptoDifferentAdreassPressed:(id)sender
{
    @try{
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ShippingViewController *objShippingViewController = [storybord instantiateViewControllerWithIdentifier:@"ShippingViewController"];
        [self.navigationController pushViewController:objShippingViewController animated:YES];
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
        else if (textField==self.txtStreetAdress)
        {
            [OBJGlobal makeTextFieldNormal:self.txtLastName];
        }
        //else if (textField==self.txtApt)
        //{
        //   [OBJGlobal makeTextFieldNormal:self.txtStreetAdress];
        //}
        else if (textField==self.txtCity)
        {
            [OBJGlobal makeTextFieldNormal:self.txtApt];
        }
        else if (textField==self.txtState)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCity];
        }
        else if (textField==self.txtZipCode)
        {
            [OBJGlobal makeTextFieldNormal:self.txtState];
        }
        else if (textField==self.txtMobileNumber)
        {
            [OBJGlobal makeTextFieldNormal:self.txtZipCode];
        }
        else if (textField==self.txtTelephone)
        {
            [OBJGlobal makeTextFieldNormal:self.txtMobileNumber];
        }
        if (textField==self.txtTelephone)
        {
            [OBJGlobal makeTextFieldNormal:self.txtTelephone];
        }
        return YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField  {         // became first responder
    @try{
        
        //        if (textField==self.txtCity && textField.tag==444)
        //        {
        //
        //            [self.dropDownForState toggleHidden:YES];
        //            [self.locationTableController toggleHidden:NO];
        //            NSArray *sourceArray = [NSMutableArray arrayWithArray:[self getSearchHistory]];
        //            [self.locationTableController reloadDataWithSource:sourceArray];
        //
        //        }
        //  else
        if(textField==self.txtState && textField.tag==333)
        {
            [self.locationTableController toggleHidden:YES];
            [self.dropDownForState toggleHidden:NO];
            
        }
        //
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    @try{
        //        if(textField.text.length>=2 && self.txtCity==textField)
        //        {
        //            [self.locationTableController toggleHidden:NO];
        //            [_autoComplete startWithKeyword:textField.text];
        //        }
        //        else if(textField.text.length<=2 && self.txtCity==textField)
        //            [self.locationTableController toggleHidden:YES];
        //
        //
        
        //peter
        
        if(textField.text.length==2 && ( self.txtMobileNumber==textField || self.txtTelephone==textField )){
            static int currentLength = 0;
            if ((currentLength += [string length]) == 1) {
                currentLength = 0;
                [textField setText:[NSString stringWithFormat:@"%@%@%c", [textField text], string, '-']];
                return NO;
            }
            
        }
        else if ( textField.text.length==6 && ( self.txtMobileNumber==textField || self.txtTelephone==textField ))
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
}// return NO to not change text




-(NSArray *)getSearchHistory{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SEARCH_HISTORY"];
}

#pragma mark - Autocomplete Delegate
- (void)autocompleteDidReturn:(NSArray *)results {
    [self.locationTableController reloadDataWithSource:results];
    
}

#pragma mark - Search Delegate
-(void)didSelectSearchedString:(NSString *)selectedString{
    @try{
        NSLog(@"SELECTED %@",selectedString);
        NSArray *res = [selectedString componentsSeparatedByString:@","];
        NSString *state=res[1];
        NSString *subString;
        if ([selectedString rangeOfString:@","].location == NSNotFound)
            subString = selectedString;
        else
            subString = [selectedString substringWithRange: NSMakeRange(0, [selectedString rangeOfString: @","].location)];
        selectedString = subString;
        self.txtCity.text=selectedString;
        self.txtState.text=state;
        
        [self.locationTableController toggleHidden:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)didSelectedRegionString:(NSString *)selectedString tableView:(id)tableView
{
    @try{
        self.txtState.text=selectedString;
        [aryStateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *strStateName = [NSString stringWithFormat:@"%@",[[aryStateList objectAtIndex:idx] valueForKey:@"names"]];
            if([selectedString isEqualToString:strStateName]){
                
                strRegion_id = [[aryStateList objectAtIndex:idx] valueForKey:@"region_id"];
            }
        }];
        [tableView toggleHidden:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark AutoCompletePlace
//-(void)loadAutocompletandLocationTable{
//    @try{
//        if(!_autoComplete){
//
//            _autoComplete = [[MNAutoComplete alloc] initWithDelegate:self];
//            self.locationTableController = [[LocationSearchViewController alloc] initWithStyle:UITableViewStylePlain];
//
//            self.locationTableController.tableView.frame = CGRectMake(self.txtCity.frame.origin.x,self.txtCity.frame.origin.y-self.txtCity.frame.size.height, self.txtCity.frame.size.width,self.view.frame.size.height-self.txtCity.frame.origin.y);
//
//            self.locationTableController.delegate = self;
//            [self.view insertSubview:self.locationTableController.tableView atIndex:1000];
//            [self.locationTableController toggleHidden:YES];
//            self.locationTableController.tableView.layer.borderWidth = 2;
//            self.locationTableController.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
//        }
//    } @catch (NSException *exception) {
//        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
//    }
//}
//

-(void)loadStateListTable{
    @try{
        if(!self.dropDownForState){
            OBJGlobal.isDeliveryPreferencePopUp=true;
            self.dropDownForState = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
            
            self.dropDownForState.tableView.frame = CGRectMake(self.txtState.frame.origin.x,self.txtState.frame.origin.y-self.txtState.frame.size.height, self.txtState.frame.size.width,self.view.frame.size.height-self.txtState.frame.origin.y);
            
            self.dropDownForState.delegate = self;
            [self.view insertSubview:self.dropDownForState.tableView atIndex:1000];
            [self.dropDownForState toggleHidden:YES];
            self.dropDownForState.tableView.layer.borderWidth = 2;
            self.dropDownForState.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    @try{
        [super touchesBegan:touches withEvent:event];
        [self.locationTableController toggleHidden:YES];
        [self.dropDownForState toggleHidden:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
-(void)checkOutAddressMethod
{
    @try{
        [APPDATA showLoader];
        Users *objCheckout = OBJGlobal.user;
        objCheckout.firstname=[_txtFirstName.text mutableCopy];
        objCheckout.lastname=[_txtLastName.text mutableCopy];
        objCheckout.city=[_txtCity.text mutableCopy];
        objCheckout.state=[_txtState.text mutableCopy];
        objCheckout.zipCode=[_txtZipCode.text mutableCopy];
        objCheckout.mobile=[_txtMobileNumber.text mutableCopy];
        objCheckout.phone=[_txtTelephone.text mutableCopy];
        objCheckout.streetAdd=[_txtStreetAdress.text mutableCopy];
        objCheckout.Apt=[_txtApt.text mutableCopy];
        objCheckout.region_id=[[NSString stringWithFormat:@"%@",strRegion_id]mutableCopy];
        objCheckout.addressid=[[NSString stringWithFormat:@"%@",[tempAddress valueForKey:@"address_id"] ] mutableCopy];
        
        NSMutableDictionary *strAddress = [[NSMutableDictionary alloc] init];
        [strAddress setObject:_txtApt.text forKey:@"street2"];
        [strAddress setObject:_txtStreetAdress.text forKey:@"street1"];        [strAddress setObject:_txtFirstName.text forKey:@"firstname"];
        [strAddress setObject:_txtLastName.text forKey:@"lastname"];
        [strAddress setObject:_txtCity.text forKey:@"city"];
        [strAddress setObject:_txtState.text forKey:@"region"];
        [strAddress setObject:_txtZipCode.text  forKey:@"postcode"];
        [strAddress setObject:_txtTelephone.text forKey:@"telephone"];
        [strAddress setObject:_txtMobileNumber.text forKey:@"mobile"];
        [strAddress setObject:[NSString stringWithFormat:@"%@",strRegion_id] forKey:@"region_id"];
        //[aryTempStreet addObject:strAddress];
        
        objCheckout.dictAddress= strAddress;
        
        [objCheckout checkoutAddress:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                OBJGlobal.isDeliveryAddressListNill=false;
                [APPDATA hideLoader];
                // APPDATA.user.msg=[user objectForKey:@"msg"];
                
                aryCheckoutData =[user objectForKey:@"total"];
                [OBJGlobal.arrPaypalData addObject:aryCheckoutData];
                if([[user allKeys]containsObject:@"msg"])
                    [self.view makeToast:[user objectForKey:@"msg"]];
                //    [self.view makeToast:@"login successfully"];
                //  sleep(3);
                
                
                tempAddress=nil;
                _txtFirstName.text = @"";
                _txtLastName.text = @"";
                _txtStreetAdress.text = @"";
                _txtApt.text = @"";
                _txtCity.text= @"";
                _txtState.text=@"";
                _txtZipCode.text=@"";
                _txtMobileNumber.text=@"";
                _txtTelephone.text=@"";
                
                DeliveryPreferenceViewController *objDeliveryPreferenceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryPreferenceViewController"];
                [self.navigationController pushViewController :objDeliveryPreferenceViewController animated:NO];
                
                NSLog(@"success");
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                {
                    [self.view makeToast:[user valueForKey:@"msg"]];
                }
                
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)checkOutAddressUpdateMethod
{
    @try{
        [APPDATA showLoader];
        
        Users *objCheckoutupdate = OBJGlobal.user;
        objCheckoutupdate.firstname=[_txtFirstName.text mutableCopy];
        objCheckoutupdate.lastname=[_txtLastName.text mutableCopy];
        objCheckoutupdate.city=[_txtCity.text mutableCopy];
        objCheckoutupdate.state=[_txtState.text mutableCopy];
        objCheckoutupdate.zipCode=[_txtZipCode.text mutableCopy];
        objCheckoutupdate.mobile=[_txtMobileNumber.text mutableCopy];
        objCheckoutupdate.phone=[_txtTelephone.text mutableCopy];
        objCheckoutupdate.region_id=[[NSString stringWithFormat:@"%@",strRegion_id]mutableCopy];
        objCheckoutupdate.mobile=[_txtMobileNumber.text mutableCopy];
        objCheckoutupdate.streetAdd=[_txtStreetAdress.text mutableCopy];
        objCheckoutupdate.Apt=[_txtApt.text mutableCopy];
        
        NSString *tempAddressID=[NSString stringWithFormat:@"%@",[tempAddress valueForKey:@"address_id"]];
        objCheckoutupdate.addressid=[[NSString stringWithFormat:@"%@",tempAddressID]mutableCopy];
        
        [objCheckoutupdate customerAddressupdate:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                
                [APPDATA hideLoader];
                aryCheckoutData=nil;
                _btnEditAddress.hidden=YES;
                _btnContinue.hidden=NO;
                // APPDATA.user.msg=[user objectForKey:@"msg"];
                
                //aryCheckoutData =[user objectForKey:@"msg"];
                
                [self.view makeToast:[user objectForKey:@"msg"]];
                if ([_strMyEditAddress isEqualToString:@"My Edit Address"])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
                NSLog(@"success");
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                {
                    [self.view makeToast:[user valueForKey:@"msg"]];
                }
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)createAddressMethod
{
    @try{
        [APPDATA showLoader];
        
        __block Users *objCheckoutCreate = OBJGlobal.user;
        objCheckoutCreate.firstname=[_txtFirstName.text mutableCopy];
        objCheckoutCreate.lastname=[_txtLastName.text mutableCopy];
        objCheckoutCreate.city=[_txtCity.text mutableCopy];
        objCheckoutCreate.state=[_txtState.text mutableCopy];
        objCheckoutCreate.zipCode=[_txtZipCode.text mutableCopy];
        objCheckoutCreate.mobile=[_txtMobileNumber.text mutableCopy];
        objCheckoutCreate.phone=[_txtTelephone.text mutableCopy];
        objCheckoutCreate.region_id=[[NSString stringWithFormat:@"%@",strRegion_id]mutableCopy];
        objCheckoutCreate.streetAdd=[_txtStreetAdress.text mutableCopy];
        objCheckoutCreate.Apt=[_txtApt.text mutableCopy];
        
        [objCheckoutCreate addressCreate:^(NSDictionary *user, NSString *str, int status) {
            
            if (status == 1) {
                
                [APPDATA hideLoader];
                aryCheckoutData=nil;
                
                [self.navigationController popViewControllerAnimated:YES];
                
                [self.view makeToast:[user objectForKey:@"msg"]];
                
                NSLog(@"success");
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                {
                    [self.view makeToast:[user valueForKey:@"msg"]];
                }
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (IBAction)btnEditAdreassPressed:(id)sender
{
    [self.view endEditing:true];
    [self validationCheck];
    
    if (isValid == TRUE){
        [self checkOutAddressUpdateMethod];
       
    }
    
    
}

- (IBAction)btnSaveChangesAdreassPressed:(id)sender
{
    @try{
        [self.view endEditing:true];
        [self validationCheck];
        if ([_strMyEditAddress isEqualToString:@"My Edit Address"] && isValid == TRUE)
        {
            [self checkOutAddressUpdateMethod];
            
        }
        else if ([_strMyNewAddress isEqualToString:@"My Account"]&& isValid == TRUE)
        {
            [self createAddressMethod];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)validationCheck
{
    @try{
        isValid=true;
        if (![Validations checkMinLength:self.txtFirstName.text withLimit:2]) {
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
        else if(![Validations checkMinLength:self.txtStreetAdress.text withLimit:2 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtStreetAdress];
            [self.view makeToast:ERROR_ADDRESS];
            return;
            
        }
        //    else if(![Validations checkMinLength:self.txtApt.text withLimit:2 ])
        //    {
        //        isValid=false;
        //        [OBJGlobal makeTextFieldBorderRed:self.txtApt];
        //        [self.view makeToast:ERROR_ADDRESS];
        //        return;
        //
        //    }
        else if(![Validations checkMinLength:self.txtCity.text withLimit:2 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtCity];
            [self.view makeToast:ERROR_CITY];
            return;
        }
        else if(![Validations checkMinLength:self.txtState.text withLimit:2 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtState];
            [self.view makeToast:ERROR_STATE];
            return;
            
        }
        else if(![Validations checkMinLength:self.txtZipCode.text withLimit:4 ])
        {
            isValid=false;
            
            [OBJGlobal makeTextFieldBorderRed:self.txtZipCode];
            
            [self.view makeToast:ERROR_CODE];
            return;
        }
        
        else if(![Validations checkCvvNumber:self.txtMobileNumber.text withLimit:12 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtMobileNumber];
            [self.view makeToast:ERROR_Number];
            return;
        }
        
        else if(![Validations checkCvvNumber:self.txtTelephone.text withLimit:12 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtTelephone];
            [self.view makeToast:ERROR_Number];
            return;
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnSubmitPressed:(id)sender;
{
    @try{
        [self.view endEditing:true];
        
        [self validationCheck];
        
        if (isValid == TRUE){
            
            
            NSString *strFirstName = _txtFirstName.text;
            NSString *strlastName = _txtLastName.text;
            NSString *strStreetAddress = _txtStreetAdress.text;
            NSString *strApt = _txtApt.text;
            NSString *strCity = _txtCity.text;
            NSString *strState = _txtState.text;
            NSString *strZipCode = _txtZipCode.text;
            NSString *strMobile = _txtMobileNumber.text;
            NSString *strTelephone = _txtTelephone.text;
            
            objApp.dictAppNewAddress = [[NSMutableDictionary alloc]initWithObjects:@[strFirstName,strlastName,strStreetAddress,strApt,strCity,strState,strZipCode,strMobile,strTelephone ]forKeys:@[@"firstname",@"lastname",@"street",@"apt",@"city",@"state",@"zipcode",@"mobile",@"telephone"]];
            
            [self checkOutAddressMethod];
            
        } } @catch (NSException *exception) {
            NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
        }
}

-(void)stateListMethod
{
    @try{
        [APPDATA showLoader];
        
        Users *objStateList = OBJGlobal.user;
        [objStateList stateList:^(NSDictionary *user, NSString *str, int status) {
            
            if (status == 1) {
                
                [APPDATA hideLoader];
                // APPDATA.user.msg=[user objectForKey:@"msg"];
                
                aryStateList =[user objectForKey:@"list"];
                strRegion_id =[NSString stringWithFormat:@"%@", [[aryStateList objectAtIndex:0] valueForKey:@"region_id"]];
                NSMutableArray *aryStateName = [[NSMutableArray alloc] init];
                [aryStateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *strStateName = [[aryStateList objectAtIndex:idx] valueForKey:@"names"];
                    [aryStateName addObject:strStateName];
                }];
                [self.dropDownForState reloadDataWithSource:aryStateName];
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
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark popup delegate
-(void)btnClosePopUp{
}


@end

//
//  PaymentViewController.m
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PaymentViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"
#import "AESCrypt.h"
#import "MyOrdesViewController.h"
#import "MyKartViewController.h"

@interface PaymentViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    NSMutableArray *years;
    NSArray *arrMonths, *arrCardType;
    UIButton *btnTag;
    NSString *strEncryptedData, *strCardType;
}
@end

@implementation PaymentViewController

@synthesize txtCardType,txtCardNumber,txtCVVNumber,txtExpiredMonth,txtExpiredYear,txtCardName,btnMonthPressed,btnYearPressed,pickerView,viewForPicker,storeCard,imgCardType;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        
        [OBJGlobal setTextFieldWithSpace:self.txtCardNumber];
        [OBJGlobal setTextFieldWithSpace:self.txtCardType];
        [OBJGlobal setTextFieldWithSpace:self.txtCVVNumber];
        [OBJGlobal setTextFieldWithSpace:self.txtExpiredMonth];
        [OBJGlobal setTextFieldWithSpace:self.txtExpiredYear];
        [OBJGlobal setTextFieldWithSpace:self.txtCardName];
        
        self.txtCardType.delegate=self;
        self.txtCardNumber.delegate=self;
        self.txtCVVNumber.delegate=self;
        self.txtExpiredMonth.delegate=self;
        self.txtExpiredYear.delegate=self;
        self.txtCardName.delegate=self;
        
        [self.btnMonthPressed setTag:100];
        [self setUpImageBackButton:@"left-arrow"];
        
        strEncryptedData = [[NSString alloc]init];
        strCardType = [[NSString alloc]init];
        viewForPicker.hidden=YES;
        storeCard =false;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Payment";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(void)fetchMonth:(UIButton *)btnMonth
{
    @try {
        btnTag = btnMonth;
        arrMonths = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
        pickerView.delegate=self;
        pickerView.dataSource=self;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)fetchYear
{
    @try {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY"];
        int currentYear  = [[formatter stringFromDate:[NSDate date]] intValue];
        
        int nextYears = currentYear+100;
        //Create Years Array from 1960 to This year
        years = [[NSMutableArray alloc] init];
        for (int i=currentYear; i<=nextYears; i++) {
            [years addObject:[NSString stringWithFormat:@"%d",i]];
        }
        pickerView.delegate=self;
        pickerView.dataSource=self;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    //Get Current Year into i2
    
    
}

#pragma Mark - PickerView Delegate Method
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    @try {
        if (btnTag.tag==1000) {
            return [arrMonths count];
        }
        else if (btnTag.tag==2000)
        {
            return [arrCardType count];
        }
        else{
            return [years count];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    @try {
        if (btnTag.tag == 1000) {
            return [arrMonths objectAtIndex:row];
        }
        else if (btnTag.tag == 2000) {
            return [arrCardType objectAtIndex:row];
        }
        else{
            
            return [years objectAtIndex:row];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

#pragma Mark -textField Delegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    @try{
        
        if(textField.text.length==3 && self.txtCardNumber==textField ){
            static int currentLength = 0;
            if ((currentLength += [string length]) == 1) {
                currentLength = 0;
                [textField setText:[NSString stringWithFormat:@"%@%@%c", [textField text], string, '-']];
                return NO;
            }
            
        }
        else if ( textField.text.length==8 &&  self.txtCardNumber==textField )
        {
            static int currentLength = 0;
            if ((currentLength += [string length]) == 1) {
                currentLength = 0;
                [textField setText:[NSString stringWithFormat:@"%@%@%c", [textField text], string, '-']];
                return NO;
            }
            
            
        }
        else if ( textField.text.length==13 &&  self.txtCardNumber==textField )
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



- (IBAction)btnDonePressed:(id)sender {
    
    @try {
        if (btnTag.tag==1000) {
            txtExpiredMonth.text=[arrMonths objectAtIndex:[pickerView selectedRowInComponent:0]];
            btnTag = 0;
        }
        else{
            txtExpiredYear.text=[years objectAtIndex:[pickerView selectedRowInComponent:0]];
        }
        viewForPicker.hidden=YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
    
}

- (IBAction)btnMonthPressed:(id)sender {
    @try {
        
        viewForPicker.hidden=NO;
        [self fetchMonth:sender];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}

- (IBAction)btnYearPressed:(id)sender {
    @try{
        viewForPicker.hidden=NO;
        [ self fetchYear];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnCardSave:(id)sender {
    @try {
        
        _btnCardSave.selected = !_btnCardSave.selected;
        storeCard = true;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnCardTypePressed:(id)sender {
    
    @try {
        
        viewForPicker.hidden=NO;
        [self fetchCardtype:sender];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)fetchCardtype:(UIButton *)btnCardType
{
    
}
- (IBAction)btnProceedPressed:(id)sender
{
    @try{
        [self.view endEditing:TRUE];
        BOOL isValid=true;
        if (![Validations checkMinLength:self.txtCardNumber.text withLimit:16 ]) {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtCardNumber];
            [self.view makeToast:ERROR_CARDNUMBER];
            return;
        }
        else if(![Validations checkCvvNumber:self.txtCVVNumber.text withLimit:3 ])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtCVVNumber];
            [self.view makeToast:ERROR_CCVNUMBER];
            return;
        }
        else if([Validations isValidText:self.txtCardName.text])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtCardName];
            [self.view makeToast:ERROR_CARDNAME];
            return;
        }
        else if([Validations isEmpty:self.txtExpiredMonth.text])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtExpiredMonth];
            [self.view makeToast:ERROR_MONTHEXPIRED];
            return;
            
        }
        else if([Validations isEmpty:self.txtExpiredYear.text])
        {
            isValid=false;
            [OBJGlobal makeTextFieldBorderRed:self.txtExpiredYear];
            return;
            [self.view makeToast:ERROR_YEAREXPIRED];
        }
        
        
        //Encryption Code
        NSString *strTemp = GETOBJECT(@"EmailID");
        NSRange range = [strTemp rangeOfString:@"@"];
        
        NSString *key = [strTemp substringWithRange:NSMakeRange(0, range.location)];
        
        NSLog(@"%@",key);
        NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"-"];
        NSString *result = [[txtCardNumber.text componentsSeparatedByCharactersInSet:trim] componentsJoinedByString:@""];
        
        NSString *strCardNumber = [NSString stringWithFormat:@"%@",result];
        
        strEncryptedData = [AESCrypt encrypt:strCardNumber password:key];
        NSLog(@"HaxString:%@",strEncryptedData);
        
        //Decryption
        NSString *strDecrypedData = [AESCrypt decrypt:strEncryptedData password:key];
        NSLog(@"Decrypted: %@", strDecrypedData);
        
        [self paymentProcessing];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    @try{
        
        if(textField==self.txtCardType)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCardType];
        }
        else if (textField==self.txtCardNumber)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCardType];
            
        }
        else if (textField==self.txtCVVNumber)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCardNumber];
        }
        else if (textField==self.txtCardName)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCVVNumber];
        }
        else if (textField==self.txtExpiredMonth)
        {
            [OBJGlobal makeTextFieldNormal:self.txtCardName];
        }
        else if (textField==self.txtExpiredYear)
        {
            [OBJGlobal makeTextFieldNormal:self.txtExpiredMonth];
        }
        if (textField==self.txtExpiredYear)
        {
            [OBJGlobal makeTextFieldNormal:self.txtExpiredYear];
        }
        
        //        txtCardType.text = @"";
        return YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnCancelPressed:(id)sender {
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[MyKartViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            break;
        }
    }
}

-(void)paymentProcessing{
    @try{
        
        [APPDATA showLoader];
        
        Users *objPayment = OBJGlobal.user;
        objPayment.cardType=[[NSString stringWithFormat:@"%@",strCardType] mutableCopy];
        objPayment.cardNumber=[[NSString stringWithFormat:@"%@",strEncryptedData] mutableCopy];
        objPayment.cardOwnerName=[[NSString stringWithFormat:@"%@",txtCardName.text] mutableCopy];
        objPayment.cvv=[[NSString stringWithFormat:@"%@",txtCVVNumber.text] mutableCopy];
        objPayment.expiryMonth=[[NSString stringWithFormat:@"%@",txtExpiredMonth.text] mutableCopy];
        objPayment.expiryYear=[[NSString stringWithFormat:@"%@",txtExpiredYear.text] mutableCopy];
        objPayment.storeCard=[[NSString stringWithFormat:@"%i",storeCard] mutableCopy];
        
        
        [objPayment paymentProcessing:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                 OBJGlobal.isCardlistNill=false;
                MyOrdesViewController *objMyOrdesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdesViewController"];
                [self.navigationController pushViewController:objMyOrdesViewController animated:NO];
                
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"success");
                [APPDATA hideLoader];
                
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try{
        
        if(txtCardNumber.text.length!=0)
            [self cardType:txtCardNumber.text];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
    
}
-(void)cardType:(NSString *)card{
    @try{
        
        NSString *firstLetter = [card substringToIndex:1];
        NSString *tempSecondLetter =[card substringFromIndex:1];
        NSString *secondLetter =[tempSecondLetter substringToIndex:1];
        NSUInteger strDiscover = [[card substringToIndex:8]integerValue ];
        NSString *cardNumber = card;
        
        if ([cardNumber length]-3==13|| [cardNumber length]-3==16){
            if ([firstLetter isEqualToString:@"4"])
            {
                imgCardType.image = [UIImage imageNamed:@"Visa"];
                strCardType = @"VI";
                
            }
        }
        
        if ([cardNumber length]-3==16) {
            if ([firstLetter isEqualToString:@"5"]) {
                if ([secondLetter isEqual:@"1"] ||[secondLetter isEqual:@"2"] || [secondLetter isEqual:@"3"] || [secondLetter isEqual:@"4"] || [secondLetter isEqual:@"5"]) {
                    
                    imgCardType.image = [UIImage imageNamed:@"MasterCard"];
                    strCardType = @"MC";
                }
            }
            
        }
        if ([cardNumber length]-3==15) {
            if ([firstLetter isEqualToString:@"3"]) {
                if ([secondLetter isEqual:@"4"] ||[secondLetter isEqual:@"7"]) {
                    
                    imgCardType.image = [UIImage imageNamed:@"AmericanExpress"];
                    strCardType = @"AE";
                }
            }
        }
        
        if ([firstLetter isEqualToString:@"6"]){
            if ((strDiscover >= 6011-0000 || strDiscover <=6011-9999) || (strDiscover >= 6500-0000 || strDiscover <= 6599-9999) || (strDiscover >=6221-2600 || strDiscover <= 6229-2599)) {
                if([cardNumber length]-3==16)
                {
                    imgCardType.image = [UIImage imageNamed:@"Discover"];
                    strCardType = @"DI";
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

@end

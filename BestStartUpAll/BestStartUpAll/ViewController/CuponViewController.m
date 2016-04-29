//
//  CuponViewController.m
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CuponViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"


@interface CuponViewController ()<UITextFieldDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    BOOL isCouponApplied;
    NSMutableArray *aryCuponCodeData;
    
}
@end

@implementation CuponViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        isCouponApplied=false;
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        _lblTotal.text = [OBJGlobal.pointsTotal mutableCopy];
        self.txtCouponCode.delegate=self;
        [OBJGlobal setTextFieldWithSpace:self.txtCouponCode];
        
        _lblTotal.text=_strTotal;
        _lblDiscount.text=_strDiscount;
        _lblGrantTotal.text=_strGrantTotal;
        
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
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Coupon";
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

-(void)CouponCodeMethod
{
    @try{
        [APPDATA showLoader];
        Users *objCouponCode=[[Users alloc]init];
        objCouponCode.flag = [self.strFlag=@"add" mutableCopy];
        objCouponCode.coupon_code=[_txtCouponCode.text mutableCopy];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] )
        {
            
            objCouponCode.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        objCouponCode.flag=[[NSString stringWithFormat:@"%@",@"add"] mutableCopy];
        [objCouponCode coupons:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 isCouponApplied=true;
                 aryCuponCodeData = [[NSMutableArray alloc]init];
                 if([[user allKeys] containsObject:@"total"]){
                     
                     aryCuponCodeData = [[NSMutableArray alloc] initWithArray:[user valueForKey:@"total"]];
                     [aryCuponCodeData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSDictionary *dictAmount = [aryCuponCodeData objectAtIndex:idx];
                         NSString *strAmount;
                         if([OBJGlobal isNotNull:[dictAmount valueForKey:@"amount"]])
                             strAmount = [dictAmount valueForKey:@"amount"];
                         else
                             strAmount=@"0.0";
                         NSString *strTitle = [dictAmount valueForKey:@"title"];
                         
                         float fAmt = [strAmount floatValue];
                         strAmount = [NSString stringWithFormat:@"%.2f",fAmt];
                         
                         
                         if([strTitle containsString:@"Subtotal"])
                             _lblTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                         if([strTitle containsString:@"Shipping & Handling (Flat Rate - Fixed)"])
                             _lblShippingTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                         if([strTitle containsString:@"Discount (TEST100)"])
                             _lblDiscount.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                         if([strTitle containsString:@"Grand Total"])
                             _lblGrantTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                         
                     }];
                 }
                 if([[user allKeys] containsObject:@"msg"])
                     [self.view makeToast:[user valueForKey:@"msg"]];
                 
                 NSLog(@"success");
                 [APPDATA hideLoader];
                 
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

- (IBAction)btnCalculatePressed:(id)sender
{
    @try{
        [self.view endEditing:TRUE];
        BOOL isValid=true;
        if ([Validations isEmpty:self.txtCouponCode.text]) {
            isValid=false;
            
            [OBJGlobal makeTextFieldBorderRed:self.txtCouponCode];
            [self.view makeToast:ERROR_CODE];
            return;
        }
        
        if (isValid == TRUE)
        {
            if(GETBOOL(@"isUserHasLogin")==true){
                [self CouponCodeMethod];
                
            }
            else{
                [self.view makeToast:@"Please login and add the product to cart"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (IBAction)btnContinuePressed:(id)sender {
    @try{
        [self.view endEditing:true];
        if(GETBOOL(@"isUserHasLogin")==true){
            
            if(isCouponApplied)
                [self popToPreviousController];
            else
                [self.view makeToast:@"Please apply coupon code"];
        }
        else{
            [self.view makeToast:@"Please login and add the product to cart"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)popToPreviousController
{
    [self.navigationController popViewControllerAnimated:true];
    
}
@end

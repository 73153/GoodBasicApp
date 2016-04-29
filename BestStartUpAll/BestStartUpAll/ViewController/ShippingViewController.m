//
//  ShippingViewController.m
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ShippingViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "CheckoutViewController.h"
#import "PaymentViewController.h"
#import "UIView+Toast.h"
#import "MNAutoComplete.h"
#import "ZZMainViewController.h"


@interface ShippingViewController ()
{
    Globals *OBJGlobal;
}
@end

@implementation ShippingViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        // [self loadAutocompletandLocationTable];
        _txtCommentView.placeholder = @"Address";
        _txtCommentView.backgroundColor=[UIColor clearColor];
        _txtCommentView.textColor = [UIColor blackColor];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        // label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Shipping Address";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    //  self.navigationItem.title = @"Shipping Address";
    //    SHIPPING ADDRESS
    //    if([OBJGlobal.numberOfCartItems intValue]<=0)
    //        btnBadgeCount.hidden=true;
    //    else
    //        btnBadgeCount.hidden=false;
}
//- (IBAction)btnShiptoDifferentAdreassPressed:(id)sender
//{
//    ShippingViewController *objShippingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShippingViewController"];
//    [self.navigationController pushViewController:objShippingViewController animated:NO];
//
//}
- (IBAction)btnSubmitPressed:(id)sender {
    @try{
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ZZMainViewController *objDashboardViewController = [storybord instantiateViewControllerWithIdentifier:@"ZZMainViewController"];
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
@end

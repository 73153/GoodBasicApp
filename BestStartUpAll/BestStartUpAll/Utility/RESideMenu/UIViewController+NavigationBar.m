//
//  UIViewController+NavigationBar.m
//  TOPCOD
//
//  Created by ashish on 24/06/15.
//  Copyright (c) 2015 viek. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "Constant.h"
#import "ProfileEditViewController.h"
#import "MyOrdesViewController.h"
#import "PaymentViewController.h"
#import "CheckoutViewController.h"
#import "DelivaryAddressViewController.h"
#import "CardDetailViewController.h"
#import "PaymentViewController.h"
#import "Globals.h"

@implementation UIViewController (NavigationBar)
- (void)setUpImageBackButton:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)setMenuIconForSideBar:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 40, 35)];
    [backButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //[backButton setImage:[UIImage imageNamed:@"cal-active"] forState:UIControlStateHighlighted];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}
-(UIButton*)setBadgeCount:(NSInteger)badgeCount
{
    UIButton *label =  [UIButton buttonWithType:UIButtonTypeCustom];
    [label setFrame:CGRectMake(96, 0, 32, 32)];
    [label setTitle:[NSString stringWithFormat:@"%ld",(long)badgeCount] forState:UIControlStateNormal];
    label.titleLabel.textAlignment = NSTextAlignmentCenter;
    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label.titleLabel setFont:[UIFont systemFontOfSize:100]];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 128, 32)];
    [rightBarButtonItems insertSubview:label atIndex:1000];
    //    [rightBarButtonItems addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    return label;
    
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:
    //                      CGRectMake(10,2,SCREEN_WIDTH-20,14)];
    //    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    label.text = [NSString stringWithFormat:@"%ld",(long)badgeCount];
    //    label.backgroundColor = [UIColor redColor];
    //    label.font = [UIFont systemFontOfSize:12];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    UIView *rightBarBadge = [[UIView alloc] initWithFrame:CGRectMake(32, 5, 32, 32)];
    //    [rightBarBadge addSubview:label];
    //    self.navigationItem.rightBarButtonItem = [rightBarBadge;
    //
    //    return label;
}
-(UIButton*)setUpImageSecondRightButton:(NSString *)firstImage secondImage:(NSString*)secondImage thirdImage:(NSString*)thirdImage badgeCount:(NSInteger)badgeCount
{
    UIButton *homeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setImage:[UIImage imageNamed:firstImage] forState:UIControlStateNormal];
//    UIButton *btnLeftmenu=(UIButton *)sender;
    [homeBtn setImage:[UIImage imageNamed:@"menu-active"] forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setFrame:CGRectMake(80, 0, 45, 35)];
    
    UIButton *settingsBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:[UIImage imageNamed:secondImage] forState:UIControlStateNormal];
    [settingsBtn setImage:[UIImage imageNamed:@"search-active"] forState:UIControlStateHighlighted];
    [settingsBtn addTarget:self action:@selector(presentRightMenuSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    [settingsBtn setFrame:CGRectMake(40, 0, 35, 35)];
    
    UIButton *searchBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:thirdImage] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"kart-active"] forState:UIControlStateHighlighted];

    [searchBtn addTarget:self action:@selector(pushMyKartViewController:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setFrame:CGRectMake(0, 0, 35, 35)];
    
    UIButton *label =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [label setBackgroundImage:[UIImage imageNamed:@"notifi"] forState:UIControlStateNormal];
     [label setUserInteractionEnabled: NO];
    [label setImage:[UIImage imageNamed:@"kart-active"] forState:UIControlStateHighlighted];
    
    [label setFrame:CGRectMake(12, -15, 23, 23)];
    [label addTarget:self action:@selector(pushMyKartViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [label setBackgroundColor:[UIColor redColor]];
    [label setTitle:[NSString stringWithFormat:@"%ld",(long)badgeCount] forState:UIControlStateNormal];
    label.titleLabel.textAlignment = NSTextAlignmentRight;
    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    //    [rightBarButtonItems addSubview:label];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 130, 37)];
    [rightBarButtonItems addSubview:searchBtn];
    [rightBarButtonItems addSubview:homeBtn];
    [rightBarButtonItems addSubview:settingsBtn];
    [rightBarButtonItems addSubview:label];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    return label;
}

-(UIButton*)setUpImageThirdRightButton:(NSString *)firstImage secondImage:(NSString*)secondImage thirdImage:(NSString*)thirdImage badgeCount:(NSInteger)badgeCount fouthImage:(NSString*)fouthImage
{
    UIButton *homeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setImage:[UIImage imageNamed:firstImage] forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"menu-active"] forState:UIControlStateHighlighted];

    [homeBtn addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setFrame:CGRectMake(105, 0, 35, 35)];
    
    UIButton *settingsBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:[UIImage imageNamed:secondImage] forState:UIControlStateNormal];
     [settingsBtn setImage:[UIImage imageNamed:@"search-active"] forState:UIControlStateHighlighted];
    [settingsBtn addTarget:self action:@selector(presentRightMenuSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    [settingsBtn setFrame:CGRectMake(70, 0, 35, 35)];
    
    UIButton *searchBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:thirdImage] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"kart-active"] forState:UIControlStateHighlighted];

    [searchBtn addTarget:self action:@selector(pushMyKartViewController:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setFrame:CGRectMake(35, 0, 35, 35)];
    
    UIButton *label =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [label setBackgroundImage:[UIImage imageNamed:@"notifi"] forState:UIControlStateNormal];
    [label setImage:[UIImage imageNamed:@"kart-active"] forState:UIControlStateHighlighted];

    
    [label addTarget:self action:@selector(pushMyKartViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [label setFrame:CGRectMake(46, -14, 23, 23)];
    //    [label setBackgroundColor:[UIColor redColor]];
    [label setTitle:[NSString stringWithFormat:@"%ld",(long)badgeCount] forState:UIControlStateNormal];
    label.titleLabel.textAlignment = NSTextAlignmentLeft;
    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    //    [rightBarButtonItems addSubview:label];
    
    UIButton *brandListBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [brandListBtn setImage:[UIImage imageNamed:fouthImage] forState:UIControlStateNormal];
    [brandListBtn addTarget:self action:@selector(showTheBrandListPopUp:) forControlEvents:UIControlEventTouchUpInside];
    [brandListBtn setFrame:CGRectMake(0, 0, 35, 35)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 128, 35)];
    [rightBarButtonItems addSubview:searchBtn];
    [rightBarButtonItems addSubview:homeBtn];
    [rightBarButtonItems addSubview:settingsBtn];
    [rightBarButtonItems addSubview:label];
    [rightBarButtonItems addSubview:brandListBtn];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    return label;
}


- (void)setUpImageProfileEditButton:(NSString *)imageName
{
    UIButton *ProfileEditButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ProfileEditButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [ProfileEditButton addTarget:self action:@selector(ProfileEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [ProfileEditButton setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightBarButtonItems addSubview:ProfileEditButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
}

- (void)setUpImageRightButtonWithText:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(-35.0, 0.0, 0.0,-90)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [backButton setTitle:@"Log Out" forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(OnbtnLogOutTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barBackButtonItem;
}

-(void)OnbtnLogOutTapped {
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignInVC"];
    UINavigationController *naviCtrl = [[UINavigationController alloc]initWithRootViewController:rootController];
    naviCtrl.navigationBar.barTintColor = [UIColor clearColor];
    naviCtrl.navigationBar.translucent = NO;
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdel.window.rootViewController = naviCtrl;
}

- (void)popCurrentViewController
{
    Globals *OBJGlobal = [Globals sharedManager];

    NSArray *controllers = [self.navigationController viewControllers];
    
    if ([[controllers lastObject] isKindOfClass:[MyOrdesViewController class]] ) {
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
   else if ([[controllers lastObject] isKindOfClass:[CheckoutViewController class]] ) {
       if (OBJGlobal.isDeliveryAddressListNill==TRUE) {
           [self.navigationController popToRootViewControllerAnimated:TRUE];
       }
       else{
           [self.navigationController popViewControllerAnimated:YES];
       }
       
    }
   else if ([[controllers lastObject] isKindOfClass:[PaymentViewController class]] ) {
       if (OBJGlobal.isCardlistNill==TRUE) {
           [self.navigationController popToRootViewControllerAnimated:TRUE];
       }
       else{
           [self.navigationController popViewControllerAnimated:YES];
       }
       
   }

    else
        [self.navigationController popViewControllerAnimated:YES];
    
}




@end

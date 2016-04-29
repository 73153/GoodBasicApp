//
//  ReferInviteFriendViewController.m
//  peter
//
//  Created by Peter on 4/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ReferInviteFriendViewController.h"
#import "Globals.h"
#import "UIViewController+NavigationBar.h"
#import "UIView+Toast.h"
#import "Users.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"

@interface ReferInviteFriendViewController ()
{
    Globals *OBJGlobal;
    NSArray *aryRefferalData;
}

@end

@implementation ReferInviteFriendViewController
@synthesize scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    OBJGlobal = [Globals sharedManager];
    [self setUpImageBackButton:@"left-arrow"];
    scrollView.contentOffset = CGPointMake(0, 0);
    
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
        label.text = @"Refer/Invite Friend";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)referralMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            Users *objRefferal = OBJGlobal.user;
            objRefferal.Email = [self.txtFriendsEmail.text mutableCopy];
            
            objRefferal.msg=[self.txtComment.text mutableCopy];
            
            [APPDATA showLoader];
            [objRefferal referral:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                     
                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
                     
                     [APPDATA hideLoader];
                     
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please login to view all address"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



- (IBAction)btnSendEmailPressed:(id)sender {
    @try{
        [self.view endEditing:true];
        [self referralMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
@end

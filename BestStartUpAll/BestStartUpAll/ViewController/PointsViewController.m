//
//  PointsViewController.m
//  peter
//
//  Created by Peter on 1/18/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PointsViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "Globals.h"
#import "CommonPopUpView.h"
#import "UIView+Toast.h"
#import "ReferInviteFriendViewController.h"
#import "PointsTableViewCell.h"

@interface PointsViewController ()
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    Users *objReferPoints;
    
}
@end

@implementation PointsViewController
@synthesize tableView,lblNoAddress;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        objReferPoints=OBJGlobal.user;
        [self setUpImageBackButton:@"left-arrow"];
        [self referPointsMethod];
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
        label.text = @"Points";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnInvitefriendPressed:(id)sender {
    @try{
        ReferInviteFriendViewController *objReferInviteFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferInviteFriendViewController"];
        [self.navigationController pushViewController:objReferInviteFriendViewController animated:NO];
        
        //        NSString *strpeterUrl = @"http://216.55.169.45/~peter/master/index.php/zipcode_availability";
        //
        //        NSString *addCommentStr;
        //        NSArray *ary;
        //        ary =[[NSArray alloc] initWithObjects:addCommentStr,nil];
        //
        //        addCommentStr=  [NSString stringWithFormat:@"%@ \n %@",@"Shared via Pantry Kart",strpeterUrl];
        //        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:ary applicationActivities:nil];
        //
        //        NSArray *excludeActivities = @[UIActivityTypeMessage,
        //                                       UIActivityTypeMail,
        //                                       UIActivityTypePrint,
        //                                       UIActivityTypeCopyToPasteboard,
        //                                       UIActivityTypeAssignToContact,
        //                                       UIActivityTypeSaveToCameraRoll,
        //                                       UIActivityTypeAddToReadingList,
        //                                       UIActivityTypePostToFlickr,
        //                                       UIActivityTypePostToVimeo,
        //                                       UIActivityTypePostToTencentWeibo,
        //                                       UIActivityTypeAirDrop,
        //                                       ];
        //        NSArray *excludeActivities = @[];
        //        [activityViewController setValue:addCommentStr forKey:@"subject"];
        //        activityViewController.excludedActivityTypes = excludeActivities;
        //        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        //            NSLog(@"completed");
        //            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        //        }];
        //
        //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //            [self presentViewController:activityViewController animated:YES completion:nil];
        //        }
        //        //if iPad
        //        else {
        //            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        //
        //            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //            // Change Rect to position Popover
        //            //            UIPopoverPresentationController *popPC = activityViewController.popoverPresentationController;
        //            //            popPC.barButtonItem = self.navigationItem.rightBarButtonItem;
        //            //            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //            //            [self presentViewController:activityViewController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)referPointsMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            [APPDATA showLoader];
            [objReferPoints referPoints:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                     
                     aryPoints =[user objectForKey:@"data"];
                     
                     _lblPoints.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"reward_money"]];
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



#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [aryTransactionHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    @try
    {
        static NSString *CellIdentifier = @"PointsTableViewCell";
        
        PointsTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PointsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        dict = [aryTransactionHistory objectAtIndex:indexPath.row];
        
        return cell;
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

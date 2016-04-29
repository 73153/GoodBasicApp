
//
//  MyOrdesViewController.m
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "MyOrdesViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "CommonPopUpView.h"
#import "UIView+Toast.h"
@interface MyOrdesViewController ()
{
    Globals *OBJGlobal;
    Users *objorderHistory;
    UIButton *btnBadgeCount;
    NSString *strEntity_ID;
}
@end

@implementation MyOrdesViewController
@synthesize tableView,lblNoOrderData;
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        objorderHistory=[[Users alloc]init];
        [self setUpImageBackButton:@"left-arrow"];
        [self orderHistoryMethod];
        lblNoOrderData.hidden=true;
        strEntity_ID = [[NSString alloc]init];
        //        lblNoOrderData.hidden=true;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [aryOrderHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    @try
    {
        static NSString *CellIdentifier = @"MyOrderTableViewCell";
        
        MyOrderTableViewCell *cell = (MyOrderTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *dict = [[NSDictionary alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        dict = [aryOrderHistory objectAtIndex:indexPath.row];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        if([OBJGlobal isNotNull:[dict valueForKey:@"order_date"]])
        {
            NSString *StrTemp = [NSString stringWithFormat:@"%@",[dict valueForKey:@"order_date"]];
            //Date Foramtting
            NSArray *substrings = [StrTemp componentsSeparatedByString:@" "];
            NSString *strDate = [substrings objectAtIndex:0];
            NSString *strTime = [substrings objectAtIndex:1];
            
            //Date Formatter
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:strDate];
            [dateFormat setDateFormat:@"MMMM dd, YYYY"];
            strDate = [dateFormat stringFromDate:date];
            
            //Time Formatter
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"HH:mm:ss"];
            NSDate *time = [timeFormat dateFromString:strTime];
            
            // Convert date object to desired output format
            [timeFormat setDateFormat:@"hh:mm a"];
            strTime = [timeFormat stringFromDate:time];
            
            NSString *strFinalDateTime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
            cell.lblDate.text = strFinalDateTime;
        }
        
        if([OBJGlobal isNotNull:[NSString stringWithFormat:@"%@",[dict valueForKey:@"order_id"]]])
            cell.lblOrderNumber.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"order_id"]];
        
        if([OBJGlobal isNotNull:[dict valueForKey:@"order_name"]])
            cell.lblOrderName.text=[dict valueForKey:@"order_name"];
        
        if([OBJGlobal isNotNull:[dict valueForKey:@"order_total"]]){
            NSString *strPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"order_total"]];
            float price = [strPrice floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
            
        }
        
        cell.btnReOrder.tag=indexPath.row+1200;
        //        cell.accessoryView = cell.btnReOrder;
        [cell.btnReOrder addTarget:self action:@selector(reOrderProcessing:) forControlEvents:UIControlEventTouchUpInside];
        
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
    @try{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        MyOrderDetailViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderDetailViewController"];
        
        objDashboardViewController.orderId=[[aryOrderHistory objectAtIndex:indexPath.row] valueForKey:@"order_id"];
        
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
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
    [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines =0;
    label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
    label.text = @"My Orders";
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}

-(void)orderHistoryMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            [APPDATA showLoader];
            [objorderHistory orderHistory:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                     if([OBJGlobal isNotNull:[user objectForKey:@"data"]]){
                         lblNoOrderData.hidden=true;
                         self.tableView.hidden=false;
                         aryOrderHistory = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                         OBJGlobal.aryKartDataGlobal=nil;
                         OBJGlobal.dictLastKartProduct=nil;
                         [self.tableView reloadData];
                         
                      
                         [APPDATA hideLoader];
                     }
                     else{
                         lblNoOrderData.hidden=false;
                         self.tableView.hidden=true;
                         lblNoOrderData.lineBreakMode=NSLineBreakByWordWrapping;
                         lblNoOrderData.numberOfLines=0;
                         lblNoOrderData.text = @"NO Orders Yet";
                     }
                     
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
                     NSLog(@"Failed");
                     
                     lblNoOrderData.hidden=false;
                     self.tableView.hidden=true;
                     lblNoOrderData.lineBreakMode=NSLineBreakByWordWrapping;
                     lblNoOrderData.numberOfLines=0;
                     lblNoOrderData.text = @"NO Orders Yet";
                     
                     [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            lblNoOrderData.hidden=false;
            self.tableView.hidden=true;
            lblNoOrderData.lineBreakMode=NSLineBreakByWordWrapping;
            lblNoOrderData.numberOfLines=0;
            lblNoOrderData.text = @"Please Login";
            [self.view makeToast:@"Please login to view all orders"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)reOrderProcessing:(id)sender{
    
    @try{
        UIButton *btnReoder = (UIButton*)sender;
        NSInteger btnTag = btnReoder.tag-1200;
        
        strEntity_ID = [[aryOrderHistory objectAtIndex:btnTag] valueForKey:@"entity_id"];
        [APPDATA showLoader];
        
        Users *objReorder = OBJGlobal.user;
        objReorder.entity_id=[[NSString stringWithFormat:@"%@",strEntity_ID] mutableCopy];
        
        
        [objReorder reOrder:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                
                //if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                [self.view makeToast:@"Your Reorder is placed successfully."];
                OBJGlobal.isFirstTimeFetchKartData = false;
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


@end

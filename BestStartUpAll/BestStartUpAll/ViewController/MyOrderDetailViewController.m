//
//  MyOrderDetailViewController.m
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"

#import "MyOrderDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
//#import "ImageWithURL.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface MyOrderDetailViewController ()
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    NSMutableArray *aryOrderDetailItems;
}
@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        [self orderDetailMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        aryOrderDetailItems = [[NSMutableArray alloc] init];
        aryOrderDetail = [[NSMutableArray alloc] init];
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        
        label.numberOfLines = 0;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.text = _orderId;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


#pragma mark -tbleView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryOrderDetailItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        NSString *CellIdentifier = @"MyOrderDetailTableViewCell";
        MyOrderDetailTableViewCell *cell = (MyOrderDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MyOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = [aryOrderDetailItems objectAtIndex:indexPath.row];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if([OBJGlobal isNotNull:[dict valueForKey:@"base_price"]])
            cell.lblPrice.text = [dict valueForKey:@"base_price"];
        
        if([OBJGlobal isNotNull:[dict valueForKey:@"name"]])
            cell.lblName.text = [dict valueForKey:@"name"];
        
        if([OBJGlobal isNotNull:[NSString stringWithFormat:@"%@",[dict valueForKey:@"weight"]]])
            cell.lblWeight.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"weight"]];
        
        
        if([OBJGlobal isNotNull:[dict valueForKey:@"qty"]]){
            NSString *strQty =[NSString stringWithFormat:@"%@",[dict valueForKey:@"qty"]];
            int price1 = [strQty intValue];
            cell.lblQuantity.text = [NSString stringWithFormat:@"Qty:%d",price1];
        }
        if([OBJGlobal isNotNull:[dict valueForKey:@"price"]]){
            NSString *strPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
            float price = [strPrice floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
            
        }
        if ([[dict allKeys] containsObject:@"imageurl"]) {
            
            NSString *str = [dict valueForKey:@"imageurl"];
            if(str.length>0)
                [cell.imgOrderImage setContentMode:UIViewContentModeScaleAspectFit];
            cell.imgOrderImage.tag=indexPath.row+40034;
            UIImageView *imageView1 = (UIImageView *)[cell.imgOrderImage viewWithTag:indexPath.row+40034];
            
            if(str.length>0)
            {
                if(imageView1){
                    
                    imageView1.tag=indexPath.row+40034;
                    imageView1.clipsToBounds = YES;
                    imageView1.contentMode =UIViewContentModeScaleAspectFit;
                    [imageView1 setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
            }
            
        }
        
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)orderDetailMethod
{
    @try{
        [APPDATA showLoader];
        Users *objorderDetail=[[Users alloc]init];
        objorderDetail.orderid=[self.orderId mutableCopy];
        [objorderDetail orderDetail:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 
                 NSDictionary *responseDict = [user objectForKey:@"data"];
                 aryOrderDetail =[user objectForKey:@"data"];
                 //Date Formatting Start
                 NSString *StrTemp = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"details"] valueForKey:@"order_date"]];
                 //Date Foramtting
                 NSArray *substrings = [StrTemp componentsSeparatedByString:@" "];
                 NSString *strDate = [substrings objectAtIndex:0];
                 NSString *strTime = [substrings objectAtIndex:1];
                 
                 // Convert string to date object
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 [dateFormat setDateFormat:@"yyyy-MM-dd"];
                 NSDate *date = [dateFormat dateFromString:strDate];
                 
                 // Convert date object to desired output format
                 [dateFormat setDateFormat:@"MMMM dd, YYYY"];
                 strDate = [dateFormat stringFromDate:date];
                 NSString *strFinalDateTime = [NSString stringWithFormat:@"%@ %@",strDate,strTime];
                 self.lblOrderDate.text = strFinalDateTime;
                 //End
                 
                 self.lblTotalAmount.text = [[responseDict valueForKey:@"details"] valueForKey:@""];
                 self.lblOrderId.text = [[responseDict valueForKey:@"details"] valueForKey:@"order_id"];
                 
                 
                 if([OBJGlobal isNotNull:[[user objectForKey:@"data"]valueForKey:@"total"]]){
                     NSString *strPrice =[[user objectForKey:@"data"]valueForKey:@"total"];
                     float price = [strPrice floatValue];
                     self.lblTotalAmount.text = [NSString stringWithFormat:@"$%.2f",price];
                     
                 }
                 
                 aryOrderDetailItems = [[responseDict valueForKey:@"items"] mutableCopy];
                 
                 NSDictionary *dictAddress = [responseDict valueForKey:@"billing"] ;
                 
                 self.lblDeliveryAddress.numberOfLines = 0;
                 self.lblDeliveryAddress.lineBreakMode=NSLineBreakByWordWrapping;
                 
                 NSString *strAddress = [NSString stringWithFormat:@"%@ %@, \n%@,\n%@ %@, \n%@,%@, %@ \n%@",
                                         [dictAddress valueForKey:@"firstname"],
                                         [dictAddress valueForKey:@"lastname"],
                                         [dictAddress valueForKey:@"street"],
                                         [dictAddress valueForKey:@"region"],
                                         [dictAddress valueForKey:@"city"],
                                         [dictAddress valueForKey:@"country_id"],
                                         [dictAddress valueForKey:@"postcode"],
                                         [dictAddress valueForKey:@"telephone"],
                                         [dictAddress valueForKey:@"fax"]];
                 self.lblDeliveryAddress.text = strAddress;
                 [self.tableView reloadData];
                 [APPDATA hideLoader];
                 
                 NSLog(@"success");
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

@end

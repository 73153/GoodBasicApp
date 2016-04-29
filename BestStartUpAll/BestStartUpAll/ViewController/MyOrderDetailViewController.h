//
//  MyOrderDetailViewController.h
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"
#import "MyOrderDetailTableViewCell.h"

@interface MyOrderDetailViewController : UIViewController
{
    NSMutableArray *aryOrderDetail;
}

@property NSString *orderId;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)orderDetailMethod;

@end

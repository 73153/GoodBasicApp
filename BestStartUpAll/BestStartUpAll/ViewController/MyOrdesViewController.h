//
//  MyOrdesViewController.h
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface MyOrdesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *aryOrderHistory;
}
@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOrderData;

-(void)orderHistoryMethod;
-(void)reOrderProcessing:(id)sender;
//-(void)dateFormatter:(NSMutableArray *)date;

@end

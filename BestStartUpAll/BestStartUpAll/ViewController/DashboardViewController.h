//
//  DashboardViewController.h
//  peter
//
//  Created by Peter on 12/28/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpTableViewController.h"
#import "DashboardCell.h"

@interface DashboardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
}
@property (nonatomic, strong) PopUpTableViewController *objPopUpTableController;
@property (weak, nonatomic) IBOutlet UIView *popUpItemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *popUpImage;
@property (weak, nonatomic) IBOutlet UILabel *popUpImageName;
@property (weak, nonatomic) IBOutlet UILabel *popUpItemPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPopUpItemDescription;
@property (weak, nonatomic) IBOutlet UIView *roundedPopUpView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)reloadCartData:(NSDictionary*)dictResult;

@end

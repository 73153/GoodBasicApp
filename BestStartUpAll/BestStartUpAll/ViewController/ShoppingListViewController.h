//
//  ShoppingListViewController.h
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListViewController : UIViewController
{
    NSMutableArray *aryViewShopping;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoShippingData;

-(IBAction)continueShopingTapped:(UIButton*)sender;

@end

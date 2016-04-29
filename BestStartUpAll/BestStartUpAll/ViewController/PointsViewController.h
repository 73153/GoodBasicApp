//
//  PointsViewController.h
//  peter
//
//  Created by Peter on 1/18/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface PointsViewController : UIViewController
{
    NSMutableArray *aryPoints;
    NSMutableArray *aryTransactionHistory;
}

@property (weak, nonatomic) IBOutlet UILabel *lblPoints;
@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoAddress;

- (IBAction)btnInvitefriendPressed:(id)sender;

-(void)referPointsMethod;

@end

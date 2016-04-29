//
//  MyOrderTableViewCell.h
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnReOrder;

@end

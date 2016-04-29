//
//  MyOrderDetailTableViewCell.h
//  peter
//
//  Created by Peter on 2/3/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *imgOrderImage;
@property (weak, nonatomic) IBOutlet UIButton *btnReOrder;

@end

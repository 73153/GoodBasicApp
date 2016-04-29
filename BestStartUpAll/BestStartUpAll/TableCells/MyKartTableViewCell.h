//
//  MyKartTableViewCell.h
//  peter
//
//  Created by Peter on 1/27/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyKartTableViewCell : UITableViewCell

@property int numberOfProducts;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (nonatomic, weak) IBOutlet UILabel *stepperLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfKartItems;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrignoalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;


@end

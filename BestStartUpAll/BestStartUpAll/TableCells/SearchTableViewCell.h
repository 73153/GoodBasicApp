//
//  SearchTableViewCell.h
//  peter
//
//  Created by Peter on 1/27/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageWithURL.h"

@interface SearchTableViewCell : UITableViewCell

@property NSInteger numberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrignoalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfKartItems;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnMyKart;
@property (weak, nonatomic) IBOutlet UIButton *btnAddtoFavourite;

@end

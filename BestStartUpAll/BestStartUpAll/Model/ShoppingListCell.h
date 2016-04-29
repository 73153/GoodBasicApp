//
//  ShoppingList.h
//  peter
//
//  Created by Peter on 12/25/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShoppingListCell : UITableViewCell

@property NSInteger numberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfKartItems;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrignoalPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToFavourite;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@end

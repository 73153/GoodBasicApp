//
//  SubcategoryCell.h
//  CollectionView
//
//  Created by KoKang Chu on 12/8/26.
//  Copyright (c) 2012年 KoKang Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SubcategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnPlacerequest;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrignoalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UIImageView *imgProductbadge;
@property (weak, nonatomic) IBOutlet UILabel *lblBadgeCount;
@property (weak, nonatomic) IBOutlet UIView *viewWhiteForImageBG;
@end

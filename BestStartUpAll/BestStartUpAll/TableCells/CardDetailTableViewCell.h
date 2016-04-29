
//
//  CardDetailTableViewCell.h
//  peter
//
//  Created by Peter on 3/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCardType;
@property (weak, nonatomic) IBOutlet UILabel *lblCardMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblCardyear;
@property (weak, nonatomic) IBOutlet UILabel *lblCardName;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateCard;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteCard;
@property (weak, nonatomic) IBOutlet UIButton *btnCardSelection;

@end

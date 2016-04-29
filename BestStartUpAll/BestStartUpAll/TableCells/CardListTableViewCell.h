//
//  CardListTableViewCell.h
//  peter
//
//  Created by Peter on 3/21/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardListTableViewCell : UITableViewCell


@property (nonatomic,strong) IBOutlet UILabel *lblCardNumber;
@property (nonatomic,strong) IBOutlet UILabel *lblExp;
@property (nonatomic,strong) IBOutlet UILabel *lblMonth;
@property (nonatomic,strong) IBOutlet UILabel *lblCardType;
@property (nonatomic,strong) IBOutlet UIButton *btnSelectCard;
@property (nonatomic,strong) IBOutlet UIButton *btnDelete;

@end

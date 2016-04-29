//
//  PointsTableViewCell.h
//  peter
//
//  Created by Peter on 4/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblCredit;
@property (nonatomic,strong) IBOutlet UILabel *lblDate;
@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (nonatomic,strong) IBOutlet UIImageView *imgWallet;
@property (nonatomic,strong) IBOutlet UILabel *lblCity;
@property (nonatomic,strong) IBOutlet UILabel *lblState;
@property (nonatomic,strong) IBOutlet UILabel *lblZipCode;
@property (nonatomic,strong) IBOutlet UIButton *btnSelectaddres;
@property (nonatomic,strong) IBOutlet UIButton *btnDelete;
@property (nonatomic,strong) IBOutlet UIButton *btnUpdate;



@end

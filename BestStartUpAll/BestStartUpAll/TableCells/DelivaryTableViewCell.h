//
//  DelivaryTableViewCell.h
//  peter
//
//  Created by Peter on 3/2/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelivaryTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblFirstName;
@property (nonatomic,strong) IBOutlet UILabel *lblLastName;
@property (nonatomic,strong) IBOutlet UILabel *lblStreetAdress;
@property (nonatomic,strong) IBOutlet UILabel *lblApt;
@property (nonatomic,strong) IBOutlet UILabel *lblCity;
@property (nonatomic,strong) IBOutlet UILabel *lblState;
@property (nonatomic,strong) IBOutlet UILabel *lblZipCode;
@property (nonatomic,strong) IBOutlet UIButton *btnSelectaddres;
@property (nonatomic,strong) IBOutlet UIButton *btnDelete;
@property (nonatomic,strong) IBOutlet UIButton *btnUpdate;



@end

//
//  MyaccountViewController.h
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface MyaccountViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (nonatomic,strong) IBOutlet UILabel *lblEmail;
@property (nonatomic,strong) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblLastAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblLastOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblLastAccount;

- (IBAction)btnViewAllOrdersPressed:(id)sender;
- (IBAction)btnViewAllAddressPressed:(id)sender;
- (IBAction)btnEditAddressPressed:(id)sender;
@end

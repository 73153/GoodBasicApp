//
//  CuponViewController.h
//  peter
//
//  Created by Peter on 1/13/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface CuponViewController : UIViewController

@property NSString *strFlag;
@property NSString *strTotal;
@property NSString *strDiscount;
@property NSString *strGrantTotal;
@property NSString *strShipping;

@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lblGrantTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblShippingTotal;
@property (strong, nonatomic) IBOutlet UITextField *txtCouponCode;

- (IBAction)btnContinuePressed:(id)sender;
- (IBAction)btnCalculatePressed:(id)sender;

@end

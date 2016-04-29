//
//  MyKartViewController.h
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"
#import "UIViewController+RESideMenu.h"

@interface MyKartViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIButton *btnApplyCoupon;
@property (nonatomic,strong) IBOutlet UIButton *btnCheckOut;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblCouponPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblShipping;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblNoKartData;
@property (weak, nonatomic) IBOutlet UILabel *lblPayableTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblAddMore;

- (IBAction)btnPayFromWalletPressed:(id)sender;
- (IBAction)btnApplyCouponPressed:(id)sender;
- (IBAction)btnCheckOutPressed:(id)sender;

-(void)myCartMethod;
-(void)btnMinusPressed:(id)sender;
-(void)btnPlusPressed:(id)sender;
-(void)btnDeletePressed:(id)sender;

@end

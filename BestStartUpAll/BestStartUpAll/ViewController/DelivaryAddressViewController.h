//
//  DelivaryAddressViewController.h
//  peter
//
//  Created by Peter on 3/2/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface DelivaryAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *aryDeliveryList;
    NSMutableArray *aryCheckoutData;
    NSString *straddress_id;
    NSString *straddress_Delete;
    
}

@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (nonatomic,strong)  NSString *strmyaccountAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblNoAddress;
@property (nonatomic,strong) IBOutlet UIButton *btnContinue;

- (IBAction)btnNewAdreassPressed:(id)sender;
- (IBAction)btnContinuePressed:(id)sender;

-(void)checkOutAddressDeleteMethod:(NSInteger)index;
-(void)deliveryAddressmethod;

@end

//
//  CardDetailViewController.h
//  peter
//
//  Created by Peter on 3/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *aryCardDetailList;
    NSString *strCard_id;
    NSString *strcard_Delete;
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblNoCard;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnNewCardPressed;
@property (weak, nonatomic) IBOutlet UIView *viewPayment;
@property (nonatomic,strong) IBOutlet UITextField *txtCvv;

-(IBAction)btnCancelPressed:(id)sender;
-(IBAction)btnContinuePressed:(id)sender;
-(IBAction)btnProceedPayment:(id)sender;
-(IBAction)btnNewCardPressed:(id)sender;

-(void)cardListMethod;
-(void)cardListMethodDeleteMethod:(NSInteger)index;
-(void)paymentProceedCard;

@end

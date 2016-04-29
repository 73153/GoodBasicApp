//
//  PaymentViewController.h
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"


@interface PaymentViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property BOOL storeCard;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtCardType;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtCVVNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtExpiredMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtExpiredYear;
@property (weak, nonatomic) IBOutlet UITextField *txtCardName;
@property (weak,nonatomic) IBOutlet UIButton *btnMonthPressed;
@property (weak,nonatomic) IBOutlet UIButton *btnYearPressed;
@property (weak, nonatomic) IBOutlet UIButton *btnCardSave;
@property (weak, nonatomic) IBOutlet UIImageView *imgCardType;

- (IBAction)btnCardSave:(id)sender;
- (IBAction)btnCardTypePressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
- (IBAction)btnMonthPressed:(id)sender;
- (IBAction)btnYearPressed:(id)sender;
- (IBAction)btnProceedPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;

-(void)fetchCardtype:(UIButton *)btnCardType;
-(void)fetchYear;
-(void)fetchMonth:(UIButton*)btnMonth;
-(void)paymentProcessing;
-(void)cardType:(NSString *)card;

@end

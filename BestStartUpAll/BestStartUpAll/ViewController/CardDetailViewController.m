//
//  CardDetailViewController.m
//  peter
//
//  Created by Peter on 3/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CardDetailViewController.h"
#import "Globals.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"
#import "CardListTableViewCell.h"
#import "PaymentViewController.h"
#import "MyOrdesViewController.h"

@interface CardDetailViewController ()
{
    Users *objCardDetail;
    Globals *OBJGlobal;
    NSInteger btnDeleteTag;
    
}
@end

@implementation CardDetailViewController
@synthesize tableView,lblNoCard;

- (void)viewDidLoad {
    [super viewDidLoad];
    OBJGlobal=[Globals sharedManager];
    [OBJGlobal setTextFieldWithSpace:self.txtCvv];
    objCardDetail=OBJGlobal.user;
    [_viewPayment setHidden:YES];
    lblNoCard.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        UILabel *label;
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Card List";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        [self setUpImageBackButton:@"left-arrow"];
        [self cardListMethod];
        OBJGlobal.isCardlistNill=FALSE;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

#pragma Mark-Table Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [aryCardDetailList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    @try
    {
        static NSString *CellIdentifier = @"CardListTableViewCell";
        
        CardListTableViewCell *cell = (CardListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil)
        {
            cell = [[CardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        dict = [aryCardDetailList objectAtIndex:indexPath.row];
        
        cell.lblCardNumber.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[dict valueForKey:@"cc_last4"]];
        cell.lblExp.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"cc_exp_year"]];
        cell.lblMonth.text=[NSString stringWithFormat:@"%@ /",[dict valueForKey:@"cc_exp_month"]];
        cell.lblCardType.text=[dict valueForKey:@"cc_type"];
        
        
        cell.btnDelete.tag=indexPath.row+13000;
        if([[dict valueForKey:@"isSelected"] isEqualToString:@"1"])
        {
            [cell.btnSelectCard setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            
        }
        else
            [cell.btnSelectCard setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        cell.btnSelectCard.tag=indexPath.row+18000;
        [cell.btnSelectCard setUserInteractionEnabled:YES];
        
        
        if([[dict allKeys]containsObject:@"isSelected"]){
            NSString *strIsSelected = [dict valueForKey:@"isSelected"];
            if([strIsSelected isEqualToString:@"1"] && aryCardDetailList.count == 1)
                
                cell.btnDelete.hidden=false;
            else if ([strIsSelected isEqualToString:@"1"] )
                cell.btnDelete.hidden=true;
            else
                cell.btnDelete.hidden=false;
        }
        
        
        [cell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.btnSelectCard addTarget:self action:@selector(btnSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        //reset clicked
        [self cardListMethodDeleteMethod:btnDeleteTag];
    }
}

-(void)btnDeletePressed:(id)sender
{
    @try{
        
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-13000;
        btnDeleteTag=btnTag;
        NSDictionary *dictDetail = [aryCardDetailList objectAtIndex:btnTag];
        strCard_id=[dictDetail valueForKey:@"stored_card_id"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",[NSString stringWithFormat:@"%@",[dictDetail valueForKey:@"cc_last4"]]]
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete this card %@ ?",[NSString stringWithFormat:@"%@",[dictDetail valueForKey:@"cc_last4"]]]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        
        return;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(void)btnSelectPressed:(UIButton *)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-18000;
        
        for (int i = 0 ; i<aryCardDetailList.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict =[[aryCardDetailList objectAtIndex:i] mutableCopy];
            if (btnTag == i) {
                
                sender.selected = !sender.selected;
                [dict setValue:@"1" forKey:@"isSelected"];
            }
            else {
                UIButton *btn = sender;
                if ([[dict valueForKey:@"isSelected"] isEqualToString:@"1"]) {
                    btn.selected = !btn.selected;
                    
                    [dict setValue:@"0" forKey:@"isSelected"];
                }
            }
            [aryCardDetailList replaceObjectAtIndex:i withObject:dict];
        }
        [tableView reloadData];
        NSDictionary *dictDetail = [aryCardDetailList objectAtIndex:btnTag];
        strCard_id=[dictDetail valueForKey:@"stored_card_id"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (IBAction)btnContinuePressed:(id)sender
{
    if (aryCardDetailList.count==0) {
        [_viewPayment setHidden:YES];
        // [ self.view makeToast:@"There is no stored card. Please add New Card"];
    }else{
        [_viewPayment setHidden:NO];
    }
    
}

- (IBAction)btnCancelPressed:(id)sender
{
    [_viewPayment setHidden:YES];
}

-(void)cardListMethodDeleteMethod:(NSInteger)index
{
    @try{
        [APPDATA showLoader];
        
        Users *objCardDel = OBJGlobal.user;
        objCardDel.cardid=[[NSString stringWithFormat:@"%@",strCard_id ] mutableCopy];
        
        [objCardDel cardDataDelete:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                [aryCardDetailList removeObjectAtIndex:btnDeleteTag];
                [self.tableView reloadData];
                if (aryCardDetailList.count==0)
                {
                OBJGlobal.isCardlistNill=TRUE;
                PaymentViewController *objPaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
                
                
                [self.navigationController pushViewController:objPaymentViewController animated:NO];
                }
                //  aryDeliveryList = [user valueForKey:@"data"];
                
                [APPDATA hideLoader];
                
                NSLog(@"success");
            }
            else {
                //  [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)cardListMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            [APPDATA showLoader];
            [objCardDetail cardList:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                      OBJGlobal.isCardlistNill=FALSE;
                     aryCardDetailList =[[NSMutableArray alloc] initWithArray:[user valueForKey:@"stored_card"]];
                     
                     [aryCardDetailList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSMutableDictionary *dict = [obj mutableCopy];
                         if (idx == 0)
                             [dict setValue:@"1" forKey:@"isSelected"];
                         else
                             [dict setValue:@"0" forKey:@"isSelected"];
                         [aryCardDetailList replaceObjectAtIndex:idx withObject:dict];
                     }];
                     [self.tableView reloadData];
                     [APPDATA hideLoader];
                     
                     NSLog(@"success");
                 }
                 else {
//                     if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
//                         [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
//                     NSLog(@"Failed");
//                     if (aryCardDetailList.count==0) {
//                         lblNoCard.hidden=NO;
//                         self.tableView.alpha=0.5;
//                     }
//                     else{
//                         lblNoCard.hidden=YES;
//                         self.tableView.alpha=1;
//                     }
                     OBJGlobal.isCardlistNill=TRUE;
                     PaymentViewController *objPaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
                     
                     
                     [self.navigationController pushViewController:objPaymentViewController animated:NO];

                     
                     [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please login to view all card list"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnNewCardPressed:(id)sender {
    
    PaymentViewController *objPaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    
    
    [self.navigationController pushViewController:objPaymentViewController animated:NO];
}

- (IBAction)btnProceedPayment:(id)sender {
    
    @try{
        [self.view endEditing:TRUE];
        BOOL isValid=true;
        if (![Validations checkCvvNumber:self.txtCvv.text withLimit:3 ])
        {
            isValid=false;
            
            [OBJGlobal makeTextFieldBorderRed:self.txtCvv];
            [self.view makeToast:ERROR_FNAME];
            return;
        }
        
        if (isValid == TRUE)
        {
            [self paymentProceedCard];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)paymentProceedCard
{
    @try{
        [APPDATA showLoader];
        
        if(([OBJGlobal isNotNull:strCard_id] || strCard_id.length==0) && aryCardDetailList.count>0)
        {
            strCard_id = [[aryCardDetailList objectAtIndex:0] valueForKey:@"stored_card_id"];
        }
        
        Users *objPayment = OBJGlobal.user;
        objPayment.cvv=[[NSString stringWithFormat:@"%@",_txtCvv.text] mutableCopy];
        objPayment.cardid=[[NSString stringWithFormat:@"%@",strCard_id ] mutableCopy];
        
        
        
        [objPayment paymentProcessing:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                [self.view makeToast:[user valueForKey:@"msg"]];
                _viewPayment.hidden=YES;
                
                MyOrdesViewController *objMyOrdesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdesViewController"];
                [self.navigationController pushViewController:objMyOrdesViewController animated:NO];
                
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"success");
                [APPDATA hideLoader];
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                _viewPayment.hidden=YES;
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
@end

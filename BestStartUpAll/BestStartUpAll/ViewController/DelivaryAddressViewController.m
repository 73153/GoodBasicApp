//
//  DelivaryAddressViewController.m
//  peter
//
//  Created by Peter on 3/2/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "DelivaryAddressViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "UIView+Toast.h"
#import "DelivaryTableViewCell.h"
#import "CheckoutViewController.h"
#import "DeliveryPreferenceViewController.h"
#import "CheckoutViewController.h"

@interface DelivaryAddressViewController ()<UIAlertViewDelegate>
{
    Globals *OBJGlobal;
    Users *objorderHistory;
    NSInteger btnDeleteTag;
    NSInteger indexToDeleteProduct;
}
@end

@implementation DelivaryAddressViewController
@synthesize tableView,lblNoAddress;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        indexToDeleteProduct = 0;
        tableView.delegate=self;
        tableView.dataSource=self;
        objorderHistory=OBJGlobal.user;
        [self setUpImageBackButton:@"left-arrow"];
        lblNoAddress.hidden=YES;
        tableView.hidden=NO;
         OBJGlobal.isDeliveryAddressListNill=FALSE;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [aryDeliveryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    @try
    {
        static NSString *CellIdentifier = @"DelivaryTableViewCell";
        
        DelivaryTableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[DelivaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        dict = [aryDeliveryList objectAtIndex:indexPath.row];
        cell.lblFirstName.text=[dict valueForKey:@"firstname"];
        cell.lblLastName.text=[dict valueForKey:@"lastname"];
        if([OBJGlobal isNotNull:[dict valueForKey:@"street"]]){
            
            __block NSString *str1=@"";
            __block NSString *str2=@"";
            
            if([[dict allKeys]containsObject:@"street"]){
                NSArray *arystreetAddress = [dict valueForKey:@"street"];
                if(arystreetAddress.count>0){
                    if([OBJGlobal isNotNull:[arystreetAddress objectAtIndex:0 ]])
                        str1  = [arystreetAddress objectAtIndex:0];
                    if(arystreetAddress.count==2)
                        if([OBJGlobal isNotNull:[arystreetAddress objectAtIndex:1 ]])
                            str2 = [arystreetAddress objectAtIndex:1];
                }
                cell.lblStreetAdress.text = [NSString stringWithFormat:@"%@ %@ ",str1,str2];
                cell.lblStreetAdress.numberOfLines=0;
                cell.lblStreetAdress.lineBreakMode=NSLineBreakByWordWrapping;
                
            }
        }
        
        cell.lblCity.numberOfLines=0;
        cell.lblCity.lineBreakMode=NSLineBreakByWordWrapping;
        cell.lblCity.text = [dict valueForKey:@"city"];
        
        cell.lblState.numberOfLines=0;
        cell.lblState.lineBreakMode=NSLineBreakByWordWrapping;
        cell.lblState.text = [dict valueForKey:@"region"];
        cell.lblZipCode.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"postcode"]];
        
        cell.btnDelete.tag=indexPath.row+13000;
        if([[dict valueForKey:@"isSelected"] isEqualToString:@"1"])
        {
            [cell.btnSelectaddres setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        }
        else
            [cell.btnSelectaddres setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];        cell.btnSelectaddres.tag=indexPath.row+18000;
        [cell.btnSelectaddres setUserInteractionEnabled:YES];
        cell.btnUpdate.tag=indexPath.row+15000;
        
        if([[dict allKeys]containsObject:@"isSelected"]){
            NSString *strIsSelected = [dict valueForKey:@"isSelected"];
            if([strIsSelected isEqualToString:@"1"] && aryDeliveryList.count == 1)
                
                cell.btnDelete.hidden=false;
            else if ([strIsSelected isEqualToString:@"1"] )
                cell.btnDelete.hidden=true;
            else
                cell.btnDelete.hidden=false;
        }
        
        
        [cell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnUpdate addTarget:self action:@selector(btnUpdatePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnSelectaddres addTarget:self action:@selector(btnSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
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

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        UILabel *label;
        if ([_strmyaccountAddress isEqualToString:@"My Account Address"]) {
            [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            label.textAlignment = NSTextAlignmentCenter;
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines =0;
            label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
            label.text = @"My Address";
            label.textColor = [UIColor whiteColor];
            self.navigationItem.titleView = label;
            _btnContinue.hidden=YES;
            [self deliveryAddressmethod];
            
        }
        else{
            [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            label.textAlignment = NSTextAlignmentCenter;
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines =0;
            label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
            label.textColor = [UIColor whiteColor];
            label.text = @"Delivery Address";
            self.navigationItem.titleView = label;
            [self deliveryAddressmethod];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        //reset clicked
        [self checkOutAddressDeleteMethod:btnDeleteTag];
        
    }
}

-(void)btnDeletePressed:(id)sender
{
    @try{
        
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-13000;
        btnDeleteTag=btnTag;
        NSDictionary *dictDetail = [aryDeliveryList objectAtIndex:btnTag];
        straddress_id=[dictDetail valueForKey:@"address_id"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",[dictDetail valueForKey:@"firstname"]]
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete this address %@ ?",[dictDetail valueForKey:@"firstname"]]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        
        return;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)btnUpdatePressed:(id)sender
{
    UIButton *btnTapped = (UIButton*)sender;
    NSInteger btnTag = btnTapped.tag-15000;
    NSDictionary *dictDetail = [aryDeliveryList objectAtIndex:btnTag];
    
    CheckoutViewController *objCheckoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
    objCheckoutViewController.isEditAddress=YES;
    
    if ([_strmyaccountAddress isEqualToString:@"My Account Address"]){
        objCheckoutViewController.strMyEditAddress=@"My Edit Address";
    }
    
    objCheckoutViewController.btnContinue.hidden=YES;
    objCheckoutViewController.tempAddress=dictDetail;
    [self.navigationController pushViewController:objCheckoutViewController animated:NO];
}
-(void)btnSelectPressed:(UIButton *)sender
{
    
    UIButton *btnTapped = (UIButton*)sender;
    NSInteger btnTag = btnTapped.tag-18000;
    
    
    
    for (int i = 0 ; i<aryDeliveryList.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict =[[aryDeliveryList objectAtIndex:i] mutableCopy];
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
        [aryDeliveryList replaceObjectAtIndex:i withObject:dict];
    }
    [tableView reloadData];
    NSDictionary *dictDetail = [aryDeliveryList objectAtIndex:btnTag];
    straddress_id=[dictDetail valueForKey:@"address_id"];
    
}
- (IBAction)btnNewAdreassPressed:(id)sender
{
    CheckoutViewController *objCheckoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
    
    if ([_strmyaccountAddress isEqualToString:@"My Account Address"]) {
        objCheckoutViewController.strMyNewAddress=@"My Account";
    }
    objCheckoutViewController.strCheckoutAddress=@"Checkout Address";
    
    [self.navigationController pushViewController:objCheckoutViewController animated:NO];
    
}

-(void)deliveryAddressmethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            [APPDATA showLoader];
            [objorderHistory addressList:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                      OBJGlobal.isDeliveryAddressListNill=FALSE;
                     aryDeliveryList =[[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                     
                     
                     
                     [aryDeliveryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSMutableDictionary *dict = [obj mutableCopy];
                         if (idx == 0)
                             [dict setValue:@"1" forKey:@"isSelected"];
                         else
                             [dict setValue:@"0" forKey:@"isSelected"];
                         [aryDeliveryList replaceObjectAtIndex:idx withObject:dict];
                     }];
                     
                     [self.tableView reloadData];
                     [APPDATA hideLoader];
                     
                     NSLog(@"success");
                 }
                 else {
                    // if([OBJGlobal isNotNull:[user objectForKey:@"msg"]])
                        // [self.view makeToast:[NSString stringWithFormat:@"%@",[user objectForKey:@"msg"]]];
//                     if (aryDeliveryList.count==0) {
//                         lblNoAddress.hidden=NO;
//                         self.tableView.alpha=0.5;
//                     }
//                     else{
//                         lblNoAddress.hidden=YES;
//                         self.tableView.alpha=1;
//                         
//                     }
                     OBJGlobal.isDeliveryAddressListNill=TRUE;
                     CheckoutViewController *objCheckoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                     
                     if ([_strmyaccountAddress isEqualToString:@"My Account Address"]) {
                         objCheckoutViewController.strMyNewAddress=@"My Account";
                     }
                     objCheckoutViewController.strCheckoutAddress=@"Checkout Address";
                     
                     [self.navigationController pushViewController:objCheckoutViewController animated:NO];

                     
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please login to view all address"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)checkOutAddressMethod
{
    @try{
        [APPDATA showLoader];
        
        Users *objCheckout = OBJGlobal.user;
        if(([OBJGlobal isNotNull:straddress_id] || straddress_id.length==0) && aryDeliveryList.count>0)
        {
            straddress_id = [[aryDeliveryList objectAtIndex:0] valueForKey:@"address_id"];
        }
        objCheckout.addressid=[[NSString stringWithFormat:@"%@",straddress_id ] mutableCopy];
        
        [objCheckout checkoutAddressWithAdd_id:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                
                
                [APPDATA hideLoader];
                
                aryCheckoutData = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"total"]];
                if([OBJGlobal isNotNull:aryCheckoutData])
                    [OBJGlobal.arrPaypalData addObject:aryCheckoutData];
                
                [self.view makeToast:[user valueForKey:@"msg"]];
                //    [self.view makeToast:@"login successfully"];
                
                DeliveryPreferenceViewController *objDeliveryPreferenceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryPreferenceViewController"];
                [self.navigationController pushViewController:objDeliveryPreferenceViewController animated:NO];
                
                NSLog(@"success");
            }
            else {
                if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                    [self.view makeToast:[user valueForKey:@"msg"]];
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (IBAction)btnContinuePressed:(id)sender
{
    [self checkOutAddressMethod];
}

-(void)checkOutAddressDeleteMethod:(NSInteger)index
{
    @try{
        [APPDATA showLoader];
        
        Users *objCheckoutDel = OBJGlobal.user;
        objCheckoutDel.addressid=[[NSString stringWithFormat:@"%@",straddress_id ] mutableCopy];
        
        [objCheckoutDel AddressDelete:^(NSDictionary *user, NSString *str, int status) {
            
            
            if (status == 1) {
                [aryDeliveryList removeObjectAtIndex:btnDeleteTag];
                [self.tableView reloadData];
                //                aryDeliveryList = [user valueForKey:@"data"];
                //                [self.tableView reloadData];
//                if (aryDeliveryList.count==0) {
//                    lblNoAddress.hidden=NO;
//                    self.tableView.alpha=0.5;
//                }
//                else{
//                    lblNoAddress.hidden=YES;
//                    self.tableView.alpha=1;
//                    
//                }
                if (aryDeliveryList.count==0) {
                    OBJGlobal.isDeliveryAddressListNill=TRUE;
                CheckoutViewController *objCheckoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                
                if ([_strmyaccountAddress isEqualToString:@"My Account Address"]) {
                    objCheckoutViewController.strMyNewAddress=@"My Account";
                }
                objCheckoutViewController.strCheckoutAddress=@"Checkout Address";
                
                [self.navigationController pushViewController:objCheckoutViewController animated:NO];
                }
                
                [APPDATA hideLoader];
                //[self.view makeToast:[straddress_Delete valueForKey:@"msg"]];
                //    [self.view makeToast:@"login successfully"];
                
                
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



@end

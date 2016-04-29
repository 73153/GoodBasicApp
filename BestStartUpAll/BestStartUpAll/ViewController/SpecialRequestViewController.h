//
//  SpecialRequestViewController.h
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Globals.h"

@interface SpecialRequestViewController : UIViewController
{
    NSMutableDictionary *dicProductRequest;
}
@property (nonatomic,strong) IBOutlet UITextField *txtEmail;
@property (nonatomic,strong) IBOutlet UITextField *txtPhone;
@property (nonatomic,strong) IBOutlet UITextField *txtName;
@property (nonatomic,strong) IBOutlet UITextField *txtLastName;
@property (nonatomic,strong) IBOutlet UITextField *txtProduct;

-(IBAction)btnSendRequestPressed:(id)sender;

-(void)productRequestMethod;

@end

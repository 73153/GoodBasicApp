//
//  ContactUsViewController.h
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface ContactUsViewController : UIViewController
{
    NSMutableDictionary *dicContactUs;
}
@property (nonatomic,strong) IBOutlet UITextField *txtEmail;
@property (nonatomic,strong) IBOutlet UITextField *txtPhone;
@property (nonatomic,strong) IBOutlet UITextField *txtName;
@property (nonatomic,strong) IBOutlet UITextField *txtLastName;
@property (nonatomic,strong) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *txtCommentView;

-(IBAction)btnSubmitPressed:(id)sender;

-(void)contactUsMethod;

@end

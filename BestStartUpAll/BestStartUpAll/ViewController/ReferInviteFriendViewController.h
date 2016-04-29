//
//  ReferInviteFriendViewController.h
//  peter
//
//  Created by Peter on 4/11/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferInviteFriendViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFriendsEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;

- (IBAction)btnSendEmailPressed:(id)sender;

-(void)referralMethod;


@end

//
//  ShippingViewController.h
//  peter
//
//  Created by Peter on 2/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "LocationSearchViewController.h"
#import "UIPlaceHolderTextView.h"

@interface ShippingViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *txtCommentView;

- (IBAction)btnSubmitPressed:(id)sender;

@end

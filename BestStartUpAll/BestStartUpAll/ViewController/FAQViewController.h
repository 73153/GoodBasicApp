//
//  FAQViewController.h
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface FAQViewController : UIViewController
{
    NSString *strHtml;
}
@property NSString *strCms;
@property (nonatomic,strong) IBOutlet UIWebView *webFaq;

@end

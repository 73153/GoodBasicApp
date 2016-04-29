//
//  FAQViewController.m
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "FAQViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"

@interface FAQViewController ()
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    NSArray *aryFaqData;
}

@end

@implementation FAQViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webFaq loadHTMLString:htmlString baseURL:nil];
        [self FAQMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpContentData
{
    @try{
        UINib * mainView = [UINib nibWithNibName:@"CommonPopUpView" bundle:nil];
        OBJGlobal.objMainPopUp = (CommonPopUpView *)[mainView instantiateWithOwner:self options:nil][0];
        if(IS_IPHONE_6_PLUS)
        {
            OBJGlobal.objMainPopUp.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20);
        }else
            OBJGlobal.objMainPopUp.frame=CGRectMake(0, 5, self.view.frame.size.width, OBJGlobal.objMainPopUp.frame.size.height+60);
        [self.view addSubview:OBJGlobal.objMainPopUp];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Faq's";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)FAQMethod
{
    @try{
        [APPDATA showLoader];
        Users *objFAQ=[[Users alloc]init];
        objFAQ.cms = [self.strCms=@"about-us" mutableCopy];
        [objFAQ FAQ:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 
                 [APPDATA hideLoader];
                 // [self.view makeToast:[user objectForKey:@"msg"] duration:6.0f position:CSToastPositionBottom];
                 strHtml =[user objectForKey:@"data"];
                 [_webFaq loadHTMLString:strHtml baseURL:nil];
                 NSLog(@"success");
             }
             else {
                 // [self.view makeToast:@"Email and Password Invalid"];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


@end

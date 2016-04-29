//
//  UIPlaceHolderTextView.h
//  textViewPlaceHolder
//
//  Created by tusharpatel on 01/12/15.
//  Copyright © 2015 USBASE Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end

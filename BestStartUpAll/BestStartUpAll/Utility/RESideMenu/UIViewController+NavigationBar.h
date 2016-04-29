//
//  UIViewController+NavigationBar.h
//  TOPCOD
//
//  Created by ashish on 24/06/15.
//  Copyright (c) 2015 ashish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)
- (void)setUpImageBackButton:(NSString *)imageName;
- (void)setUpImageProfileEditButton:(NSString *)imageName;
- (void)setUpImageRightButtonWithText:(NSString *)imageName;
-(void) setMenuIconForSideBar:(NSString*)imageName;
-(UIButton*)setUpImageSecondRightButton:(NSString *)firstImage secondImage:(NSString*)secondImage thirdImage:(NSString*)thirdImage badgeCount:(NSInteger)badgeCount;
-(UIButton*)setBadgeCount:(NSInteger)badgeCount;
-(UIButton*)setUpImageThirdRightButton:(NSString *)firstImage secondImage:(NSString*)secondImage thirdImage:(NSString*)thirdImage badgeCount:(NSInteger)badgeCount fouthImage:(NSString*)fouthImage;
@end

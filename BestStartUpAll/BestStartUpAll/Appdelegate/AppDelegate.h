//
//  AppDelegate.h
//  peter
//
//  Created by Peter on 12/25/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;
@property (nonatomic,strong) NSMutableDictionary *dictAppNewAddress;
@end


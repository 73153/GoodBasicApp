//
//  AppDelegate.m
//  peter
//
//  Created by Peter on 12/25/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "PayPalMobile.h"
#import "SDWebImageManager.h"
#import "Globals.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define CLIENT_ID_FOR_SANDBOX_PAYPAL @"peter-facilitator@gmail.com"
#define CLIENT_ID_FOR_PAYPAL  @"AdFAn5WzOQEs4QP6jjwi1NqTQk9arU54eqmGupTEo83Q5XpNpwmmai_CBsXD5V0UPbITom63XPFSQHqO"
#define CrashlyticsKit [Crashlytics sharedInstance]

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize databaseName,databasePath;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    @try{
        //Enabling keyboard manager
        [[IQKeyboardManager sharedManager] setEnable:YES];
        
        [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
        //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
        
        //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
        [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
        
        //Resign textField if touched outside of UITextField/UITextView.
        [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
        
        //Giving permission to modify TextView's frame
        [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
        [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[myView class]];
        
        self.databaseName = @"peter.sqlite";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
        NSLog(@"DB Path %@",self.databasePath);
        //  [Fabric with:@[CrashlyticsKit]];
        
        [self createAndCheckDatabase];
        [Crashlytics startWithAPIKey:@"dd490df3dd1259f449601a4cc887419ddf1e0f80"];
        [Fabric with:@[[Crashlytics class]]];
        // Crashlytics product key
        //        c3c15533b02539808875f7be0825861ebb187677811b1161be2d388d9ee88727
        
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AdFAn5WzOQEs4QP6jjwi1NqTQk9arU54eqmGupTEo83Q5XpNpwmmai_CBsXD5V0UPbITom63XPFSQHqO",
                                                               PayPalEnvironmentSandbox : @"peter-facilitator@gmail.com"}];
        
        
        SDWebImageManager.sharedManager.cacheKeyFilter = ^(NSURL *url) {
            url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
            return [url absoluteString];
        };
        
        
        Globals *OBJGlobal = [Globals sharedManager];
        OBJGlobal.isfirstTimeDashBoardDataReceived=false;
        // Override point for customization after application launch.
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    // Override point for customization after application launch.
    return YES;
}

-(void) createAndCheckDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    NSLog(@"Path %@",databasePathFromApp);
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

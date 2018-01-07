//
//  StatusAlert
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [self loadScreen];
    return YES;
}

- (UIWindow*)loadScreen {
    UIWindow* window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UINavigationController* root = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] instantiate]];
    [window setRootViewController:root];
    [window makeKeyAndVisible];
    return window;
}

@end

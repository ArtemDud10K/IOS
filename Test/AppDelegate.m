//
//  AppDelegate.m
//  Test
//
//  Created by Dev on 7/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewControllerOne *viewControllerOne = [[[ViewControllerOne alloc] init] autorelease];
    viewControllerOne.tabBarItem.title = @"Restaurants";
    viewControllerOne.tabBarItem.image = [UIImage imageNamed:@"restaurants-icon.png"];
    
    ViewControllerTwo *viewControllerTwo = [[[ViewControllerTwo alloc] init] autorelease];
    viewControllerTwo.tabBarItem.title = @"Favorites";
    viewControllerTwo.tabBarItem.image = [UIImage imageNamed:@"ic_star_border_2x.png"];

    
    UINavigationController *resNavCtrl = [[[UINavigationController alloc] initWithRootViewController:viewControllerOne ] autorelease];
    [resNavCtrl.navigationBar setBackgroundImage:[UIImage imageNamed:@"1Res.png"]
                                forBarMetrics:UIBarMetricsDefault];
    
    viewControllerOne.navigationItem.title = @"Restaurants";
    
    UINavigationController *favNavCtrl = [[[UINavigationController alloc] initWithRootViewController:viewControllerTwo] autorelease];
    [favNavCtrl.navigationBar setBackgroundImage:[UIImage imageNamed:@"2Fav.png"]
                                   forBarMetrics:UIBarMetricsDefault];
    
    UITabBarController *bar = [[[UITabBarController alloc] init] autorelease];
    bar.viewControllers = @[resNavCtrl, favNavCtrl];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = bar;
    self.window.backgroundColor = [UIColor whiteColor]; 
    [self.window makeKeyAndVisible];
    return YES;

}



@end

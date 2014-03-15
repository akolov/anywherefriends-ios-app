//
//  AWFAppDelegate.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFAppDelegate.h"

#import "AWFFriendsViewController.h"
#import "AWFLocationManager.h"
#import "AWFLoginViewController.h"
#import "AWFNearbyViewController.h"
#import "AWFNavigationController.h"
#import "AWFSession.h"


@implementation AWFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
  [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

  AWFNearbyViewController *people = [[AWFNearbyViewController alloc] init];
  people.title = NSLocalizedString(@"AWF_PEOPLE_VIEW_CONTROLLER_TITLE", nil);
  AWFNavigationController *peopleNavigation = [[AWFNavigationController alloc] initWithRootViewController:people];
  peopleNavigation.tabBarItem.title = NSLocalizedString(@"AWF_PEOPLE_VIEW_CONTROLLER_TITLE", nil);
  peopleNavigation.tabBarItem.image = [UIImage imageNamed:@"people"];

  AWFFriendsViewController *friends = [[AWFFriendsViewController alloc] init];
  friends.title = NSLocalizedString(@"AWF_FRIENDS_VIEW_CONTROLLER_TITLE", nil);
  friends.tabBarItem.image = [UIImage imageNamed:@"friends"];
  AWFNavigationController *friendsNavigation = [[AWFNavigationController alloc] initWithRootViewController:friends];
  friendsNavigation.tabBarItem.title = NSLocalizedString(@"AWF_FRIENDS_VIEW_CONTROLLER_TITLE", nil);
  friendsNavigation.tabBarItem.image = [UIImage imageNamed:@"friends"];

  UIViewController *messages = [[UIViewController alloc] init];
  messages.title = NSLocalizedString(@"AWF_MESSAGES_VIEW_CONTROLLER_TITLE", nil);
  messages.tabBarItem.image = [UIImage imageNamed:@"messages"];
  AWFNavigationController *messagesNavigation = [[AWFNavigationController alloc] initWithRootViewController:messages];
  messagesNavigation.tabBarItem.title = NSLocalizedString(@"AWF_MESSAGES_VIEW_CONTROLLER_TITLE", nil);
  messagesNavigation.tabBarItem.image = [UIImage imageNamed:@"messages"];

  UITabBarController *tabs = [[UITabBarController alloc] init];
  tabs.viewControllers = @[peopleNavigation, friendsNavigation, messagesNavigation];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = tabs;
  [self.window makeKeyAndVisible];

  if (!AWFSession.isLoggedIn) {
    AWFLoginViewController *login = [[AWFLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
    AWFNavigationController *loginNavigation = [[AWFNavigationController alloc] initWithRootViewController:login];
    [tabs presentViewController:loginNavigation animated:NO completion:NULL];
  }

  [AWFLocationManager sharedManager];

  return YES;
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

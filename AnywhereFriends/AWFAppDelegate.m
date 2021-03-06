//
//  AWFAppDelegate.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFAppDelegate.h"
#import "AWFAppDelegate+AWFFacebookSDK.h"
#import "AWFAppDelegate+AWFVKSDK.h"

#import "AZNotification.h"
#import <AXKRACExtensions/NSNotificationCenter+AXKRACExtensions.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/NSNotificationCenter+RACSupport.h>

#import "AWFFriendsViewController.h"
#import "AWFLocationManager.h"
#import "AWFLoginViewController.h"
#import "AWFMessagesViewController.h"
#import "AWFMyProfileViewController.h"
#import "AWFNearbyViewController.h"
#import "AWFNavigationController.h"
#import "AWFSession.h"

@implementation AWFAppDelegate

+ (instancetype)sharedInstance {
  return (AWFAppDelegate *)[UIApplication sharedApplication].delegate;
}

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

  AWFMessagesViewController *messages = [[AWFMessagesViewController alloc] init];
  messages.title = NSLocalizedString(@"AWF_MESSAGES_VIEW_CONTROLLER_TITLE", nil);
  messages.tabBarItem.image = [UIImage imageNamed:@"messages"];
  AWFNavigationController *messagesNavigation = [[AWFNavigationController alloc] initWithRootViewController:messages];
  messagesNavigation.tabBarItem.title = NSLocalizedString(@"AWF_MESSAGES_VIEW_CONTROLLER_TITLE", nil);
  messagesNavigation.tabBarItem.image = [UIImage imageNamed:@"messages"];

  AWFMyProfileViewController *me = [[AWFMyProfileViewController alloc] init];
  me.title = NSLocalizedString(@"AWF_ME_VIEW_CONTROLLER_TITLE", nil);
  me.tabBarItem.image = [UIImage imageNamed:@"me"];
  AWFNavigationController *meNavigation = [[AWFNavigationController alloc] initWithRootViewController:me];
  meNavigation.tabBarItem.title = NSLocalizedString(@"AWF_ME_VIEW_CONTROLLER_TITLE", nil);
  meNavigation.tabBarItem.image = [UIImage imageNamed:@"me"];

  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = @[peopleNavigation, friendsNavigation, messagesNavigation, meNavigation];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];

  @weakify(self);

  [VKSdk initializeWithDelegate:self andAppId:@"4370266"];

  if (![AWFSession isLoggedIn]) {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
      [FBSession
       openActiveSessionWithReadPermissions:AWF_FACEBOOK_PERMISSIONS
       allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
         @strongify(self);
         [self sessionStateChanged:session state:state error:error];
       }];
    }
  }

  [[[AWFSession sharedSession] getUserSelf] subscribeError:^(NSError *error) {
    @strongify(self);
    [self.tabBarController showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
    ErrorLog(error.localizedDescription);
  }];

  [AWFLocationManager sharedManager];

  [RACObserveNotificationUntilDealloc(AWFLoginRequiredNotification) subscribeNext:^(NSNotification *note) {
    @strongify(self);

    void (^presentBlock)(void) = ^{
      AWFLoginViewController *login = [[AWFLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
      AWFNavigationController *loginNavigation = [[AWFNavigationController alloc] initWithRootViewController:login];
      [self.tabBarController presentViewController:loginNavigation animated:YES completion:NULL];
    };

    if (self.tabBarController.presentedViewController) {
      if ([self.tabBarController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.tabBarController.presentedViewController;
        if (![[navigation.viewControllers firstObject] isKindOfClass:[AWFLoginViewController class]]) {
          [self.tabBarController dismissViewControllerAnimated:NO completion:presentBlock];
        }
      }
      else {
        [self.tabBarController dismissViewControllerAnimated:NO completion:presentBlock];
      }
    }
    else {
      presentBlock();
    }
  }];

  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
    AWFAppDelegate *appDelegate = [AWFAppDelegate sharedInstance];
    [appDelegate sessionStateChanged:session state:state error:error];
  }];

  if ([url.scheme hasPrefix:@"fb"]) {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
  }
  else if ([url.scheme hasPrefix:@"vk"]) {
    return [VKSdk processOpenURL:url fromApplication:sourceApplication];
  }

  return NO;
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
  [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

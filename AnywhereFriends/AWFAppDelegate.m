//
//  AWFAppDelegate.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFAppDelegate.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFFriendsViewController.h"
#import "AWFLocationManager.h"
#import "AWFLoginViewController.h"
#import "AWFMessagesViewController.h"
#import "AWFMyProfileViewController.h"
#import "AWFNearbyViewController.h"
#import "AWFNavigationController.h"
#import "AWFSession.h"
#import "AWFSignupViewController.h"

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

  if (!AWFSession.isLoggedIn) {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
      @weakify(self);
      [FBSession
       openActiveSessionWithReadPermissions:AWF_FACEBOOK_PERMISSIONS
       allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
         @strongify(self);
         [self sessionStateChanged:session state:state error:error];
       }];
    }
    else {
      AWFLoginViewController *login = [[AWFLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
      AWFNavigationController *loginNavigation = [[AWFNavigationController alloc] initWithRootViewController:login];
      [self.tabBarController presentViewController:loginNavigation animated:NO completion:NULL];
    }
  }

  [[[AWFSession sharedSession] getUserSelf] subscribeError:^(NSError *error) {
    ErrorLog(error.localizedDescription);
  }];

  [AWFLocationManager sharedManager];

  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     AWFAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
     [appDelegate sessionStateChanged:session state:state error:error];
   }];

  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
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

#pragma mark - Facebook Session State

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
  if (!error && state == FBSessionStateOpen) {
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *facebookError) {
       if (!facebookError) {
         NSString *email = [user objectForKey:@"email"];

         [[[AWFSession sharedSession] openSessionWithEmail:email facebookToken:session.accessTokenData.accessToken]
          subscribeError:^(NSError *error) {
            NSData *json = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding
                                                           allowLossyConversion:NO];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
            if (!dict) {
              ErrorLog(error.localizedDescription);
            }

            for (NSDictionary *errorDict in dict[@"errors"]) {
              if ([[errorDict[@"message"] lowercaseString] isEqualToString:@"user not found"]) {
                AWFSignupViewController *vc = [[AWFSignupViewController alloc] initWithStyle:UITableViewStyleGrouped];

                vc.email = email;
                vc.firstName = user.first_name;
                vc.lastName = user.last_name;

                if ([[user objectForKey:@"gender"] isEqualToString:@"male"]) {
                  vc.gender = AWFGenderMale;
                }
                else {
                  vc.gender = AWFGenderFemale;
                }

                AWFNavigationController *navigation = [[AWFNavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:navigation animated:YES completion:NULL];
                return;
              }
            }
            
            ErrorLog(error.localizedDescription);
          }];
       }
       else {
         [[[UIAlertView alloc]
           initWithTitle:NSLocalizedString(@"AWF_ERROR_FACEBOOK_REQUEST_TITLE", nil)
           message:NSLocalizedString(@"AWF_ERROR_FACEBOOK_REQUEST_MESSAGE", nil)
           delegate:nil
           cancelButtonTitle:NSLocalizedString(@"AWF_DISMISS", nil)
           otherButtonTitles:nil] show];
       }
     }];
  }
  else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
    // If the session is closed
    NSLog(@"Session closed");
    // Show the user the logged-out UI
  }
  else if (error) {
    NSLog(@"Error");
    NSString *alertText;
    NSString *alertTitle;
    // If the error requires people using an app to make an action outside of the app in order to recover
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
      alertTitle = @"Something went wrong";
      alertText = [FBErrorUtility userMessageForError:error];
//      [self showMessage:alertText withTitle:alertTitle];
    }
    else {

      // If the user cancelled login, do nothing
      if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"User cancelled login");

        // Handle session closures that happen outside of the app
      }
      else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
        alertTitle = @"Session Error";
        alertText = @"Your current session is no longer valid. Please log in again.";
//        [self showMessage:alertText withTitle:alertTitle];

        // Here we will handle all other errors with a generic error message.
        // We recommend you check our Handling Errors guide for more information
        // https://developers.facebook.com/docs/ios/errors/
      }
      else {
        //Get more error information from the error
        NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];

        // Show the user an error message
        alertTitle = @"Something went wrong";
        alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//        [self showMessage:alertText withTitle:alertTitle];
      }
    }
    // Clear this token
    [FBSession.activeSession closeAndClearTokenInformation];
    // Show the user the logged-out UI
//    [self userLoggedOut];
  }
}

@end

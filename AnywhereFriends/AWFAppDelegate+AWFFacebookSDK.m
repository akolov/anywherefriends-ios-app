//
//  AWFAppDelegate+AWFFacebookSDK.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFAppDelegate+AWFFacebookSDK.h"

#import "AZNotification.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFLoginViewController.h"
#import "AWFNavigationController.h"
#import "AWFSession.h"
#import "AWFSignupViewController.h"

@implementation AWFAppDelegate (AWFFacebookSDK)

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
  switch (state) {
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [FBSession.activeSession closeAndClearTokenInformation];
      return;
    default:
      break;
  }

  if (error) {
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
      [self.tabBarController showNotificationWithTitle:[FBErrorUtility userMessageForError:error]
                                      notificationType:AZNotificationTypeError];
    }
    else {
      if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        // User cancelled log in
      }
      else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        [self.tabBarController showNotificationWithTitle:[FBErrorUtility userMessageForError:error]
                                        notificationType:AZNotificationTypeError];
      }
      else {
        NSDictionary *errorInformation = error.userInfo[@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];
        [self.tabBarController showNotificationWithTitle:errorInformation[@"message"]
                                        notificationType:AZNotificationTypeError];
      }
    }

    [FBSession.activeSession closeAndClearTokenInformation];
  }
  else {
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id <FBGraphUser> user, NSError *facebookError) {
       if (!facebookError) {
         NSString *email = [user objectForKey:@"email"];

         [[[AWFSession sharedSession] openSessionWithFacebookToken:session.accessTokenData.accessToken]
          subscribeError:^(NSError *error) {
            NSData *json = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding
                                                           allowLossyConversion:NO];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];

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

                if ([self.tabBarController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                  UINavigationController *navigation = (UINavigationController *)self.tabBarController.presentedViewController;
                  [navigation pushViewController:vc animated:NO];
                }
                else {
                  AWFNavigationController *navigation = [[AWFNavigationController alloc] initWithRootViewController:vc];
                  [self.tabBarController presentViewController:navigation animated:NO completion:NULL];
                }

                return;
              }
            }

            [self.tabBarController showNotificationWithTitle:error.localizedDescription
                                            notificationType:AZNotificationTypeError];
          } completed:^{
            if (self.tabBarController.presentedViewController) {
              if ([self.tabBarController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigation = (UINavigationController *)self.tabBarController.presentedViewController;
                if ([[navigation.viewControllers firstObject] isKindOfClass:[AWFLoginViewController class]]) {
                  if (!self.tabBarController.presentedViewController.isBeingPresented &&
                      !self.tabBarController.presentedViewController.isBeingDismissed) {
                    [self.tabBarController dismissViewControllerAnimated:NO completion:NULL];
                  }
                }
              }
              else {
                [self.tabBarController dismissViewControllerAnimated:NO completion:NULL];
              }
            }
          }];
       }
       else {
         [self.tabBarController showNotificationWithTitle:[FBErrorUtility userMessageForError:facebookError]
                                         notificationType:AZNotificationTypeError];
       }
     }];
  }
}

@end

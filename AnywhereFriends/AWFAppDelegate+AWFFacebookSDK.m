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
#import <ReactiveCocoa/RACEXTScope.h>
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
    @weakify(self);
    [[[AWFSession sharedSession] openSessionWithFacebookToken:session.accessTokenData.accessToken]
     subscribeError:^(NSError *error) {
       @strongify(self);
       [self.tabBarController showNotificationWithTitle:error.localizedDescription
                                       notificationType:AZNotificationTypeError];
     } completed:^{
       @strongify(self);
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
}

@end

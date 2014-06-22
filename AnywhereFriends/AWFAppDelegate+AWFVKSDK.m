//
//  AWFAppDelegate+AWFVKSDK.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFAppDelegate+AWFVKSDK.h"

#import "AZNotification.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFLoginViewController.h"
#import "AWFNavigationController.h"
#import "AWFSession.h"
#import "AWFSignupViewController.h"

@implementation AWFAppDelegate (AWFVKSDK)

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
  @weakify(self);
  [[[AWFSession sharedSession] openSessionWithVKToken:newToken.accessToken]
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
           [self.tabBarController dismissViewControllerAnimated:NO completion:NULL];
         }
       }
       else {
         [self.tabBarController dismissViewControllerAnimated:NO completion:NULL];
       }
     }
   }];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
  [self.tabBarController showNotificationWithTitle:authorizationError.errorMessage notificationType:AZNotificationTypeError];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
  [VKSdk authorize:AWF_VK_PERMISSIONS];
}

- (void)vkSdkRenewedToken:(VKAccessToken *)newToken {
  [self vkSdkReceivedNewToken:newToken];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
  [self.tabBarController.selectedViewController presentViewController:controller animated:YES completion:NULL];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
  VKCaptchaViewController * vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
  [vc presentIn:self.tabBarController.selectedViewController];
}

@end

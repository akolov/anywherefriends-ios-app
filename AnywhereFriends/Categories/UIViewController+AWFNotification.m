//
//  UIViewController+AWFNotification.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "UIViewController+AWFNotification.h"

@implementation UIViewController (AWFNotification)

- (void)showNotificationWithTitle:(NSString *)title notificationType:(AZNotificationType)notificationType {
  if (self.presentedViewController) {
    [self.presentedViewController showNotificationWithTitle:title notificationType:notificationType];
  }
  else if ([self isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabController = (UITabBarController *)self;
    [tabController.selectedViewController showNotificationWithTitle:title notificationType:notificationType];
  }
  else if ([self isKindOfClass:[UINavigationController class]]) {
    [AZNotification showNotificationWithTitle:title
                                   controller:self
                             notificationType:notificationType
     shouldShowNotificationUnderNavigationBar:NO];
  }
  else {
    [AZNotification showNotificationWithTitle:title
                                   controller:self
                             notificationType:notificationType
     shouldShowNotificationUnderNavigationBar:NO];
  }
}

@end

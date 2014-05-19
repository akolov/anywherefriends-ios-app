//
//  UIViewController+AWFNotification.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import UIKit;

#import "AZNotification.h"

@interface UIViewController (AWFNotification)

- (void)showNotificationWithTitle:(NSString *)title notificationType:(AZNotificationType)notificationType;

@end

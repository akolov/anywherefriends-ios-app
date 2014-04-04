//
//  AWFAppDelegate.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

#import <FacebookSDK/FacebookSDK.h>

@interface AWFAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end

//
//  AWFNavigationController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFNavigationController.h"

#import "AWFNavigationBar.h"

@implementation AWFNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super initWithNavigationBarClass:[AWFNavigationBar class] toolbarClass:nil];
  if (self) {
    [self setViewControllers:@[rootViewController] animated:NO];
  }
  return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [self.topViewController preferredStatusBarStyle];
}

@end

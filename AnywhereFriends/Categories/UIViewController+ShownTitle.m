//
//  UIViewController+ShownTitle.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 20/02/14.
//  Copyright (c) 2014 AnywhereFriends. All rights reserved.
//

#import "AWFConfig.h"
#import "UIViewController+ShownTitle.h"

@import ObjectiveC.runtime;

@implementation UIViewController (ShownTitle)

@dynamic shownTitle;

- (void)setShownTitle:(NSString *)shownTitle {
  if (shownTitle) {
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [titleButton setTitle:shownTitle forState:UIControlStateNormal];
    [titleButton setTitleColor:[UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName]
                      forState:UIControlStateNormal];

    self.navigationItem.titleView = titleButton;
  }
  else {
    self.navigationItem.titleView = nil;
  }

  objc_setAssociatedObject(self, @selector(shownTitle), shownTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)shownTitle {
  return objc_getAssociatedObject(self, @selector(shownTitle));
}

@end

//
//  UIButton+Autolayout.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIButton+Autolayout.h"

@implementation UIButton (Autolayout)

+ (instancetype)autolayoutButton {
  UIButton *button = [self buttonWithType:UIButtonTypeCustom];
  button.translatesAutoresizingMaskIntoConstraints = NO;
  return button;
}

@end

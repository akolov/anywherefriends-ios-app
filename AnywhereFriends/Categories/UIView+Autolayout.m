//
//  UIView+Autolayout.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

+ (id)autolayoutView {
  UIView *view = [[self alloc] initWithFrame:CGRectZero];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  return view;
}

@end

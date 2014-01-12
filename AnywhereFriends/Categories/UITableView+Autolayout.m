//
//  UITableView+Autolayout.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "UITableView+Autolayout.h"
#import <JRSwizzle/JRSwizzle.h>

@implementation UITableView (Autolayout)

+ (void)load {
  [self jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(layoutSubviews_swizzle) error:NULL];
}

- (void)layoutSubviews_swizzle {
  [super layoutSubviews];
  [self layoutSubviews_swizzle];
  [super layoutSubviews];
}

@end

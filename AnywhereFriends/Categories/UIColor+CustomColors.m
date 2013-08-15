//
//  UIColor+CustomColors.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)awfDefaultBackgroundColor {
  return [self colorWithWhite:0.9f alpha:1.0f];
}

+ (UIColor *)awfPinkColor {
  return [UIColor colorWithRed:0.9f green:0 blue:0.6f alpha:1.0f];
}

#pragma mark - Text colors

+ (UIColor *)awfBlueTextColor {
  return [self colorWithDecimalRed:16.0f green:103.0f blue:214.0f alpha:1.0f];
}

+ (UIColor *)awfDarkGrayTextColor {
  return [self colorWithDecimalRed:98.0f green:98.0f blue:102.0f alpha:1.0f];
}

+ (UIColor *)awfGrayTextColor {
  return [self colorWithDecimalRed:135.0f green:129.0f blue:141.0f alpha:1.0f];
}

@end

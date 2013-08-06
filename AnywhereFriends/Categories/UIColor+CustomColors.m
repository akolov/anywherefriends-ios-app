//
//  UIColor+CustomColors.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)defaultBackgroundColor {
  return [self colorWithWhite:0.9f alpha:1.0f];
}

+ (UIColor *)grayTextColor {
  return [self colorWithDecimalRed:135.0f green:129.0f blue:141.0f alpha:1.0f];
}

+ (UIColor *)darkGrayTextColor {
  return [self colorWithDecimalRed:98.0f green:98.0f blue:102.0f alpha:1.0f];
}

@end

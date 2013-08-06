//
//  UIColor+ColorTools.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/19/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "UIColor+ColorTools.h"


static inline CGFloat normalizeColorComponent(const CGFloat component) {
  return MIN(255.0f, MAX(0, component)) / 255.0f;
}


@implementation UIColor (ColorTools)

+ (UIColor *)colorWithDecimalWhite:(CGFloat)white alpha:(CGFloat)alpha {
  return [self colorWithWhite:normalizeColorComponent(white) alpha:alpha];
}

+ (UIColor *)colorWithDecimalRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
  return [self colorWithRed:normalizeColorComponent(red) green:normalizeColorComponent(green) blue:normalizeColorComponent(blue) alpha:alpha];
}

- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}

@end

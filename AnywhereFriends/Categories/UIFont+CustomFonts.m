//
//  UIFont+CustomFonts.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIFont+CustomFonts.h"


@implementation UIFont (CustomFonts)

#pragma mark - AvenirNext Condensed

+ (UIFont *)avenirNextCondensedFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:size];
}

+ (UIFont *)demiBoldAvenirNextCondensedFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:size];
}

+ (UIFont *)ultraLightAvenirNextCondensedFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:size];
}

#pragma mark - Magneto

+ (UIFont *)magnetoBoldFontOfSize:(CGFloat)size {
  return [self fontWithName:@"Magneto-Bold" size:size];
}

@end

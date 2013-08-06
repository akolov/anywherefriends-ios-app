//
//  UIFont+CustomFonts.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIFont+CustomFonts.h"

@implementation UIFont (CustomFonts)

+ (UIFont *)avenirNextCondensedFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:size];
}

+ (UIFont *)demiBoldAvenirNextCondensedFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:size];
}

+ (UIFont *)magnetoBoldFontOfSize:(CGFloat)size {
  return [self fontWithName:@"Magneto-Bold" size:size];
}

@end

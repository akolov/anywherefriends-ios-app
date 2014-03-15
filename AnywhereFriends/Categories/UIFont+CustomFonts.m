//
//  UIFont+CustomFonts.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "UIFont+CustomFonts.h"

@implementation UIFont (CustomFonts)

#pragma mark - AvenirNext Condensed

+ (UIFont *)helveticaNeueFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)helveticaNeueLightFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)helveticaNeueUltraLightFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}

#pragma mark - AvenirNext Condensed

+ (UIFont *)helveticaNeueCondensedLightFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeueLTCom-LtCn" size:size];
}

+ (UIFont *)helveticaNeueCondensedMediumFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"HelveticaNeueLTCom-MdCn" size:size];
}

#pragma mark - AvenirNext Condensed

+ (UIFont *)avenirNextCondensedDemiBoldFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:size];
}

#pragma mark - Magneto

+ (UIFont *)magnetoBoldFontOfSize:(CGFloat)size {
  return [self fontWithName:@"Magneto-Bold" size:size];
}

@end

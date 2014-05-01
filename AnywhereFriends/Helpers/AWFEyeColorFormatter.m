//
//  AWFEyeColorFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFEyeColorFormatter.h"

@implementation AWFEyeColorFormatter

- (NSString *)stringFromEyeColor:(AWFEyeColor)eyeColor {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    switch (eyeColor) {
      case AWFEyeColorAmber:
        return @"amber";
      case AWFEyeColorBlue:
        return @"blue";
      case AWFEyeColorBrown:
        return @"brown";
      case AWFEyeColorGray:
        return @"gray";
      case AWFEyeColorGreen:
        return @"green";
      case AWFEyeColorHazel:
        return @"hazel";
      case AWFEyeColorRed:
        return @"red";
      case AWFEyeColorViolet:
        return @"violet";
      default:
        return @"—";
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    switch (eyeColor) {
      case AWFEyeColorAmber:
        return @"янтарный";
      case AWFEyeColorBlue:
        return @"голубой";
      case AWFEyeColorBrown:
        return @"коричневый";
      case AWFEyeColorGray:
        return @"серый";
      case AWFEyeColorGreen:
        return @"зелёный";
      case AWFEyeColorHazel:
        return @"карий";
      case AWFEyeColorRed:
        return @"красный";
      case AWFEyeColorViolet:
        return @"фиолетовый";
      default:
        return @"—";
    }
  }

  return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSNumber class]]) {
    return nil;
  }

  return [self stringFromEyeColor:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

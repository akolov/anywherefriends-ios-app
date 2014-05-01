//
//  AWFHairColorFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFHairColorFormatter.h"

@implementation AWFHairColorFormatter

- (NSString *)stringFromHairColor:(AWFHairColor)hairColor {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    switch (hairColor) {
      case AWFHairColorAuburn:
        return @"auburn";
      case AWFHairColorBlack:
        return @"black";
      case AWFHairColorBlond:
        return @"blond";
      case AWFHairColorBrown:
        return @"brown";
      case AWFHairColorChestnut:
        return @"chestnut";
      case AWFHairColorGray:
        return @"gray";
      case AWFHairColorRed:
        return @"red";
      case AWFHairColorWhite:
        return @"white";
      default:
        return @"—";
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    switch (hairColor) {
      case AWFHairColorAuburn:
        return @"тёмно-рыжий";
      case AWFHairColorBlack:
        return @"чёрный";
      case AWFHairColorBlond:
        return @"светлый";
      case AWFHairColorBrown:
        return @"коричневый";
      case AWFHairColorChestnut:
        return @"каштановый";
      case AWFHairColorGray:
        return @"серый";
      case AWFHairColorRed:
        return @"рыжий";
      case AWFHairColorWhite:
        return @"белый";
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

  return [self stringFromHairColor:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

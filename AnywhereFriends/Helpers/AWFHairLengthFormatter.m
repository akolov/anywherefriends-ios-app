//
//  AWFHairLengthFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFHairLengthFormatter.h"

@implementation AWFHairLengthFormatter

- (NSString *)stringFromHairLength:(AWFHairLength)hairLength {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    switch (hairLength) {
      case AWFHairLengthShort:
        return @"short";
      case AWFHairLengthMedium:
        return @"medium";
      case AWFHairLengthLong:
        return @"long";
      default:
        return @"—";
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    switch (hairLength) {
      case AWFHairLengthShort:
        return @"короткие";
      case AWFHairLengthMedium:
        return @"средние";
      case AWFHairLengthLong:
        return @"длинные";
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

  return [self stringFromHairLength:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

//
//  AWFAgeFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFAgeFormatter.h"

@implementation AWFAgeFormatter

- (NSString *)stringFromAge:(NSUInteger)age {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    if (age != 1) {
      return [NSString stringWithFormat:@"%lu years", (unsigned long)age];
    }
    else {
      return [NSString stringWithFormat:@"%lu year", (unsigned long)age];
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    unsigned long _age = age % 100;
    switch (_age) {
      case 1:
        return [NSString stringWithFormat:@"%lu год", age];
      case 2:
      case 3:
      case 4:
        return [NSString stringWithFormat:@"%lu года", _age];
      default:
        return [NSString stringWithFormat:@"%lu лет", _age];
    }
  }
  return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSNumber class]]) {
    return nil;
  }

  return [self stringFromAge:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

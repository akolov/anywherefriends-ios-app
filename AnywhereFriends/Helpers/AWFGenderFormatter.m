//
//  AWFGenderFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFGenderFormatter.h"

@implementation AWFGenderFormatter

- (NSString *)stringFromGender:(AWFGender)gender {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    switch (gender) {
      case AWFGenderFemale:
        return @"female";
      case AWFGenderMale:
        return @"male";
      default:
        return @"unknown";
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    switch (gender) {
      case AWFGenderFemale:
        return @"женский";
      case AWFGenderMale:
        return @"мужской";
      default:
        return @"неизвестный";
    }
  }

  return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSNumber class]]) {
    return nil;
  }

  return [self stringFromGender:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

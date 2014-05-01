//
//  AWFBodyBuildFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFBodyBuildFormatter.h"

@implementation AWFBodyBuildFormatter

- (NSString *)stringFromBodyBuild:(AWFBodyBuild)bodyBuild {
  NSString *languageCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
  if ([languageCode isEqualToString:@"en"]) {
    switch (bodyBuild) {
      case AWFBodyBuildSlim:
        return @"slim";
      case AWFBodyBuildAverage:
        return @"average";
      case AWFBodyBuildAthletic:
        return @"athletic";
      case AWFBodyBuildExtraPounds:
        return @"extra pounds";
      default:
        return @"unknown";
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    switch (bodyBuild) {
      case AWFBodyBuildSlim:
        return @"худощавое";
      case AWFBodyBuildAverage:
        return @"обычное";
      case AWFBodyBuildAthletic:
        return @"спортивное";
      case AWFBodyBuildExtraPounds:
        return @"полное";
      default:
        return @"неизвестно";
    }
  }

  return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSNumber class]]) {
    return nil;
  }

  return [self stringFromBodyBuild:[anObject unsignedIntegerValue]];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

@end

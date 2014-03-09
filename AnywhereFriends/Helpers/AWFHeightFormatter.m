//
//  AWFHeightFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFHeightFormatter.h"

@interface AWFHeightFormatter ()

+ (NSString *)metricToImperial:(NSNumber *)metric;

@end

@implementation AWFHeightFormatter

- (NSString *)stringFromHeight:(NSNumber *)height {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if ([languageCode isEqualToString:@"en"]) {
    if (!height || [height unsignedIntegerValue] == 0) {
      return [NSString stringWithFormat:@"n/a"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%u cm", [height unsignedIntegerValue]];
      }
      else {
        return [AWFHeightFormatter metricToImperial:height];
      }
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    if (!height || [height unsignedIntegerValue] == 0) {
      return [NSString stringWithFormat:@"неизвестен"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%u см", [height unsignedIntegerValue]];
      }
      else {
        return [AWFHeightFormatter metricToImperial:height];
      }
    }
  }
  return nil;
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSNumber class]]) {
    return nil;
  }

  return [self stringFromHeight:anObject];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

#pragma mark - Private methods

+ (NSString *)metricToImperial:(NSNumber *)metric {
  CGFloat value = [metric floatValue];
  CGFloat number = value / 2.54f;

  if (number > 12.0f) {
    return [NSString stringWithFormat:@"%u’%u”", (NSUInteger)floor(number / 12.0f), (NSUInteger)number % 12];

  }
  else {
    return [NSString stringWithFormat:@"0’%u”", (NSUInteger)round(number)];
  }
}

@end

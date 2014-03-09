//
//  AWFWeightFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFWeightFormatter.h"

@interface AWFWeightFormatter ()

+ (NSNumber *)metricToImperial:(NSNumber *)metric;

@end

@implementation AWFWeightFormatter

- (NSString *)stringFromWeight:(NSNumber *)weight {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if ([languageCode isEqualToString:@"en"]) {
    if (!weight || [weight unsignedIntegerValue] == 0) {
      return [NSString stringWithFormat:@"n/a"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%u kg", [weight unsignedIntegerValue]];
      }
      else {
        return [NSString stringWithFormat:@"%u lbs", [[AWFWeightFormatter metricToImperial:weight] unsignedIntegerValue]];
      }
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    if (!weight || [weight unsignedIntegerValue] == 0) {
      return [NSString stringWithFormat:@"неизвестен"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%u кг", [weight unsignedIntegerValue]];
      }
      else {
        NSUInteger _weight = [[AWFWeightFormatter metricToImperial:weight] unsignedIntegerValue] % 100;
        switch (_weight) {
          case 1:
            return [NSString stringWithFormat:@"%u фунт", _weight];
          case 2:
          case 3:
          case 4:
            return [NSString stringWithFormat:@"%u фунта", _weight];
          default:
            return [NSString stringWithFormat:@"%u фунтов", _weight];
        }
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

  return [self stringFromWeight:anObject];
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
  *error = @"Method Not Implemented";
  return NO;
}

#pragma mark - Private methods

+ (NSNumber *)metricToImperial:(NSNumber *)metric {
  CGFloat value = [metric floatValue];
  NSUInteger number = (NSUInteger)roundf(value / 2.20462f);
  return [NSNumber numberWithUnsignedInteger:number];
}

@end

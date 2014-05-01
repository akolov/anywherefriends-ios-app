//
//  AWFWeightFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
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
      return [NSString stringWithFormat:@"—"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%lu kg", [weight unsignedLongValue]];
      }
      else {
        return [NSString stringWithFormat:@"%lu lbs", [[AWFWeightFormatter metricToImperial:weight] unsignedLongValue]];
      }
    }
  }
  else if ([languageCode isEqualToString:@"ru"]) {
    if (!weight || [weight unsignedIntegerValue] == 0) {
      return [NSString stringWithFormat:@"—"];
    }
    else {
      if (isMetric) {
        return [NSString stringWithFormat:@"%lu кг", [weight unsignedLongValue]];
      }
      else {
        unsigned long _weight = [[AWFWeightFormatter metricToImperial:weight] unsignedIntegerValue] % 100;
        switch (_weight) {
          case 1:
            return [NSString stringWithFormat:@"%lu фунт", _weight];
          case 2:
          case 3:
          case 4:
            return [NSString stringWithFormat:@"%lu фунта", _weight];
          default:
            return [NSString stringWithFormat:@"%lu фунтов", _weight];
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

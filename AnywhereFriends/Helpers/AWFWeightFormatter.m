//
//  AWFWeightFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFWeightFormatter.h"

static float __poundsInKilogram = 2.20462f;

@interface AWFWeightFormatter ()

+ (NSString *)metricStringWithKilograms:(NSNumber *)kilograms locale:(NSLocale *)locale;
+ (NSString *)imperialStringWithKilograms:(NSNumber *)kilograms locale:(NSLocale *)locale;

@end

@implementation AWFWeightFormatter

- (NSString *)stringFromWeight:(NSNumber *)weight {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if (!weight) {
    return [NSString stringWithFormat:@"—"];
  }
  else if ([weight isEqualToNumber:@0]) {
    return @"0";
  }
  else {
    if (isMetric) {
      return [[self class] metricStringWithKilograms:weight locale:locale];
    } else {
      return [[self class] imperialStringWithKilograms:weight locale:locale];
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

#pragma mark - Public Methods

+ (float)kilogramsWithPounds:(float)pounds {
  return pounds / __poundsInKilogram;
}

#pragma mark - Private methods

+ (NSString *)metricStringWithKilograms:(NSNumber *)kilograms locale:(NSLocale *)locale {
  NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];

  NSString *kilogram, *gram;
  if ([languageCode isEqualToString:@"ru"]) {
    kilogram = @"кг";
    gram = @"г";
  } else {
    kilogram = @"kg";
    gram = @"g";
  }

  unsigned int grams = [kilograms unsignedIntValue] * 100;

  if (grams < 100) {
    return [NSString stringWithFormat:@"%u %@", grams, gram];
  }
  else if (grams % 100 == 0) {
    return [NSString stringWithFormat:@"%u %@", grams / 100, kilogram];
  }
  else {
    return [NSString stringWithFormat:@"%u %@ %u %@", grams / 100, kilogram, grams % 100, gram];
  }
}

+ (NSString *)imperialStringWithKilograms:(NSNumber *)kilograms locale:(NSLocale *)locale {
  NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];

  float value = [kilograms floatValue];
  unsigned int pounds = (unsigned int)roundf(value * __poundsInKilogram);

  if ([languageCode isEqualToString:@"ru"]) {
    switch (pounds % 100) {
      case 1:
        return [NSString stringWithFormat:@"%u фунт", pounds];
      case 2:
      case 3:
      case 4:
        return [NSString stringWithFormat:@"%u фунта", pounds];
      default:
        return [NSString stringWithFormat:@"%u фунтов", pounds];
    }
  } else {
    return [NSString stringWithFormat:@"%u lbs", pounds];
  }
}

@end

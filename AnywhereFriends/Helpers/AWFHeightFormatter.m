//
//  AWFHeightFormatter.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFHeightFormatter.h"

static float __inchesInFeet = 12.0f;
static float __centimetersInInch = 2.54f;

@interface AWFHeightFormatter ()

+ (NSString *)metricStringWithCentimetres:(NSNumber *)centimetres locale:(NSLocale *)locale;
+ (NSString *)imperialStringWithCentimetres:(NSNumber *)centimetres;

@end

@implementation AWFHeightFormatter

- (NSString *)stringFromHeight:(NSNumber *)height {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if (!height) {
    return [NSString stringWithFormat:@"—"];
  }
  else if ([height isEqualToNumber:@0]) {
    return @"0";
  }
  else {
    if (isMetric) {
      return [[self class] metricStringWithCentimetres:height locale:locale];
    }
    else {
      return [[self class] imperialStringWithCentimetres:height];
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

#pragma mark - Public Methods

+ (float)centimetersWithFeet:(float)feet inches:(float)inches {
  return (feet / __inchesInFeet + inches) * __centimetersInInch;
}

#pragma mark - Private Methods

+ (NSString *)metricStringWithCentimetres:(NSNumber *)centimetres locale:(NSLocale *)locale {
  NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];

  NSString *metre, *centimetre;
  if ([languageCode isEqualToString:@"ru"]) {
    metre = @"м";
    centimetre = @"см";
  }
  else {
    metre = @"m";
    centimetre = @"cm";
  }

  unsigned int _centimetres = [centimetres unsignedIntValue];

  if (_centimetres < 100) {
    return [NSString stringWithFormat:@"%u %@", _centimetres, centimetre];
  }
  else if (_centimetres % 100 == 0) {
    return [NSString stringWithFormat:@"%u %@", _centimetres / 100, metre];
  }
  else {
    return [NSString stringWithFormat:@"%u %@ %u %@", _centimetres / 100, metre, _centimetres % 100, centimetre];
  }
}

+ (NSString *)imperialStringWithCentimetres:(NSNumber *)centimetres {
  float value = [centimetres floatValue];
  float inches = value / __centimetersInInch;

  if (inches < __inchesInFeet) {
    return [NSString stringWithFormat:@"%u”", (unsigned int)round(inches)];
  }
  else if (fmod(inches, __inchesInFeet) == 0) {
    return [NSString stringWithFormat:@"%u’", (unsigned int)floor(inches / __inchesInFeet)];
  }
  else {
    return [NSString stringWithFormat:@"%u’%u”", (unsigned int)floor(inches / __inchesInFeet),
            (unsigned int)inches % (unsigned int)__inchesInFeet];
  }
}

@end

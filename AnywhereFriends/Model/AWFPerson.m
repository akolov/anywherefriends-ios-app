//
//  AWFPerson.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFPerson.h"

#import <TransformerKit/TransformerKit.h>

#import "AWFValueTransformers.h"

@implementation AWFPerson

+ (instancetype)personFromDictionary:(NSDictionary *)dictionary {
  AWFPerson *person = [[AWFPerson alloc] init];
  person.personID = nilOrObjectForKey(dictionary, @"id");
  person.gender = [[[NSValueTransformer valueTransformerForName:AWFGenderValueTransformerName]
                    transformedValue:nilOrObjectForKey(dictionary, @"gender")] unsignedIntegerValue];
  person.firstName = [nilOrObjectForKey(dictionary, @"first_name") copy];
  person.lastName = [nilOrObjectForKey(dictionary, @"last_name") copy];
  person.bio = [nilOrObjectForKey(dictionary, @"bio") copy];
  person.weight = [nilOrObjectForKey(dictionary, @"weight") copy];
  person.height = [nilOrObjectForKey(dictionary, @"height") copy];
  person.hairColor = [nilOrObjectForKey(dictionary, @"hair_color") copy];
  person.hairLength = [nilOrObjectForKey(dictionary, @"hair_length") copy];
  person.eyeColor = [nilOrObjectForKey(dictionary, @"eye_color") copy];
  person.bodyBuild = [nilOrObjectForKey(dictionary, @"build") copy];
  person.placemark = [nilOrObjectForKey(dictionary, @"location") copy];

  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([nilOrObjectForKey(dictionary, @"latitude") doubleValue],
                                                                 [nilOrObjectForKey(dictionary, @"longitude") doubleValue]);

  NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[nilOrObjectForKey(dictionary, @"location_updated") doubleValue]];
  person.location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:timestamp];
  person.distance = [nilOrObjectForKey(dictionary, @"distance") doubleValue];
  person.birthday = [[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName]
                     reverseTransformedValue:nilOrObjectForKey(dictionary, @"birthday")];
  return person;
}

- (NSNumber *)age {
  if (!self.birthday) {
    return nil;
  }

  NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                                    fromDate:self.birthday
                                                                      toDate:[NSDate date]
                                                                     options:0];
  return @([ageComponents year]);
}

- (NSString *)fullName {
  if (self.firstName.length != 0 && self.lastName.length != 0) {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
  }
  else if (self.firstName.length != 0) {
    return self.firstName;
  }
  else if (self.lastName.length != 0) {
    return self.lastName;
  }
  return nil;
}

- (NSString *)abbreviatedName {
  if (self.firstName.length != 0 && self.lastName.length != 0) {
    return [[self.firstName substringWithRange:NSMakeRange(0, 1)] stringByAppendingString:
            [self.lastName substringWithRange:NSMakeRange(0, 1)]];
  }
  else if (self.firstName.length != 0) {
    return [self.firstName substringWithRange:NSMakeRange(0, 1)];
  }
  else if (self.lastName.length != 0) {
    return [self.lastName substringWithRange:NSMakeRange(0, 1)];
  }
  return nil;
}

- (NSString *)locationName {
  NSString *thoroughfare = self.placemark[@"thoroughfare"];
  NSString *locality = self.placemark[@"locality"];

  if ([thoroughfare length] != 0 && [locality length] != 0) {
    return [NSString stringWithFormat:@"%@, %@", thoroughfare, locality];
  }
  else if ([locality length] != 0) {
    return [NSString stringWithFormat:@"%@", locality];
  }
  else if ([thoroughfare length] != 0) {
    return [NSString stringWithFormat:@"%@", thoroughfare];
  }
  else {
    return NSLocalizedString(@"AWF_UNKNOWN_LOCATION", nil);
  }
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"AWFPerson: %@ %@ (%@) -> %f",
          self.personID, self.fullName, self.birthday, self.distance];
}

@end

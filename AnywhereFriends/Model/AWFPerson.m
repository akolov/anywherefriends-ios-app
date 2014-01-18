//
//  AWFPerson.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFPerson.h"
#import <TransformerKit/TransformerKit.h>

@implementation AWFPerson

+ (instancetype)personFromDictionary:(NSDictionary *)dictionary {
  AWFPerson *person = [[AWFPerson alloc] init];
  person.firstName = [nilOrObjectForKey(dictionary, @"first_name") copy];
  person.lastName = [nilOrObjectForKey(dictionary, @"last_name") copy];
  person.bio = [nilOrObjectForKey(dictionary, @"bio") copy];
  person.location = [[CLLocation alloc] initWithLatitude:[nilOrObjectForKey(dictionary, @"latitude") doubleValue]
                                               longitude:[nilOrObjectForKey(dictionary, @"longitude") doubleValue]];
  person.distance = [nilOrObjectForKey(dictionary, @"distance") doubleValue];
  person.birthday = [[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName]
                     reverseTransformedValue:nilOrObjectForKey(dictionary, @"birthday")];
  return person;
}

- (NSUInteger)age {
  NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                                    fromDate:self.birthday
                                                                      toDate:[NSDate date]
                                                                     options:0];
  return [ageComponents year];
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

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"AWFPerson: %@ (%@) -> %f", self.fullName, self.birthday, self.distance];
}

@end

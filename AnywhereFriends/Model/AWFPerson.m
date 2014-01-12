//
//  AWFPerson.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFPerson.h"

@implementation AWFPerson

+ (instancetype)personFromDictionary:(NSDictionary *)dictionary {
  AWFPerson *person = [[AWFPerson alloc] init];
  person.firstName = [dictionary[@"first_name"] copy];
  person.lastName = [dictionary[@"first_name"] copy];
  person.location = [[CLLocation alloc] initWithLatitude:[dictionary[@"latitude"] doubleValue]
                                               longitude:[dictionary[@"longitude"] doubleValue]];
  person.distance = [dictionary[@"distance"] doubleValue];
  return person;
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

@end

//
//  AWFPerson.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFPerson.h"


@interface AWFPerson ()

// Private interface goes here.

@end


@implementation AWFPerson

- (NSNumber *)age {
  if (!self.birthday) {
    return nil;
  }

  NSDateComponents* ageComponents =
    [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self.birthday toDate:[NSDate date] options:0];
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
  if ([self.locationThoroughfare length] != 0 && [self.locationLocality length] != 0) {
    return [NSString stringWithFormat:@"%@, %@", self.locationThoroughfare, self.locationLocality];
  }
  else if ([self.locationLocality length] != 0) {
    return [NSString stringWithFormat:@"%@", self.locationLocality];
  }
  else if ([self.locationThoroughfare length] != 0) {
    return [NSString stringWithFormat:@"%@", self.locationThoroughfare];
  }
  else {
    return NSLocalizedString(@"AWF_UNKNOWN_LOCATION", nil);
  }
}

- (CLLocationCoordinate2D)locationCoordinate {
  if (!self.locationLatitude || !self.locationLongitude) {
    return kCLLocationCoordinate2DInvalid;
  }

  return CLLocationCoordinate2DMake(self.locationLatitudeValue, self.locationLongitudeValue);
}

@end

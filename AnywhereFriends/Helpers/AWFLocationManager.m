//
//  AWFLocationManager.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFLocationManager.h"


NSString *AWFLocationManagerDidUpdateLocationsNotification = @"AWFLocationManagerDidUpdateLocationsNotification";
NSString *AWFLocationManagerLocationUserInfoKey = @"AWFLocationManagerLocationUserInfoKey";


@interface AWFLocationManager () <CLLocationManagerDelegate>

@end


@implementation AWFLocationManager

+ (instancetype)sharedManager {
  static AWFLocationManager *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[[self class] alloc] init];
  });
  return instance;
}

+ (CLLocationDistance)distanceBetweenCoordinates:(CLLocationCoordinate2D)c1 :(CLLocationCoordinate2D)c2 {
  CLLocation *a = [[CLLocation alloc] initWithLatitude:c1.latitude longitude:c1.longitude];
  CLLocation *b = [[CLLocation alloc] initWithLatitude:c2.latitude longitude:c2.longitude];
  return [a distanceFromLocation:b];
}

- (id)init {
  self = [super init];
  if (self) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100.0;

    [_locationManager startUpdatingLocation];
  }
  return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.lastObject;
  NSDate *eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (abs(howRecent) < 30.0) {
    _currentLocation = location;
    NSDictionary *userInfo = @{AWFLocationManagerLocationUserInfoKey: location};
    [[NSNotificationCenter defaultCenter] postNotificationName:AWFLocationManagerDidUpdateLocationsNotification
                                                        object:nil
                                                      userInfo:userInfo];
  }
}
@end

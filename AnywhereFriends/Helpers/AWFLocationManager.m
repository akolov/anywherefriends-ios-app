//
//  AWFLocationManager.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLocationManager.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFSession.h"

NSString *const AWFLocationManagerDidUpdateLocationsNotification = @"AWFLocationManagerDidUpdateLocationsNotification";
NSString *const AWFLocationManagerLocationUserInfoKey = @"AWFLocationManagerLocationUserInfoKey";

@interface AWFLocationManager () <CLLocationManagerDelegate>

- (BOOL)validateLocationServicesAvailability;

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

+ (CLLocationDistance)distanceBetween:(CLLocationCoordinate2D)c1 and:(CLLocationCoordinate2D)c2 {
  CLLocation *a = [[CLLocation alloc] initWithLatitude:c1.latitude longitude:c1.longitude];
  CLLocation *b = [[CLLocation alloc] initWithLatitude:c2.latitude longitude:c2.longitude];
  return [a distanceFromLocation:b];
}

- (id)init {
  self = [super init];
  if (self) {
    _geocoder = [[CLGeocoder alloc] init];

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100.0;

    if ([self validateLocationServicesAvailability]) {
      [_locationManager startUpdatingLocation];
    }

    @weakify(self);
    [RACObserveNotificationUntilDealloc(AWFUserDidLoginNotification) subscribeNext:^(NSNotification *note) {
      @strongify(self);
      if ([self validateLocationServicesAvailability]) {
        [self.locationManager startUpdatingLocation];
      }
    }];
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

    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      if (placemarks) {
        CLPlacemark *placemark = [placemarks lastObject];
        [[[AWFSession sharedSession] updateUserSelfLocation:placemark] subscribeError:^(NSError *error) {
          ErrorLog(error.localizedDescription);
        }];
      }
      else {
        ErrorLog(error.localizedDescription);
      }
    }];

    NSDictionary *userInfo = @{AWFLocationManagerLocationUserInfoKey: location};
    [[NSNotificationCenter defaultCenter] postNotificationName:AWFLocationManagerDidUpdateLocationsNotification
                                                        object:nil
                                                      userInfo:userInfo];
  }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if ([self validateLocationServicesAvailability]) {
    [self.locationManager startUpdatingLocation];
  }
}

#pragma mark - Private methods

- (BOOL)validateLocationServicesAvailability {
  if (![AWFSession isLoggedIn]) {
    return NO;
  }

  // TODO: Replace with better alerts
  if (![CLLocationManager locationServicesEnabled]) {
    // TODO: Tell user that location services are disabled
    return NO;
  }
  else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
    // TODO: Tell user that location services are restricted
    return NO;
  }

  return YES;
}

@end

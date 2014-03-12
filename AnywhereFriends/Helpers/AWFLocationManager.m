//
//  AWFLocationManager.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFLocationManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFSession.h"

NSString *AWFLocationManagerDidUpdateLocationsNotification = @"AWFLocationManagerDidUpdateLocationsNotification";
NSString *AWFLocationManagerLocationUserInfoKey = @"AWFLocationManagerLocationUserInfoKey";

@interface AWFLocationManager () <CLLocationManagerDelegate>

+ (BOOL)validateLocationServicesAvailability;

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

    if ([self.class validateLocationServicesAvailability]) {
      [_locationManager startUpdatingLocation];
    }
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
  [self.class validateLocationServicesAvailability];
}

#pragma mark - Private methods

+ (BOOL)validateLocationServicesAvailability {
  // TODO: Replace with better alerts
  if (![CLLocationManager locationServicesEnabled]) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AWF_LOCATION_SERVICES_DISABLED_TITLE", nil)
                                message:NSLocalizedString(@"AWF_LOCATION_SERVICES_DISABLED_MESSAGE", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"AWF_DISMISS", nil)
                      otherButtonTitles:nil] show];
    return NO;
  }
  else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AWF_LOCATION_SERVICES_DISABLED_RESTRICTED_TITLE", nil)
                                message:NSLocalizedString(@"AWF_LOCATION_SERVICES_DISABLED_RESTRICTED_MESSAGE", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"AWF_DISMISS", nil)
                      otherButtonTitles:nil] show];
    return NO;
  }

  return YES;
}

@end

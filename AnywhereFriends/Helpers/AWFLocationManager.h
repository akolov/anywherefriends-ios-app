//
//  AWFLocationManager.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import Foundation;
@import CoreLocation;

OBJC_EXTERN NSString *const AWFLocationManagerDidUpdateLocationsNotification;
OBJC_EXTERN NSString *const AWFLocationManagerLocationUserInfoKey;

@interface AWFLocationManager : NSObject

@property (nonatomic, strong, readonly) CLGeocoder *geocoder;
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (instancetype)sharedManager;
+ (CLLocationDistance)distanceBetween:(CLLocationCoordinate2D)c1 and:(CLLocationCoordinate2D)c2;

@end

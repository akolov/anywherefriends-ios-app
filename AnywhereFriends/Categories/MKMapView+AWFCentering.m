//
//  MKMapView+AWFCentering.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "MKMapView+AWFCentering.h"

@implementation MKMapView (AWFCentering)

#pragma mark - Private methods

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate spanInMeters:(double)meters animated:(BOOL)animated {
  MKCoordinateRegion region;
  region.center.latitude = coordinate.latitude;
  region.center.longitude = coordinate.longitude;
  region.span.latitudeDelta = meters * AWF_DEGREES_IN_METRE;
  region.span.longitudeDelta = meters * AWF_DEGREES_IN_METRE;
  [self setRegion:region animated:YES];
}

@end

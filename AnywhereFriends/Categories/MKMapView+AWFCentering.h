//
//  MKMapView+AWFCentering.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import MapKit;

@interface MKMapView (AWFCentering)

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate spanInMeters:(double)meters animated:(BOOL)animated;

@end

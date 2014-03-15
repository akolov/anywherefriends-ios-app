//
//  AWFMapViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import MapKit;
@import UIKit;

@class AWFPerson;

@interface AWFMapViewController : UIViewController

@property (nonatomic, strong) MKMapView *mapView;

- (instancetype)initWithPerson:(AWFPerson *)person;

@end

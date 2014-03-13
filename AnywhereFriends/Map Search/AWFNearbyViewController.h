//
//  AWFNearbyViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import MapKit;

#import "AWFViewController.h"

@interface AWFNearbyViewController : AWFViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;

@end

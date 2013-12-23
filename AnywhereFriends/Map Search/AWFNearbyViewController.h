//
//  AWFNearbyViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface AWFNearbyViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;

@end

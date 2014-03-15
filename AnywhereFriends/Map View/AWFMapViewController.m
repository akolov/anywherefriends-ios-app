//
//  AWFMapViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFMapViewController.h"

#import "AWFPerson.h"
#import "MKMapView+AWFCentering.h"

static double AWFRadius = 3000.0;

@interface AWFMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) AWFPerson *person;

@end

@implementation AWFMapViewController

- (instancetype)initWithPerson:(AWFPerson *)person {
  self = [super init];
  if (self) {
    self.title = person.fullName;
    self.person = person;
  }
  return self;
}

#pragma mark - View Life Cycle

- (void)loadView {
  self.mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  self.view = self.mapView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.mapView setCoordinate:self.person.location.coordinate spanInMeters:AWFRadius animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  [annotation setCoordinate:self.person.location.coordinate];
  [annotation setTitle:self.person.fullName];
  [annotation setSubtitle:[NSString stringWithFormat:@"%@ — %.2f km",
                           self.person.locationName, self.person.distance / 1000.0]];

  [self.mapView addAnnotation:annotation];
  [self.mapView showAnnotations:@[annotation] animated:YES];
}

@end

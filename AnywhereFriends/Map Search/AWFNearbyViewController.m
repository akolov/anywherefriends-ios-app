//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import CoreLocation;

#import "AWFNearbyViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "UIBezierPath+MenuGlyph.h"
#import "UIBezierPath+MessagesGlyph.h"

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFLayoutGuide.h"
#import "AWFLocationManager.h"
#import "AWFNavigationBar.h"
#import "AWFNearbyViewCell.h"
#import "AWFPerson.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"

static double AWFRadius = 20000.0;
static NSUInteger AWFPageSize = 20;

@interface AWFNearbyViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *mapContainerView;
@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSDictionary *annotations;
@property (nonatomic, assign) UIEdgeInsets defaultTableViewContentInset;

- (void)onNotification:(NSNotification *)notification;

- (void)centerAndZoomMapAtCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters;
- (void)lookupUsersAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters;

@end

@implementation AWFNearbyViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor blackColor];

  {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.opaque = NO;
    self.tableView.rowHeight = 60.0f;

    CGFloat insetTop = [self.topLayoutGuide length];
    CGFloat bottomInset = [self.bottomLayoutGuide length];
    self.defaultTableViewContentInset = UIEdgeInsetsMake(insetTop + self.tableView.rowHeight * 4.0f, 0, bottomInset, 0);

    self.tableView.contentInset = self.defaultTableViewContentInset;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(insetTop, 0, bottomInset, 0);

    [self.tableView registerClass:[AWFNearbyViewCell class] forCellReuseIdentifier:[AWFNearbyViewCell reuseIdentifier]];
    [self.view addSubview:self.tableView];
  }

  // Set up map view

  self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  self.mapView.scrollEnabled = NO;

  self.mapContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.tableView.rowHeight * 4.0f, self.tableView.bounds.size.width, self.tableView.rowHeight * 4.0f)];
  self.mapContainerView.clipsToBounds = YES;
  [self.mapContainerView addSubview:self.mapView];
  [self.mapView setFrameOriginY:(self.mapContainerView.bounds.size.height - self.mapView.bounds.size.height) / 2.0f];

  [self.tableView addSubview:self.mapContainerView];

  // Actions

  [[NSNotificationCenter defaultCenter]
   addObserver:self selector:@selector(onNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
  [[NSNotificationCenter defaultCenter]
   addObserver:self selector:@selector(onNotification:) name:AWFLocationManagerDidUpdateLocationsNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (id <UILayoutSupport>)topLayoutGuide {
  return [[AWFLayoutGuide alloc] initWithLength:64.0f];
}

- (id <UILayoutSupport>)bottomLayoutGuide {
  return [[AWFLayoutGuide alloc] initWithLength:CGRectGetHeight(self.navigationController.toolbar.bounds)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFNearbyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFNearbyViewCell reuseIdentifier]
                                                            forIndexPath:indexPath];
  AWFPerson *person = self.people[indexPath.row];
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  cell.placeholderView.text = person.abbreviatedName;
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.locationLabel.text = [NSString stringWithFormat:@"%.2f m — %@", person.distance, person.locationName];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.scrollEnabled) {
    AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPerson:self.people[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else {
    self.mapView.scrollEnabled = NO;
    self.tableView.scrollEnabled = YES;

    [self.mapView showAnnotations:[self.annotations allValues] animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
      self.tableView.contentInset = self.defaultTableViewContentInset;
    }];
  }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.scrollEnabled) {
    AWFPerson *person = self.people[indexPath.row];
    id <MKAnnotation> annotation = self.annotations[person.personID];
    [self.mapView selectAnnotation:annotation animated:YES];
  }
  else {
    self.mapView.scrollEnabled = NO;
    self.tableView.scrollEnabled = YES;

    [self.mapView showAnnotations:[self.annotations allValues] animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
      self.tableView.contentInset = self.defaultTableViewContentInset;
    }];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!self.tableView.scrollEnabled) {
    return;
  }

  CGFloat dy = scrollView.contentOffset.y + [self.topLayoutGuide length];
  CGFloat threshold = (CGRectGetHeight(self.view.bounds) - self.tableView.rowHeight * 2.5f -
                       [self.topLayoutGuide length] - [self.bottomLayoutGuide length]);
  CGFloat position = (CGRectGetHeight(self.view.bounds) - self.tableView.rowHeight * 0.5f -
                      [self.topLayoutGuide length] - [self.bottomLayoutGuide length]);

  if (dy < 0) {
    self.mapContainerView.frame = ({
      CGRect frame = self.mapContainerView.frame;
      frame.origin.y = dy;
      frame.size.height = -dy;
      frame;
    });

    if (-dy >= threshold) {
      [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:0 animations:^{
        self.tableView.contentOffset = CGPointMake(0, -position);
        self.tableView.contentInset = ({
          UIEdgeInsets inset = self.tableView.contentInset;
          inset.top = position;
          inset;
        });
      } completion:NULL];

      self.tableView.scrollEnabled = NO;
      self.mapView.scrollEnabled = YES;

      AWFPerson *first = self.people.firstObject;
      if (first) {
        [self.mapView showAnnotations:@[self.annotations[first.personID], self.mapView.userLocation] animated:YES];
      }
    }
  }

  self.mapView.frame = ({
    CGRect frame = self.mapView.frame;
    frame.origin.y = CGRectGetMidY(self.mapContainerView.bounds) - CGRectGetMidY(self.mapView.bounds);
    frame;
  });
}

#pragma mark - Actions

- (void)onNotification:(NSNotification *)notification {
  if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
    CLLocationCoordinate2D coordinate = [AWFLocationManager sharedManager].currentLocation.coordinate;
    [self centerAndZoomMapAtCoordinate:coordinate andSpanInMeters:AWFRadius];
    [self lookupUsersAroundCenterCoordinate:coordinate andSpanInMeters:AWFRadius];
  }
  else if ([notification.name isEqualToString:AWFLocationManagerDidUpdateLocationsNotification]) {
    CLLocation *location = notification.userInfo[AWFLocationManagerLocationUserInfoKey];
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self centerAndZoomMapAtCoordinate:coordinate andSpanInMeters:AWFRadius];
    [self lookupUsersAroundCenterCoordinate:coordinate andSpanInMeters:AWFRadius];
  }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  if ([view isKindOfClass:[MKPinAnnotationView class]]) {
    [(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorGreen];
  }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  if ([view isKindOfClass:[MKPinAnnotationView class]]) {
    [(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorRed];
  }
}

#pragma mark - Accessors

- (void)setPeople:(NSArray *)people {
  _people = people;
  [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)centerAndZoomMapAtCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters {
  MKCoordinateRegion region;
  region.center.latitude = coordinate.latitude;
  region.center.longitude = coordinate.longitude;
  region.span.latitudeDelta = meters * AWF_DEGREES_IN_METRE;
  region.span.longitudeDelta = meters * AWF_DEGREES_IN_METRE;
  [self.mapView setRegion:region animated:YES];
}

- (void)lookupUsersAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters {
  @weakify(self);
  [[[AWFSession sharedSession] getUsersAtCoordinate:coordinate
                                        withRadius:AWFRadius
                                        pageNumber:0
                                          pageSize:AWFPageSize]
   subscribeNext:^(NSArray *people) {
     @strongify(self);

     NSMutableDictionary *annotations = [NSMutableDictionary dictionary];

     for (AWFPerson *person in people) {
       MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
       [annotation setCoordinate:person.location.coordinate];
       [annotation setTitle:person.fullName];
       [annotation setSubtitle:[NSString stringWithFormat:@"%.2f km", person.distance / 1000.0]];

       annotations[person.personID] = annotation;

       [self.mapView addAnnotation:annotation];
     }

     self.annotations = annotations;
     self.people = people;

     [self.mapView showAnnotations:[self.annotations allValues] animated:YES];
   }
   error:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

@end

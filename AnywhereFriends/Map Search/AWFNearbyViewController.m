//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import CoreLocation;

#import "AWFNearbyViewController.h"

#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIBezierPath+MenuGlyph.h"
#import "UIBezierPath+MessagesGlyph.h"

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFLayoutGuide.h"
#import "AWFLocationManager.h"
#import "AWFNavigationBar.h"
#import "AWFNavigationTitleView.h"
#import "AWFNearbyViewCell.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"


static double AWFRadius = 20000.0;
static NSUInteger AWFPageSize = 20;


@interface AWFNearbyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *mapContainerView;
@property (nonatomic, strong) NSArray *users;

- (void)onNotification:(NSNotification *)notification;

- (void)centerAndZoomMapAtCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters;
- (void)lookupUsersAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate andSpanInMeters:(double)meters;

@end


@implementation AWFNearbyViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_PEOPLE_VIEW_CONTROLLER_TITLE", nil);
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  UIBezierPath *menuIcon = [UIBezierPath menuGlyph];

  AWFIconButton *menuButton = [[AWFIconButton alloc] initWithFrame:CGRectMake(0, 0, menuIcon.bounds.size.width, menuIcon.bounds.size.height)];
  menuButton.icon.path = menuIcon;
  [menuButton setIconColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];

  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
  self.navigationItem.leftBarButtonItem = leftBarButtonItem;

  UIBezierPath *messagesIcon = [UIBezierPath messagesGlyph];
  [messagesIcon applyTransform:CGAffineTransformMakeScale(1.3f, 1.3f)];

  AWFIconButton *messagesButton = [[AWFIconButton alloc] initWithFrame:CGRectMake(0, 0, messagesIcon.bounds.size.width, messagesIcon.bounds.size.height)];
  messagesButton.icon.path = messagesIcon;
  [messagesButton setIconColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];

  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messagesButton];
  self.navigationItem.rightBarButtonItem = rightBarButtonItem;

  // Set up view

  self.view.backgroundColor = [UIColor blackColor];

  // Set up collection view
  {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.opaque = NO;
    self.tableView.rowHeight = 60.0f;

    [self.tableView registerClass:[AWFNearbyViewCell class] forCellReuseIdentifier:[AWFNearbyViewCell reuseIdentifier]];
    [self.view addSubview:self.tableView];
  }

  // Set up map view

  self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  self.mapView.showsUserLocation = YES;

  self.mapContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.rowHeight * 4.0f)];
  self.mapContainerView.clipsToBounds = YES;
  [self.mapContainerView addSubview:self.mapView];
  [self.mapView setFrameOriginY:(self.mapContainerView.bounds.size.height - self.mapView.bounds.size.height) / 2.0f];

  [self.tableView addSubview:self.mapContainerView];

  // Actions

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:)
                                               name:UIApplicationWillEnterForegroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:)
                                               name:AWFLocationManagerDidUpdateLocationsNotification object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  CGFloat insetTop = [self.topLayoutGuide length];
  CGFloat bottomInset = [self.bottomLayoutGuide length];
  self.tableView.contentInset = UIEdgeInsetsMake(insetTop, 0, bottomInset, 0);
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(insetTop, 0, bottomInset, 0);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (id <UILayoutSupport>)topLayoutGuide {
  return [[AWFLayoutGuide alloc] initWithLength:64.0f];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFNearbyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFNearbyViewCell reuseIdentifier]
                                                            forIndexPath:indexPath];

  NSString *distance = [self.users[indexPath.row][@"distance"] stringValue];
  NSString *firstName = self.users[indexPath.row][@"first_name"];
  NSString *lastName = self.users[indexPath.row][@"first_name"];
  NSString *name, *abbreviation;

  if (firstName.length != 0 && lastName.length != 0) {
    name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    abbreviation = [[firstName substringWithRange:NSMakeRange(0, 1)] stringByAppendingString:
                    [lastName substringWithRange:NSMakeRange(0, 1)]];
  }
  else if (firstName) {
    name = firstName;
    abbreviation = [firstName substringWithRange:NSMakeRange(0, 1)];
  }
  else if (lastName) {
    name = lastName;
    abbreviation = [lastName substringWithRange:NSMakeRange(0, 1)];
  }
  else {
    name = @"Anonymous";
    abbreviation = @"XX";
  }

  cell.placeholderView.text = abbreviation;
  cell.imageView.image = [UIImage imageNamed:[name stringByAppendingString:@".jpg"]];
  cell.nameLabel.text = name;
  cell.locationLabel.text = distance;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat dy = scrollView.contentOffset.y + [self.topLayoutGuide length];
  if (dy < 0) {
    [self.mapContainerView setFrameOriginY:dy];
    [self.mapContainerView setFrameHeight:self.tableView.rowHeight * 4.0f - dy];
  }
  else {
    [self.mapContainerView setFrameOriginY:0];
    [self.mapContainerView setFrameHeight:self.tableView.rowHeight * 4.0f];
  }

  [self.mapView setFrameOriginY:(self.mapContainerView.bounds.size.height - self.mapView.bounds.size.height) / 2.0f];
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

#pragma mark - Getters and Setters

- (void)setUsers:(NSArray *)users {
  _users = users;
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
   subscribeNext:^(NSDictionary *data) {
     @strongify(self);
     self.users = data[@"users"];

     CLLocationCoordinate2D max;

     for (NSDictionary *user in self.users) {
       CLLocationDegrees latitude = [user[@"latitude"] doubleValue];
       CLLocationDegrees longitude = [user[@"longitude"] doubleValue];

       if (max.latitude < latitude) {
         max.latitude = latitude;
       }

       if (max.longitude < longitude) {
         max.longitude = longitude;
       }

       CLLocationDistance distance = [AWFLocationManager distanceBetweenCoordinates:max :coordinate];
       NSString *firstName = user[@"first_name"];
       NSString *lastName = user[@"first_name"];

       MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
       [annotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
       [annotation setTitle:[firstName stringByAppendingString:lastName]];
       [annotation setSubtitle:[NSString stringWithFormat:@"%.2f km", distance / 1000.0]];
       [self.mapView addAnnotation:annotation];
     }

     CLLocationDistance distance = [AWFLocationManager distanceBetweenCoordinates:max :coordinate];
     [self centerAndZoomMapAtCoordinate:coordinate andSpanInMeters:distance * 4.0];
   }
   error:^(NSError *error) {
     ErrorLog(error);
   }];
}

@end

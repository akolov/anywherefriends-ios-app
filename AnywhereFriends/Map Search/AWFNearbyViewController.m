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
#import "AWFPerson.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"


static double AWFRadius = 20000.0;
static NSUInteger AWFPageSize = 20;


@interface AWFNearbyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *mapContainerView;
@property (nonatomic, strong) NSArray *people;

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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  CGFloat insetTop = [self.topLayoutGuide length];
  CGFloat bottomInset = [self.bottomLayoutGuide length];
  self.tableView.contentInset = UIEdgeInsetsMake(insetTop + self.tableView.rowHeight * 4.0f, 0, bottomInset, 0);
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
  cell.locationLabel.text = [NSString stringWithFormat:@"%.2f m", person.distance];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPerson:self.people[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  [self.mapView selectAnnotation:nil animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat dy = scrollView.contentOffset.y + [self.topLayoutGuide length];
  if (dy < 0) {
//    if ((self.tableView.rowHeight * 4.0f - dy) >
//        CGRectGetHeight(self.view.bounds) - self.tableView.rowHeight * 2.0f -
//        [self.topLayoutGuide length] - [self.bottomLayoutGuide length]) {
//    }
//    else {
      [self.mapContainerView setFrameOriginY:dy];
      [self.mapContainerView setFrameHeight:-dy];
//    }
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

     CLLocationCoordinate2D max;

     for (AWFPerson *person in people) {
       if (max.latitude < person.location.coordinate.latitude) {
         max.latitude = person.location.coordinate.latitude;
       }

       if (max.longitude < person.location.coordinate.longitude) {
         max.longitude = person.location.coordinate.longitude;
       }

       MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
       [annotation setCoordinate:person.location.coordinate];
       [annotation setTitle:person.fullName];
       [annotation setSubtitle:[NSString stringWithFormat:@"%.2f km", person.distance / 1000.0]];
       [self.mapView addAnnotation:annotation];
     }

     self.people = people;

     CLLocationDistance distance = [AWFLocationManager distanceBetweenCoordinates:max :coordinate];
     [self centerAndZoomMapAtCoordinate:coordinate andSpanInMeters:distance * 4.0];
   }
   error:^(NSError *error) {
     ErrorLog(error);
   }];
}

@end

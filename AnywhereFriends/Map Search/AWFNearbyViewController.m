//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import CoreLocation;

#import "AWFNearbyViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIBezierPath+MenuGlyph.h"
#import "UIBezierPath+MessagesGlyph.h"

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFLocationManager.h"
#import "AWFNavigationBar.h"
#import "AWFNavigationTitleView.h"
#import "AWFNearbyViewCell.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"


static CGSize AWFCollectionItemSize = {106.0f, 106.0f};


@interface AWFNearbyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *users;

- (void)showSegmentedControl;
- (void)hideSegmentedControl;

- (void)onNotification:(NSNotification *)notification;

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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = AWFCollectionItemSize;
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.opaque = NO;

    [self.tableView registerClass:[AWFNearbyViewCell class] forCellReuseIdentifier:[AWFNearbyViewCell reuseIdentifier]];
    [self.view addSubview:self.tableView];
  }

  // Set up map view

  MKMapView *mapView = [MKMapView autolayoutView];
  mapView.showsUserLocation = YES;

  [self.view insertSubview:mapView atIndex:0];
  self.mapView = mapView;

  // Set up layout

  NSDictionary *const views = NSDictionaryOfVariableBindings(mapView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];

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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
  [self showSegmentedControl];

  CGFloat insetTop = self.view.bounds.size.height - [self.bottomLayoutGuide length] - AWFCollectionItemSize.height * 1.5f;
  CGFloat bottomInset = [self.bottomLayoutGuide length];
  self.tableView.contentInset = UIEdgeInsetsMake(insetTop, 0, bottomInset, 0);
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(insetTop, 0, bottomInset, 0);

  [self lookupNearbyUsers];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self hideSegmentedControl];
} 

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
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
  NSString *name;

  if (firstName && lastName) {
    name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  }
  else if (firstName) {
    name = firstName;
  }
  else if (lastName) {
    name = firstName;
  }
  else {
    name = @"Anonymous";
  }

  cell.imageView.image = [UIImage imageNamed:[name stringByAppendingString:@".jpg"]];
  cell.textLabel.text = name;
  cell.detailTextLabel.text = distance;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Segmented control

- (void)showSegmentedControl {
  AWFNavigationBar *navigationBar = (AWFNavigationBar *)self.navigationController.navigationBar;
  navigationBar.extended = YES;

  NSArray *segments = @[NSLocalizedString(@"AWF_SEARCH_SCOPE_NEARBY_TITLE", @"Title for the Nearby search scope"),
                        NSLocalizedString(@"AWF_SEARCH_SCOPE_FRIENDS_TITLE", @"Title for the Friends search scope"),
                        NSLocalizedString(@"AWF_SEARCH_SCOPE_SEARCHES_TITLE", @"Title for the Searches search scope")];
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];

  CGRect frame = segmentedControl.frame;
  frame.origin.x = 8.0f;
  frame.origin.y += navigationBar.bounds.size.height;
  frame.size.width = navigationBar.bounds.size.width - 16.0f;
  frame.size.height = 27.0f;

  segmentedControl.frame = frame;
  segmentedControl.selectedSegmentIndex = 0;

  [self.navigationController.navigationBar addSubview:segmentedControl];
  self.segmentedControl = segmentedControl;
}

- (void)hideSegmentedControl {
  AWFNavigationBar *navigationBar = (AWFNavigationBar *)self.navigationController.navigationBar;
  navigationBar.extended = NO;
  [self.segmentedControl removeFromSuperview];
}

#pragma mark - Actions

- (void)onNotification:(NSNotification *)notification {
  if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
    [self lookupNearbyUsers];
  }
  else if ([notification.name isEqualToString:AWFLocationManagerDidUpdateLocationsNotification]) {
    [self lookupNearbyUsers];
  }
}

#pragma mark - Getters and Setters

- (void)setUsers:(NSArray *)users {
  _users = users;
  [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)lookupNearbyUsers {
  CLLocation *location = [AWFLocationManager sharedManager].currentLocation;
  [[[AWFSession sharedSession] getUsersAtCoordinate:location.coordinate
                                        withRadius:100000.0
                                        pageNumber:0
                                          pageSize:100]
   subscribeNext:^(NSDictionary *data) {
     self.users = data[@"users"];
   }
   error:^(NSError *error) {
     NSLog(@"*** ERROR: %@", error);
   }];
}

@end

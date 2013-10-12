//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNearbyViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIBezierPath+MenuGlyph.h"
#import "UIBezierPath+MessagesGlyph.h"

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFNavigationBar.h"
#import "AWFNavigationTitleView.h"
#import "AWFPersonCollectionViewCell.h"
#import "AWFProfileViewController.h"


static CGFloat const kHeaderHeight = 224.0f;
static CGFloat const kButtonBarHeight = 44.0f;


@interface AWFNearbyViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *temporaryData;

- (void)showSegmentedControl;
- (void)hideSegmentedControl;

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
    layout.itemSize = CGSizeMake(106.0f, 106.0f);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.opaque = NO;

    [self.collectionView registerClass:[AWFPersonCollectionViewCell class]
            forCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier]];
    [self.view addSubview:self.collectionView];
  }

  // Set up map view

  CGRect mapFrame = self.view.bounds;
  mapFrame.size.height = kHeaderHeight + self.navigationController.navigationBar.bounds.size.height;

  MKMapView *mapView = [MKMapView autolayoutView];
  mapView.showsUserLocation = YES;

  [self.view insertSubview:mapView atIndex:0];
  self.mapView = mapView;

  // Set up layout

  NSDictionary *const views = NSDictionaryOfVariableBindings(mapView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]" options:0 metrics:nil views:views]];

  NSLayoutConstraint *headerHeightConstraint = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:kHeaderHeight];
  [self.view addConstraint:headerHeightConstraint];

  RAC(headerHeightConstraint, constant) = [[RACAble(self.collectionView.contentOffset)
                                            filter:^BOOL(id value) {
                                              return [value CGPointValue].y <= 0;
                                            }]
                                           map:^id(id value) {
                                             return @(-[value CGPointValue].y);
                                           }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
  [self showSegmentedControl];

  CGFloat bottomInset = self.tabBarController.tabBar.bounds.size.height;
  CGFloat topIndicatorInset = [(AWFNavigationBar *)self.navigationController.navigationBar backgroundView].bounds.size.height;
  self.collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight + kButtonBarHeight, 0, bottomInset, 0);
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(topIndicatorInset, 0, bottomInset, 0);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self hideSegmentedControl];
} 

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.temporaryData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  AWFPersonCollectionViewCell *cell = (AWFPersonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

  NSString *name = self.temporaryData[indexPath.row];
  cell.imageView.image = [UIImage imageNamed:[name stringByAppendingString:@".jpg"]];
  cell.nameLabel.text = name;
  return cell;
}

#pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Private methods

- (NSArray *)temporaryData {
  if (!_temporaryData) {
    _temporaryData = @[
                       @"Marissa",   // 1
                       @"Lorenza",   // 2
                       @"Matze",     // 3
                       @"Veronica",  // 4
                       @"Jacky",     // 5
                       @"Marine",    // 6
                       @"Victoria",  // 7
                       @"Alessio",   // 8
                       @"Ajda",      // 9
                       @"Andrea",    // 10
                       @"Carrie",    // 11
                       @"Damien",    // 12
                       @"Ebba",      // 13
                       @"Emilia",    // 14
                       @"Kenza",     // 15
                       @"Kristina",  // 16
                       @"Lauren",    // 17
                       @"Marie",     // 18
                       @"Max",       // 19
                       @"Michael",   // 20
                       @"Olivia",    // 21
                       ];
  }
  return _temporaryData;
}

@end

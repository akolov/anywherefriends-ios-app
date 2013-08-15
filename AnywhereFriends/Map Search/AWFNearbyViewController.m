//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNearbyViewController.h"

#import <iOS-blur/AMBlurView.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFNavigationTitleView.h"
#import "AWFPersonCollectionViewCell.h"


static CGFloat const kHeaderHeight = 164.0f;
static CGFloat const kButtonBarHeight = 44.0f;


@interface AWFNearbyViewController ()

@property (nonatomic, strong) NSArray *temporaryData;

@end


@implementation AWFNearbyViewController

- (id)init {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(104.0f, 104.0f);
  layout.minimumInteritemSpacing = 2.0f;
  layout.minimumLineSpacing = 2.0f;
  layout.sectionInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
  return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = YES;
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  // Set up map view

  CGRect mapFrame = self.view.bounds;
  mapFrame.size.height = kHeaderHeight + self.navigationController.navigationBar.bounds.size.height;

  MKMapView *mapView = [MKMapView autolayoutView];
  mapView.showsUserLocation = YES;

  [self.view insertSubview:mapView atIndex:0];
  self.mapView = mapView;

  // Set up button bar

  UIToolbar *buttonBar = [UIToolbar autolayoutView];
  buttonBar.barStyle = UIBarStyleBlackTranslucent;
  [self.view insertSubview:buttonBar aboveSubview:mapView];

  // Set up collection view

  self.collectionView.backgroundColor = nil;
  self.collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight + kButtonBarHeight, 0, 0, 0);
  self.collectionView.opaque = NO;
  [self.collectionView registerClass:[AWFPersonCollectionViewCell class] forCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier]];

  // Set up layout

  NSDictionary *const views = NSDictionaryOfVariableBindings(buttonBar, mapView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonBar]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:kButtonBarHeight]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];

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
  cell.label.text = name;
  return cell;
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
                       @"Olga",      // 21
                       @"Olivia",    // 22
                       @"Sebastian", // 23
                       ];
  }
  return _temporaryData;
}

@end

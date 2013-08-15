//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNearbyViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFNavigationTitleView.h"
#import "AWFPersonCollectionViewCell.h"


static CGFloat const kHeaderHeight = 164.0f;

@interface AWFNearbyViewController ()

@end


@implementation AWFNearbyViewController

- (id)init {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(104.0f, 130.0f);
  layout.minimumInteritemSpacing = 2.0f;
  layout.minimumLineSpacing = 2.0f;
  layout.sectionInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
  return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = YES;
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  CGRect mapFrame = self.view.bounds;
  mapFrame.size.height = kHeaderHeight + self.navigationController.navigationBar.bounds.size.height;

  MKMapView *mapView = [[MKMapView alloc] initWithFrame:mapFrame];
  mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  mapView.showsUserLocation = YES;

  [self.view insertSubview:mapView atIndex:0];
  self.mapView = mapView;

  // Set up collection view

  self.collectionView.backgroundColor = nil;
  self.collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
  [self.collectionView registerClass:[AWFPersonCollectionViewCell class] forCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier]];

  // Set up layout

  RAC(self.mapView.frame) = [[RACAble(self.collectionView.contentOffset)
                              filter:^BOOL(id value) {
                                return [value CGPointValue].y <= 0;
                              }]
                             map:^id(id value) {
                               CGPoint dp = [value CGPointValue];
                               CGFloat dy = -dp.y;
                               CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, dy);
                               return [NSValue valueWithCGRect:rect];
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
  return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
  cell.backgroundColor = [UIColor redColor];
  return cell;
}

@end

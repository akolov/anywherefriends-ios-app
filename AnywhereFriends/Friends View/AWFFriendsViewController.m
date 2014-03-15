//
//  AWFFriendsViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFFriendsViewController.h"

@import MapKit;

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <Haneke/Haneke.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFFriendsViewCell.h"
#import "AWFLocationManager.h"
#import "AWFMapViewController.h"
#import "AWFPerson.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"

static NSString *AWFMapThumbnailCacheFormatName = @"AWFMapThumbnailCacheFormatName";

@interface AWFFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id locationObserver;
@property (nonatomic, strong) NSArray *people;

- (void)getFriends;

@end

@implementation AWFFriendsViewController

- (void)dealloc {
  if (self.locationObserver) {
    [[NSNotificationCenter defaultCenter] removeObserver:self.locationObserver];
  }
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  HNKCacheFormat *format = [[HNKCacheFormat alloc] initWithName:AWFMapThumbnailCacheFormatName];
  format.size = CGSizeMake(40.0f, 40.0f);
  format.scaleMode = HNKScaleModeAspectFill;
  format.compressionQuality = 0.5f;
  format.diskCapacity = 1 * 1024 * 1024;
  format.preloadPolicy = HNKPreloadPolicyAll;
  [[HNKCache sharedCache] registerFormat:format];

  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.opaque = NO;
  self.tableView.rowHeight = 60.0f;
  [self.tableView registerClassForCellReuse:[AWFFriendsViewCell class]];
  [self.view addSubview:self.tableView];

  @weakify(self);
  self.locationObserver =
  [[NSNotificationCenter defaultCenter]
   addObserverForName:AWFLocationManagerDidUpdateLocationsNotification object:nil queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *note) {
     @strongify(self);
     [self.tableView reloadData];
   }];

  [self getFriends];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (void)setPeople:(NSArray *)people {
  _people = people;
  [self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)getFriends {
  @weakify(self);
//  [[[AWFSession sharedSession] getUserFriends]
//   subscribeNext:^(NSArray *people) {
//     @strongify(self);
//     self.people = people;
//   }
//   error:^(NSError *error) {
//     ErrorLog(error.localizedDescription);
//   }];

  [[[AWFSession sharedSession] getUsersAtCoordinate:CLLocationCoordinate2DMake(48.136767, 11.576843)
                                         withRadius:20000.0
                                         pageNumber:0
                                           pageSize:20]
   subscribeNext:^(NSArray *people) {
     @strongify(self);
     self.people = people;
   }
   error:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFFriendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFFriendsViewCell reuseIdentifier]
                                                            forIndexPath:indexPath];
  AWFPerson *person = self.people[indexPath.row];
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.locationLabel.text = [NSString stringWithFormat:@"%.2f m — %@", person.distance, person.locationName];
  cell.placeholderView.text = person.abbreviatedName;

  return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(AWFFriendsViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

  AWFPerson *person = self.people[indexPath.row];

  MKCoordinateRegion region;
  region.center.latitude = person.location.coordinate.latitude;
  region.center.longitude = person.location.coordinate.longitude;
  region.span.latitudeDelta = 2000.0f * AWF_DEGREES_IN_METRE;
  region.span.longitudeDelta = 2000.0f * AWF_DEGREES_IN_METRE;

  NSString *key = [NSString stringWithFormat:@"AWFPersonMap-%f,%f", region.center.latitude, region.center.longitude];
  [[HNKCache sharedCache]
   retrieveImageForKey:key formatName:AWFMapThumbnailCacheFormatName
   completionBlock:^(UIImage *image, NSError *error) {
     if (image) {
       cell.mapImageView.image = image;
     }
     else {
       MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
       options.region = region;
       options.scale = [UIScreen mainScreen].scale;
       options.size = CGSizeMake(40.0f, 40.0f);

       MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
       [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
         MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
         CGRect bounds = pin.bounds;
         bounds.size.width /= 2.0f;
         bounds.size.height /= 2.0f;
         pin.bounds = bounds;

         UIImage *pinImage = [UIImage imageWithCGImage:pin.image.CGImage scale:pin.image.scale * 2.0f
                                           orientation:UIImageOrientationUp];

         CGPoint pinPoint = [snapshot pointForCoordinate:person.location.coordinate];
         CGPoint pinCenterOffset = pin.centerOffset;
         pinPoint.x -= CGRectGetMidX(pin.bounds);
         pinPoint.y -= CGRectGetMidY(pin.bounds);
         pinPoint.x += pinCenterOffset.x / 2.0f;
         pinPoint.y += pinCenterOffset.y / 2.0f;

         UIGraphicsBeginImageContextWithOptions(snapshot.image.size, YES, snapshot.image.scale);
         [snapshot.image drawAtPoint:CGPointMake(0, 0)];
         [pinImage drawAtPoint:pinPoint];
         UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         cell.mapImageView.image = finalImage;

         [[HNKCache sharedCache] setImage:finalImage forKey:key formatName:AWFMapThumbnailCacheFormatName];
       }];
     }
   }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPerson:self.people[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.people[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

@end

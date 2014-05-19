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

#import "AZNotification.h"
#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <Haneke/Haneke.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/NSNotificationCenter+RACSupport.h>

#import "AWFFriendsViewCell.h"
#import "AWFLocationManager.h"
#import "AWFMapViewController.h"
#import "AWFPerson.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"

static NSUInteger AWFPageSize = 20;
static NSString *AWFMapThumbnailCacheFormatName = @"AWFMapThumbnailCacheFormatName";

@interface AWFFriendsViewController () <
NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)getFriends;

@end

@implementation AWFFriendsViewController

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
  [RACObserveNotificationUntilDealloc(AWFLocationManagerDidUpdateLocationsNotification)
   subscribeNext:^(NSNotification *note) {
     @strongify(self);
     [self.tableView reloadData];
   }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self getFriends];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _fetchedResultsController = nil;
}

#pragma mark - Accessors

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSString *currentUserID = [AWFSession sharedSession].currentUserID;
    NSArray *predicates = @[[NSPredicate predicateWithFormat:@"personID != %@", currentUserID],
                            [NSPredicate predicateWithFormat:@"friendship != %d", AWFFriendshipStatusNone]];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    request.includesPropertyValues = YES;
    request.includesSubentities = YES;
    request.fetchBatchSize = AWFPageSize;

    _fetchedResultsController =
      [[NSFetchedResultsController alloc]
       initWithFetchRequest:request managedObjectContext:[AWFSession managedObjectContext]
       sectionNameKeyPath:nil cacheName:nil];
      _fetchedResultsController.delegate = self;

    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
      [AZNotification showNotificationWithTitle:error.localizedDescription
                                     controller:self
                               notificationType:AZNotificationTypeError
       shouldShowNotificationUnderNavigationBar:YES];
      ErrorLog(error.localizedDescription);
    }
  }

  return _fetchedResultsController;
}

#pragma mark - Private Methods

- (void)getFriends {
  [[[AWFSession sharedSession] getUserSelfFriends]
   subscribeError:^(NSError *error) {
     [AZNotification showNotificationWithTitle:error.localizedDescription
                                    controller:self
                              notificationType:AZNotificationTypeError
      shouldShowNotificationUnderNavigationBar:YES];
     ErrorLog(error.localizedDescription);
   }];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (NSInteger)self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger)section];
  return (NSInteger)sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFFriendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFFriendsViewCell reuseIdentifier]
                                                            forIndexPath:indexPath];
  AWFPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.locationLabel.text = [NSString stringWithFormat:@"%.2f m — %@", person.locationDistanceValue, person.locationName];
  cell.placeholderView.text = person.abbreviatedName;

  return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(AWFFriendsViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

  AWFPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];

  MKCoordinateRegion region;
  region.center.latitude = person.locationCoordinate.latitude;
  region.center.longitude = person.locationCoordinate.longitude;
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

         CGPoint pinPoint = [snapshot pointForCoordinate:person.locationCoordinate];
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
  AWFPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPersonID:person.personID];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  AWFPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
  AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:person];
  [self.navigationController pushViewController:vc animated:YES];
}

@end

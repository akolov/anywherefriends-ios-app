//
//  AWFProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Slash/Slash.h>

#import "AWFAppDelegate.h"
#import "AWFDatePickerViewCell.h"
#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFMapViewController.h"
#import "AWFPerson.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFPickerViewCell.h"
#import "AWFProfileDataSource.h"
#import "AWFSession.h"

@interface AWFProfileViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeFormatter;

- (void)onFriendButton:(id)sender;
- (void)onSendMessageButton:(id)sender;
- (void)onLocationButton:(id)sender;

@end

@implementation AWFProfileViewController

- (id)init {
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithPersonID:(NSString *)personID {
  self = [self init];
  if (self) {
    self.personID = personID;
  }
  return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.dataSource = [[AWFProfileDataSource alloc] init];
  self.dataSource.person = self.person;

  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.dataSource = self.dataSource;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.tableView.tableHeaderView = self.collectionView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _fetchedResultsController = nil;
}

#pragma mark - Accessors

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(159.0f, 159.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 2.0f;

    CGRect frame = self.view.bounds;
    frame.size.height = layout.itemSize.height;

    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;

    [_collectionView registerClassForCellReuse:[AWFPhotoCollectionViewCell class]];
  }

  return _collectionView;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"personID == %@", self.personID];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"personID" ascending:YES]];
    request.includesPropertyValues = YES;
    request.includesSubentities = YES;
    request.fetchLimit = 1;

    _fetchedResultsController =
      [[NSFetchedResultsController alloc]
       initWithFetchRequest:request managedObjectContext:[AWFSession managedObjectContext]
       sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;

    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
      ErrorLog(error.localizedDescription);
    }
    else {
      self.title = self.person.fullName;
    }
  }

  return _fetchedResultsController;
}

- (AWFPerson *)person {
  return [self.fetchedResultsController.fetchedObjects lastObject];
}

- (void)setPersonID:(NSString *)personID {
  if ([_personID isEqual:personID]) {
    return;
  }

  _personID = personID;
  _fetchedResultsController = nil;
  [self.tableView reloadData];
}

- (TTTTimeIntervalFormatter *)timeFormatter {
  if (!_timeFormatter) {
    _timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
  }
  return _timeFormatter;
}

#pragma mark - Actions

- (void)onFriendButton:(id)sender {
//  [[[AWFSession sharedSession] friendUser:self.person]
//   subscribeError:^(NSError *error) {
//     ErrorLog(error.localizedDescription);
//   }
//   completed:^{
//     [self.customProfileHeaderView setFriendshipStatus:AWFFriendshipStatusPending];
//   }];
}

- (void)onSendMessageButton:(id)sender {
  AWFAppDelegate *appDelegate = (AWFAppDelegate *)[UIApplication sharedApplication].delegate;
  appDelegate.tabBarController.selectedIndex = 2;
}

- (void)onLocationButton:(id)sender {
  AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.person];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  self.title = self.person.fullName;
  self.dataSource.person = self.person;
  [self.tableView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  AWFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AWFPhotoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
  cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Jasmin_t%ld.jpg", (long)indexPath.row]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = self.dataSource.currentCells[indexPath.section][indexPath.row];
  if ([cell isKindOfClass:[AWFDatePickerViewCell class]]) {
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
  }

  return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.editing) {

  }
  else {
    switch (indexPath.section) {
      case 0: {
        switch (indexPath.row) {
          case 0: {
            AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.person];
            [self.navigationController pushViewController:vc animated:YES];
          }
            break;

          default:
            break;
        }
      }
        break;

      default:
        break;
    }
  }
}

@end

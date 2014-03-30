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

#import "AWFAgeFormatter.h"
#import "AWFGenderFormatter.h"
#import "AWFHeightFormatter.h"
#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFMapViewController.h"
#import "AWFPerson.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFProfileHeaderView.h"
#import "AWFProfileTableViewCell.h"
#import "AWFSession.h"
#import "AWFWeightFormatter.h"

@interface AWFProfileViewController () <
NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) AWFAgeFormatter *ageFormatter;
@property (nonatomic, strong) AWFGenderFormatter *genderFormatter;
@property (nonatomic, strong) AWFHeightFormatter *heightFormatter;
@property (nonatomic, strong) AWFWeightFormatter *weightFormatter;
@property (nonatomic, strong) NSDateFormatter *birthdayFormatter;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeFormatter;
@property (nonatomic, readonly) AWFPerson *person;

- (void)onFriendButton:(id)sender;
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

  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  [self.tableView registerClassForCellReuse:[AWFProfileTableViewCell class]];

  self.tableView.tableHeaderView = ({
    NSMutableParagraphStyle *const paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *const style = @{@"$default": @{NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14.0f],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]},
                                  @"em": @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:10.0f],
                                           NSForegroundColorAttributeName: [UIColor grayColor]}};
    NSString *lastUpdated, *markup;
    if (self.person.locationUpdated) {
      lastUpdated = [self.timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:self.person.locationUpdated];
      markup = [NSString stringWithFormat:@"%@\n<em>%2.f m from you — %@</em>",
                self.person.locationName, self.person.locationDistanceValue, lastUpdated];
    }
    else {
      markup = [NSString stringWithFormat:@"%@\n<em>%2.f m from you</em>",
                self.person.locationName, self.person.locationDistanceValue];
    }

    AWFProfileHeaderView *view = [[AWFProfileHeaderView alloc] init];
    view.descriptionLabel.text = self.person.bio;
    view.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds);
    view.locationLabel.attributedText = [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];
    view.photoCollectionView.dataSource = self;
    view.photoCollectionView.delegate = self;
    view.friendButton.selected = YES;

    [view.friendButton addTarget:self action:@selector(onFriendButton:)
                forControlEvents:UIControlEventTouchUpInside];
    [view.locationButton addTarget:self action:@selector(onLocationButton:)
                  forControlEvents:UIControlEventTouchUpInside];

    CGRect bounds;
    bounds.size.width = CGRectGetWidth(self.tableView.bounds);
    bounds.size.height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    view.bounds = bounds;

    [view setNeedsLayout];
    [view layoutIfNeeded];

    view;
  });
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

- (NSDateFormatter *)birthdayFormatter {
  if (!_birthdayFormatter) {
    _birthdayFormatter = [[NSDateFormatter alloc] init];
    _birthdayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMMd" options:0
                                                                     locale:[NSLocale currentLocale]];
  }
  return _birthdayFormatter;
}

- (AWFAgeFormatter *)ageFormatter {
  if (!_ageFormatter) {
    _ageFormatter = [[AWFAgeFormatter alloc] init];
  }
  return _ageFormatter;
}

- (AWFGenderFormatter *)genderFormatter {
  if (!_genderFormatter) {
    _genderFormatter = [[AWFGenderFormatter alloc] init];
  }
  return _genderFormatter;
}

- (AWFHeightFormatter *)heightFormatter {
  if (!_heightFormatter) {
    _heightFormatter = [[AWFHeightFormatter alloc] init];
  }
  return _heightFormatter;
}

- (AWFWeightFormatter *)weightFormatter {
  if (!_weightFormatter) {
    _weightFormatter = [[AWFWeightFormatter alloc] init];
  }
  return _weightFormatter;
}

- (TTTTimeIntervalFormatter *)timeFormatter {
  if (!_timeFormatter) {
    _timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
  }
  return _timeFormatter;
}

#pragma mark - Actions

- (void)onFriendButton:(id)sender {
  [[[AWFSession sharedSession] friendUser:self.person]
   subscribeNext:^(id x) {

   }
   error:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

- (void)onLocationButton:(id)sender {
  AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.person];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public methods

- (AWFProfileHeaderView *)headerView {
  return (AWFProfileHeaderView *)self.tableView.tableHeaderView;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  self.title = self.person.fullName;
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 3;
    default:
      return 6;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_BASIC_INFO", nil);
  }
  else {
    return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_APPEARANCE", nil);
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:[AWFProfileTableViewCell reuseIdentifier] forIndexPath:indexPath];

  NSString *text, *detail = @"—";

  if (indexPath.section == 0) {
    switch (indexPath.row) {
      case 0:
        text = NSLocalizedString(@"AWF_GENDER", nil);
        if (self.person.gender != AWFGenderUnknown) {
          detail = [[self.genderFormatter stringFromGender:self.person.genderValue] capitalizedString];
        }
        break;

      case 1:
        text = NSLocalizedString(@"AWF_AGE", nil);
        if (self.person.age) {
          detail = [self.ageFormatter stringFromAge:[self.person.age integerValue]];
        }
        break;

      case 2:
        text = NSLocalizedString(@"AWF_BIRTHDAY", nil);
        if (self.person.birthday) {
          detail = [self.birthdayFormatter stringFromDate:self.person.birthday];
        }
        break;

      default:
        break;
    }
  }
  else {
    switch (indexPath.row) {
      case 0:
        text = NSLocalizedString(@"AWF_HEIGHT", nil);
        if (self.person.height) {
          detail = [self.heightFormatter stringFromHeight:self.person.height];
        }
        break;

      case 1:
        text = NSLocalizedString(@"AWF_WEIGHT", nil);
        if (self.person.weight) {
          detail = [self.weightFormatter stringFromWeight:self.person.weight];
        }
        break;

      case 2:
        text = NSLocalizedString(@"AWF_BODY_BUILD", nil);
        if (self.person.bodyBuild) {
          detail = [self.person.bodyBuild capitalizedString];
        }
        break;

      case 3:
        text = NSLocalizedString(@"AWF_HAIR_LENGTH", nil);
        if (self.person.hairLength) {
          detail = [self.person.hairLength capitalizedString];
        }
        break;

      case 4:
        text = NSLocalizedString(@"AWF_HAIR_COLOR", nil);
        if (self.person.hairColor) {
          detail = [self.person.hairColor capitalizedString];
        }
        break;

      case 5:
        text = NSLocalizedString(@"AWF_EYE_COLOR", nil);
        if (self.person.eyeColor) {
          detail = [self.person.eyeColor capitalizedString];
        }
        break;

      default:
        break;
    }
  }

  cell.textLabel.text = text;
  cell.detailTextLabel.text = detail;

  return cell;
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

@end

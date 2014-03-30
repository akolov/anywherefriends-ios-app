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
@property (nonatomic, strong) NSArray *fields;
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
  _fields = nil;
  [self.tableView reloadData];
}

- (NSArray *)fields {
  if (!self.person) {
    return nil;
  }

  if (!_fields) {

    // Section 1

    NSMutableArray *section1 = [NSMutableArray array];

    NSString *gender = @"—";
    if (self.person.gender != AWFGenderUnknown) {
      gender = [[self.genderFormatter stringFromGender:self.person.genderValue] capitalizedString];
    }

    NSString *age = @"—";
    if (self.person.age) {
      age = [self.ageFormatter stringFromAge:[self.person.age integerValue]];
    }

    NSString *birthday = @"—";
    if (self.person.birthday) {
      birthday = [self.birthdayFormatter stringFromDate:self.person.birthday];
    }

    NSString *height = @"—";
    if (self.person.height) {
      height = [self.heightFormatter stringFromHeight:self.person.height];
    }

    NSString *weight = @"—";
    if (self.person.weight) {
      weight = [self.weightFormatter stringFromWeight:self.person.weight];
    }

    NSString *bodyBuild = @"—";
    if (self.person.bodyBuild) {
      bodyBuild = [self.person.bodyBuild capitalizedString];
    }

    NSString *hairColor = @"—";
    if (self.person.hairLength) {
      hairColor = [self.person.hairLength capitalizedString];
    }

    NSString *hairLength = @"—";
    if (self.person.hairColor) {
      hairLength = [self.person.hairColor capitalizedString];
    }

    NSString *eyeColor = @"—";
    if (self.person.eyeColor) {
      eyeColor = [self.person.eyeColor capitalizedString];
    }

    if (gender.length != 0) {
      [section1 addObject:@[NSLocalizedString(@"AWF_GENDER", nil), gender]];
    }

    if (age.length != 0) {
      [section1 addObject:@[NSLocalizedString(@"AWF_AGE", nil), age]];
    }

    if (birthday.length != 0) {
      [section1 addObject:@[NSLocalizedString(@"AWF_BIRTHDAY", nil), birthday]];
    }

    // Section 2

    NSMutableArray *section2 = [NSMutableArray array];

    [section2 addObject:@[NSLocalizedString(@"AWF_HEIGHT", nil), height]];
    [section2 addObject:@[NSLocalizedString(@"AWF_WEIGHT", nil), weight]];
    [section2 addObject:@[NSLocalizedString(@"AWF_BODY_BUILD", nil), bodyBuild]];
    [section2 addObject:@[NSLocalizedString(@"AWF_HAIR_LENGTH", nil), hairLength]];
    [section2 addObject:@[NSLocalizedString(@"AWF_HAIR_COLOR", nil), hairColor]];
    [section2 addObject:@[NSLocalizedString(@"AWF_EYE_COLOR", nil), eyeColor]];

    _fields = @[section1, section2];
  }
  return _fields;
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
  _fields = nil;
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.fields.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.fields[section] count];
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

  cell.textLabel.text = self.fields[indexPath.section][indexPath.row][0];
  cell.detailTextLabel.text = self.fields[indexPath.section][indexPath.row][1];

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

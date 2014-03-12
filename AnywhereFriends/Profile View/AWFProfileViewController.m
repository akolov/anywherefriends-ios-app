//
//  AWFProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFProfileViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import <Slash/Slash.h>

#import "AWFAgeFormatter.h"
#import "AWFGenderFormatter.h"
#import "AWFHeightFormatter.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFProfileTableViewCell.h"
#import "AWFWeightFormatter.h"


@interface AWFProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) AWFAgeFormatter *ageFormatter;
@property (nonatomic, strong) AWFGenderFormatter *genderFormatter;
@property (nonatomic, strong) AWFHeightFormatter *heightFormatter;
@property (nonatomic, strong) AWFWeightFormatter *weightFormatter;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSDateFormatter *birthdayFormatter;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeFormatter;

@end


@implementation AWFProfileViewController

- (id)init {
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithPerson:(AWFPerson *)person {
  self = [self init];
  if (self) {
    self.person = person;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = self.person.fullName;

  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  [self.tableView registerClass:[AWFProfileTableViewCell class] forCellReuseIdentifier:[AWFProfileTableViewCell reuseIdentifier]];

  self.tableView.tableHeaderView = ({
    NSMutableParagraphStyle *const paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *const style = @{@"$default": @{NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14.0f],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]},
                                  @"em": @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:10.0f],
                                           NSForegroundColorAttributeName: [UIColor grayColor]}};
    NSString *lastUpdated = [self.timeFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                       toDate:self.person.location.timestamp];
    NSString *thoroughfare = self.person.placemark[@"thoroughfare"];
    NSString *locality = self.person.placemark[@"locality"];
    NSString *location;

    if ([thoroughfare length] != 0 && [locality length] != 0) {
      location = [NSString stringWithFormat:@"%@, %@", thoroughfare, locality];
    }
    else if ([locality length] != 0) {
      location = [NSString stringWithFormat:@"%@", locality];
    }
    else if ([thoroughfare length] != 0) {
      location = [NSString stringWithFormat:@"%@", thoroughfare];
    }
    else {
      location = NSLocalizedString(@"AWF_UNKNOWN_LOCATION", nil);
    }

    NSString *markup = [NSString stringWithFormat:@"%@\n<em>%2.f m from you — %@</em>",
                        location, self.person.distance, lastUpdated];

    AWFProfileHeaderView *view = [[AWFProfileHeaderView alloc] init];
    view.descriptionLabel.text = self.person.bio;
    view.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds);
    view.locationLabel.attributedText = [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];
    view.photoCollectionView.dataSource = self;
    view.photoCollectionView.delegate = self;
    view.followButton.selected = YES;

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
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

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

#pragma mark - Collection view data source

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

#pragma mark - Private methods

- (NSArray *)fields {
  if (!_fields) {

    // Section 1

    NSMutableArray *section1 = [NSMutableArray array];

    NSString *gender = [[self.genderFormatter stringFromGender:self.person.gender] capitalizedString];
    NSString *age = [self.ageFormatter stringFromAge:self.person.age];
    NSString *birthday = [self.birthdayFormatter stringFromDate:self.person.birthday];
    NSString *height = [self.heightFormatter stringFromHeight:self.person.height];
    NSString *weight = [self.weightFormatter stringFromWeight:self.person.weight];
    NSString *bodyBuild = [self.person.bodyBuild capitalizedString];
    NSString *hairColor = [self.person.hairLength capitalizedString];
    NSString *hairLength = [self.person.hairColor capitalizedString];
    NSString *eyeColor = [self.person.eyeColor capitalizedString];

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

#pragma mark - Public methods

- (AWFProfileHeaderView *)headerView {
  return (AWFProfileHeaderView *)self.tableView.tableHeaderView;
}

@end

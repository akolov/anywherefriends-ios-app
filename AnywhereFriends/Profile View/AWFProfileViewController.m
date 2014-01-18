//
//  AWFProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFProfileViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <Slash/Slash.h>

#import "AWFAgeFormatter.h"
#import "AWFGenderFormatter.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFProfileTableViewCell.h"


@interface AWFProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) AWFAgeFormatter *ageFormatter;
@property (nonatomic, strong) NSDateFormatter *birthdayFormatter;
@property (nonatomic, strong) AWFGenderFormatter *genderFormatter;

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
  [self.tableView registerClass:[AWFProfileTableViewCell class] forCellReuseIdentifier:[AWFProfileTableViewCell reuseIdentifier]];

  self.tableView.tableHeaderView = ({
    NSMutableParagraphStyle *const paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *const style = @{@"$default": @{NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14.0f],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]},
                                  @"em": @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:10.0f],
                                           NSForegroundColorAttributeName: [UIColor grayColor]}};
    NSString *markup = [NSString stringWithFormat:@"Alexanderplatz, Berlin\n<em>%2.f m from you</em>",
                        self.person.distance];

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
  return self.temporaryData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.temporaryData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_BASIC_INFO", @"Basic info section header title of the profile view");
  }
  else {
    return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_APPEARANCE", @"Appearance section header title of the profile view");
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFProfileTableViewCell reuseIdentifier] forIndexPath:indexPath];

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
  cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Jasmin_t%d.jpg", indexPath.row]];
  return cell;
}

#pragma mark - Private methods

- (NSArray *)fields {
  if (!_fields) {
    _fields = @[
                @[
                  @[NSLocalizedString(@"AWF_GENDER", nil),
                    [[self.genderFormatter stringFromGender:self.person.gender] capitalizedString]],
                  @[NSLocalizedString(@"AWF_AGE", nil),
                    [self.ageFormatter stringFromAge:self.person.age]],
                  @[NSLocalizedString(@"AWF_BIRTHDAY", nil),
                    [self.birthdayFormatter stringFromDate:self.person.birthday]]
                  ],
                @[
                  @[@"Hair", @"Light Brown"],
                  @[@"Eyes", @"Gray"],
                  @[@"Height", @"170 cm"],
                  @[@"Body Type", @"Normal"]]
                ];
  }
  return _fields;
}

- (NSDateFormatter *)birthdayFormatter {
  if (!_birthdayFormatter) {
    _birthdayFormatter = [[NSDateFormatter alloc] init];
    _birthdayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMMd" options:0
                                                                     locale:[NSLocale autoupdatingCurrentLocale]];
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

#pragma mark - Public methods

- (AWFProfileHeaderView *)headerView {
  return (AWFProfileHeaderView *)self.tableView.tableHeaderView;
}

@end

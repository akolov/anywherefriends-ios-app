//
//  AWFProfileDataSource.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileDataSource.h"

#import <FormatterKit/TTTTimeIntervalFormatter.h>

#import "AWFLocationCell.h"

#import "AWFAgeFormatter.h"
#import "AWFBodyBuildFormatter.h"
#import "AWFDatePickerViewCell.h"
#import "AWFEyeColorFormatter.h"
#import "AWFGenderFormatter.h"
#import "AWFHairColorFormatter.h"
#import "AWFHairLengthFormatter.h"
#import "AWFHeightFormatter.h"
#import "AWFWeightFormatter.h"

@interface AWFProfileDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableViewCell *locationCell;
@property (nonatomic, strong) UITableViewCell *genderCell;
@property (nonatomic, strong) UITableViewCell *ageCell;
@property (nonatomic, strong) UITableViewCell *birthdayCell;
@property (nonatomic, strong) UITableViewCell *heightCell;
@property (nonatomic, strong) UITableViewCell *weightCell;
@property (nonatomic, strong) UITableViewCell *bodyBuildCell;
@property (nonatomic, strong) UITableViewCell *hairLengthCell;
@property (nonatomic, strong) UITableViewCell *hairColorCell;
@property (nonatomic, strong) UITableViewCell *eyeColorCell;

@property (nonatomic, strong) AWFDatePickerViewCell *editingBirthdayCell;

@property (nonatomic, strong) AWFAgeFormatter *ageFormatter;
@property (nonatomic, strong) NSDateFormatter *birthdayFormatter;
@property (nonatomic, strong) AWFBodyBuildFormatter *bodyBuildFormatter;
@property (nonatomic, strong) AWFEyeColorFormatter *eyeColorFormatter;
@property (nonatomic, strong) AWFGenderFormatter *genderFormatter;
@property (nonatomic, strong) AWFHairColorFormatter *hairColorFormatter;
@property (nonatomic, strong) AWFHairLengthFormatter *hairLengthFormatter;
@property (nonatomic, strong) AWFHeightFormatter *heightFormatter;
@property (nonatomic, strong) AWFWeightFormatter *weightFormatter;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeFormatter;

@end

@implementation AWFProfileDataSource

+ (void)setupNormalCellStyle:(UITableViewCell *)cell {
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.backgroundColor = [UIColor clearColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  cell.textLabel.font = [UIFont helveticaNeueFontOfSize:12.0f];
  cell.textLabel.textColor = [UIColor lightGrayColor];

  cell.detailTextLabel.font = [UIFont helveticaNeueFontOfSize:18.0f];
  cell.detailTextLabel.textColor = [UIColor whiteColor];
}

+ (void)setupEditingCellStyle:(UITableViewCell *)cell {
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.backgroundColor = [UIColor clearColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  cell.textLabel.font = [UIFont helveticaNeueFontOfSize:12.0f];
  cell.textLabel.textColor = [UIColor darkGrayColor];

  cell.detailTextLabel.font = [UIFont helveticaNeueFontOfSize:18.0f];
  cell.detailTextLabel.textColor = [UIColor blackColor];
}

#pragma mark - Cells

- (UITableViewCell *)locationCell {
  if (!_locationCell) {
    _locationCell = [[AWFLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  _locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  _locationCell.backgroundColor = [UIColor clearColor];
  _locationCell.selectionStyle = UITableViewCellSelectionStyleNone;

  if (self.person.locationUpdated) {
    NSString *lastUpdated = [self.timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:self.person.locationUpdated];

    _locationCell.textLabel.text = self.person.locationName;
    if (self.ownProfile) {
      _locationCell.detailTextLabel.text = lastUpdated;
    }
    else {
      _locationCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m from you — %@",
                                            self.person.locationDistanceValue, lastUpdated];
    }
  }
  else {
    _locationCell.textLabel.text = self.person.locationName;
    if (self.ownProfile) {
      _locationCell.detailTextLabel.text = nil;
    }
    else {
      _locationCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m from you",
                                            self.person.locationDistanceValue];
    }
  }

  return _locationCell;
}

- (UITableViewCell *)genderCell {
  if (!_genderCell) {
    _genderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_genderCell];
  }
  else {
    [[self class] setupNormalCellStyle:_genderCell];
  }

  _genderCell.textLabel.text = NSLocalizedString(@"AWF_GENDER", nil);
  if (self.person.gender != AWFGenderUnknown) {
    _genderCell.detailTextLabel.text = [[self.genderFormatter stringFromGender:self.person.genderValue] capitalizedString];
  }
  else {
    _genderCell.detailTextLabel.text = @"—";
  }

  return _genderCell;
}

- (UITableViewCell *)ageCell {
  if (!_ageCell) {
    _ageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_ageCell];
  }
  else {
    [[self class] setupNormalCellStyle:_ageCell];
  }

  _ageCell.textLabel.text = NSLocalizedString(@"AWF_AGE", nil);
  if (self.person.age) {
    _ageCell.detailTextLabel.text = [self.ageFormatter stringFromAge:[self.person.age integerValue]];
  }
  else {
    _ageCell.detailTextLabel.text = @"—";
  }

  return _ageCell;
}

- (UITableViewCell *)birthdayCell {
  if (!_birthdayCell) {
    _birthdayCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_birthdayCell];
  }
  else {
    [[self class] setupNormalCellStyle:_birthdayCell];
  }

  _birthdayCell.textLabel.text = NSLocalizedString(@"AWF_BIRTHDAY", nil);
  if (self.person.birthday) {
    _birthdayCell.detailTextLabel.text = [self.birthdayFormatter stringFromDate:self.person.birthday];
  }
  else {
    _birthdayCell.detailTextLabel.text = @"—";
  }

  return _birthdayCell;
}

- (UITableViewCell *)heightCell {
  if (!_heightCell) {
    _heightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_heightCell];
  }
  else {
    [[self class] setupNormalCellStyle:_heightCell];
  }

  _heightCell.textLabel.text = NSLocalizedString(@"AWF_HEIGHT", nil);
  if (self.person.height) {
    _heightCell.detailTextLabel.text = [self.heightFormatter stringFromHeight:self.person.height];
  }
  else {
    _heightCell.detailTextLabel.text = @"—";
  }

  return _heightCell;
}

- (UITableViewCell *)weightCell {
  if (!_weightCell) {
    _weightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_weightCell];
  }
  else {
    [[self class] setupNormalCellStyle:_weightCell];
  }

  _weightCell.textLabel.text = NSLocalizedString(@"AWF_WEIGHT", nil);
  if (self.person.weight) {
    _weightCell.detailTextLabel.text = [self.weightFormatter stringFromWeight:self.person.weight];
  }
  else {
    _weightCell.detailTextLabel.text = @"—";
  }

  return _weightCell;
}

- (UITableViewCell *)bodyBuildCell {
  if (!_bodyBuildCell) {
    _bodyBuildCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_bodyBuildCell];
  }
  else {
    [[self class] setupNormalCellStyle:_bodyBuildCell];
  }

  _bodyBuildCell.textLabel.text = NSLocalizedString(@"AWF_BODY_BUILD", nil);
  if (self.person.bodyBuild) {
    _bodyBuildCell.detailTextLabel.text = [[self.bodyBuildFormatter stringFromBodyBuild:self.person.bodyBuildValue] capitalizedString];
  }
  else {
    _bodyBuildCell.detailTextLabel.text = @"—";
  }

  return _bodyBuildCell;
}

- (UITableViewCell *)hairLengthCell {
  if (!_hairLengthCell) {
    _hairLengthCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_hairLengthCell];
  }
  else {
    [[self class] setupNormalCellStyle:_hairLengthCell];
  }

  _hairLengthCell.textLabel.text = NSLocalizedString(@"AWF_HAIR_LENGTH", nil);
  if (self.person.hairLength) {
    _hairLengthCell.detailTextLabel.text = [[self.hairLengthFormatter stringFromHairLength:self.person.hairLengthValue] capitalizedString];
  }
  else {
    _hairLengthCell.detailTextLabel.text = @"—";
  }

  return _hairLengthCell;
}

- (UITableViewCell *)hairColorCell {
  if (!_hairColorCell) {
    _hairColorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_hairColorCell];
  }
  else {
    [[self class] setupNormalCellStyle:_hairColorCell];
  }

  _hairColorCell.textLabel.text = NSLocalizedString(@"AWF_HAIR_COLOR", nil);
  if (self.person.hairColor) {
    _hairColorCell.detailTextLabel.text = [[self.hairColorFormatter stringFromHairColor:self.person.hairColorValue] capitalizedString];
  }
  else {
    _hairColorCell.detailTextLabel.text = @"—";
  }

  return _hairColorCell;
}

- (UITableViewCell *)eyeColorCell {
  if (!_eyeColorCell) {
    _eyeColorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  }

  if (self.editing) {
    [[self class] setupEditingCellStyle:_eyeColorCell];
  }
  else {
    [[self class] setupNormalCellStyle:_eyeColorCell];
  }

  _eyeColorCell.textLabel.text = NSLocalizedString(@"AWF_EYE_COLOR", nil);
  if (self.person.eyeColor) {
    _eyeColorCell.detailTextLabel.text = [[self.eyeColorFormatter stringFromEyeColor:self.person.eyeColorValue] capitalizedString];
  }
  else {
    _eyeColorCell.detailTextLabel.text = @"—";
  }

  return _eyeColorCell;
}

- (NSArray *)normalCells {
  return @[@[self.locationCell],
           @[self.genderCell, self.ageCell, self.birthdayCell],
           @[self.heightCell, self.weightCell, self.bodyBuildCell, self.hairLengthCell, self.hairColorCell,
             self.eyeColorCell]];
}

- (NSArray *)editingCells {
  return @[@[self.genderCell, self.editingBirthdayCell],
           @[self.heightCell, self.weightCell, self.bodyBuildCell, self.hairLengthCell, self.hairColorCell,
             self.eyeColorCell]];
}

- (NSArray *)currentCells {
  return self.editing ? self.editingCells : self.normalCells;
}

#pragma mark - Editing cells

- (AWFDatePickerViewCell *)editingBirthdayCell {
  if (!_editingBirthdayCell) {
    _editingBirthdayCell = [[AWFDatePickerViewCell alloc] init];
  }

  _editingBirthdayCell.titleLabel.text = NSLocalizedString(@"AWF_BIRTHDAY", nil);
  _editingBirthdayCell.datePicker.datePickerMode = UIDatePickerModeDate;

  {
    NSDateComponents *components =
    [[NSCalendar autoupdatingCurrentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    components.year -= 18;

    _editingBirthdayCell.datePicker.minimumDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
  }

  {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.month = 1;
    components.year = 1900;

    _editingBirthdayCell.datePicker.maximumDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
  }

  if (self.person.birthday) {
    _editingBirthdayCell.datePicker.date = self.person.birthday;
  }

  return _editingBirthdayCell;
}

#pragma mark - Formatters

- (AWFAgeFormatter *)ageFormatter {
  if (!_ageFormatter) {
    _ageFormatter = [[AWFAgeFormatter alloc] init];
  }
  return _ageFormatter;
}

- (NSDateFormatter *)birthdayFormatter {
  if (!_birthdayFormatter) {
    _birthdayFormatter = [[NSDateFormatter alloc] init];
  }

  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  NSString *template = self.ownProfile ? @"MMMMdyyyy" : @"MMMMd";
  _birthdayFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:locale];

  return _birthdayFormatter;
}

- (AWFBodyBuildFormatter *)bodyBuildFormatter {
  if (!_bodyBuildFormatter) {
    _bodyBuildFormatter = [[AWFBodyBuildFormatter alloc] init];
  }
  return _bodyBuildFormatter;
}

- (AWFEyeColorFormatter *)eyeColorFormatter {
  if (!_eyeColorFormatter) {
    _eyeColorFormatter = [[AWFEyeColorFormatter alloc] init];
  }
  return _eyeColorFormatter;
}

- (AWFGenderFormatter *)genderFormatter {
  if (!_genderFormatter) {
    _genderFormatter = [[AWFGenderFormatter alloc] init];
  }
  return _genderFormatter;
}

- (AWFHairColorFormatter *)hairColorFormatter {
  if (!_hairColorFormatter) {
    _hairColorFormatter = [[AWFHairColorFormatter alloc] init];
  }
  return _hairColorFormatter;
}

- (AWFHairLengthFormatter *)hairLengthFormatter {
  if (!_hairLengthFormatter) {
    _hairLengthFormatter = [[AWFHairLengthFormatter alloc] init];
  }
  return _hairLengthFormatter;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.currentCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.currentCells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.currentCells[indexPath.section][indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.editing) {
    switch (section) {
      case 0:
        return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_BASIC_INFO", nil);
      case 1:
        return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_APPEARANCE", nil);
    }
  }
  else {
    switch (section) {
      case 0:
        return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_LOCATION", nil);
      case 1:
        return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_BASIC_INFO", nil);
      case 2:
        return NSLocalizedString(@"AWF_PROFILE_SECTION_HEADER_APPEARANCE", nil);
    }
  }
  return nil;
}

@end

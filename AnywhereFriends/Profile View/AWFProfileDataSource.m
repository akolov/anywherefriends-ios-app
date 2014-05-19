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
#import "AWFPickerViewCell.h"
#import "AWFWeightFormatter.h"

@interface AWFProfileDataSource () <NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

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

@property (nonatomic, strong) AWFPickerViewCell *editingGenderCell;
@property (nonatomic, strong) AWFDatePickerViewCell *editingBirthdayCell;
@property (nonatomic, strong) AWFPickerViewCell *editingHeightCell;
@property (nonatomic, strong) AWFPickerViewCell *editingWeightCell;
@property (nonatomic, strong) AWFPickerViewCell *editingBodyBuildCell;
@property (nonatomic, strong) AWFPickerViewCell *editingHairLengthCell;
@property (nonatomic, strong) AWFPickerViewCell *editingHairColorCell;
@property (nonatomic, strong) AWFPickerViewCell *editingEyeColorCell;

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

@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) NSArray *bodyBuilds;
@property (nonatomic, strong) NSArray *hairLengths;
@property (nonatomic, strong) NSArray *hairColors;
@property (nonatomic, strong) NSArray *eyeColors;

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

#pragma mark - Properties

- (void)setEditing:(BOOL)editing {
  if (_editing == editing) {
    return;
  }

  _editing = editing;

  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if (_editing) {
    NSInteger genderIndex = [self.genders indexOfObject:self.person.gender];
    [self.editingGenderCell.pickerView selectRow:(genderIndex == NSNotFound ? 0 : genderIndex) inComponent:0 animated:NO];

    NSDate *date;
    if (self.person.birthday) {
      date = self.person.birthday;
    }
    else {
      NSDateComponents *components =
        [[NSCalendar autoupdatingCurrentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                    fromDate:[NSDate date]];
      components.year -= 18;
      date = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
    }

    self.editingBirthdayCell.datePicker.date = date;

    if (isMetric) {
      NSInteger heightFirstIndex = (unsigned int)self.person.heightValue / 100;
      NSInteger heightSecondIndex = (unsigned int)self.person.heightValue % 100;

      [self.editingHeightCell.pickerView selectRow:heightFirstIndex inComponent:0 animated:NO];
      [self.editingHeightCell.pickerView selectRow:heightSecondIndex inComponent:1 animated:NO];
    }
    else {
      float iptr;
      NSInteger heightFirstIndex = self.person.heightValue / 30.48f;
      NSInteger heightSecondIndex = modff(self.person.heightValue / 30.48f, &iptr) * 12.0f;

      [self.editingHeightCell.pickerView selectRow:heightFirstIndex inComponent:0 animated:NO];
      [self.editingHeightCell.pickerView selectRow:heightSecondIndex inComponent:1 animated:NO];
    }

    if (isMetric) {
      NSInteger weightIndex = self.person.weightValue == 0 ? 0 : self.person.weightValue - 30.0f;
      [self.editingWeightCell.pickerView selectRow:weightIndex inComponent:0 animated:NO];
    }
    else {
      NSInteger weightIndex = self.person.weightValue == 0 ? 0 : (self.person.weightValue - 30.0f) / 0.45f;
      [self.editingWeightCell.pickerView selectRow:weightIndex inComponent:0 animated:NO];
    }

    NSInteger bodyBuildIndex = [self.bodyBuilds indexOfObject:self.person.bodyBuild];
    [self.editingBodyBuildCell.pickerView selectRow:(bodyBuildIndex == NSNotFound ? 0 : bodyBuildIndex) inComponent:0 animated:NO];

    NSInteger hairLengthIndex = [self.hairLengths indexOfObject:self.person.hairLength];
    [self.editingHairLengthCell.pickerView selectRow:(hairLengthIndex == NSNotFound ? 0 : hairLengthIndex) inComponent:0 animated:NO];

    NSInteger hairColorIndex = [self.hairColors indexOfObject:self.hairColors];
    [self.editingHairColorCell.pickerView selectRow:(hairColorIndex == NSNotFound ? 0 : hairColorIndex) inComponent:0 animated:NO];

    NSInteger eyeColorIndex = [self.eyeColors indexOfObject:self.person.eyeColor];
    [self.editingEyeColorCell.pickerView selectRow:(eyeColorIndex == NSNotFound ? 0 : eyeColorIndex) inComponent:0 animated:NO];
  }
  else {
    NSInteger genderIndex = [self.editingGenderCell.pickerView selectedRowInComponent:0];
    self.person.gender = self.genders[genderIndex];

    NSDate *birthday = [self.editingBirthdayCell.datePicker date];
    self.person.birthday = birthday;

    NSInteger heightFirstIndex = [self.editingHeightCell.pickerView selectedRowInComponent:0];
    NSInteger heightSecondIndex = [self.editingHeightCell.pickerView selectedRowInComponent:1];

    if (isMetric) {
      self.person.heightValue = (float)heightFirstIndex + (float)heightSecondIndex / 100.0f;
    }
    else {
      self.person.heightValue = ((float)heightFirstIndex + 3.0f) * 30.48f + (float)heightSecondIndex * 2.54f;
    }

    NSInteger weightIndex = [self.editingWeightCell.pickerView selectedRowInComponent:0];
    if (isMetric) {
      self.person.weightValue = (float)weightIndex + 30.0f;
    }
    else {
      self.person.weightValue = (float)weightIndex * 0.45f + 30.0f;
    }

    NSInteger bodyBuildIndex = [self.editingBodyBuildCell.pickerView selectedRowInComponent:0];
    self.person.bodyBuild = self.bodyBuilds[bodyBuildIndex];

    NSInteger hairLengthIndex = [self.editingHairLengthCell.pickerView selectedRowInComponent:0];
    self.person.hairLength = self.hairLengths[hairLengthIndex];

    NSInteger hairColorIndex = [self.editingHairColorCell.pickerView selectedRowInComponent:0];
    self.person.hairColor = self.hairColors[hairColorIndex];

    NSInteger eyeColorIndex = [self.editingEyeColorCell.pickerView selectedRowInComponent:0];
    self.person.eyeColor = self.eyeColors[eyeColorIndex];
  }
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

#pragma mark - Editing cells

- (AWFPickerViewCell *)editingGenderCell {
  if (!_editingGenderCell) {
    _editingGenderCell = [[AWFPickerViewCell alloc] init];
    _editingGenderCell.pickerView.dataSource = self;
    _editingGenderCell.pickerView.delegate = self;
  }

  _editingGenderCell.titleLabel.text = NSLocalizedString(@"AWF_GENDER", nil);

  return _editingGenderCell;
}

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

- (AWFPickerViewCell *)editingHeightCell {
  if (!_editingHeightCell) {
    _editingHeightCell = [[AWFPickerViewCell alloc] init];
    _editingHeightCell.pickerView.dataSource = self;
    _editingHeightCell.pickerView.delegate = self;
  }

  _editingHeightCell.titleLabel.text = NSLocalizedString(@"AWF_HEIGHT", nil);

  return _editingHeightCell;
}

- (AWFPickerViewCell *)editingWeightCell {
  if (!_editingWeightCell) {
    _editingWeightCell = [[AWFPickerViewCell alloc] init];
    _editingWeightCell.pickerView.dataSource = self;
    _editingWeightCell.pickerView.delegate = self;
  }

  _editingWeightCell.titleLabel.text = NSLocalizedString(@"AWF_WEIGHT", nil);

  return _editingWeightCell;
}

- (AWFPickerViewCell *)editingBodyBuildCell {
  if (!_editingBodyBuildCell) {
    _editingBodyBuildCell = [[AWFPickerViewCell alloc] init];
    _editingBodyBuildCell.pickerView.dataSource = self;
    _editingBodyBuildCell.pickerView.delegate = self;
  }

  _editingBodyBuildCell.titleLabel.text = NSLocalizedString(@"AWF_BODY_BUILD", nil);

  return _editingBodyBuildCell;
}

- (AWFPickerViewCell *)editingHairLengthCell {
  if (!_editingHairLengthCell) {
    _editingHairLengthCell = [[AWFPickerViewCell alloc] init];
    _editingHairLengthCell.pickerView.dataSource = self;
    _editingHairLengthCell.pickerView.delegate = self;
  }

  _editingHairLengthCell.titleLabel.text = NSLocalizedString(@"AWF_HAIR_LENGTH", nil);

  return _editingHairLengthCell;
}

- (AWFPickerViewCell *)editingHairColorCell {
  if (!_editingHairColorCell) {
    _editingHairColorCell = [[AWFPickerViewCell alloc] init];
    _editingHairColorCell.pickerView.dataSource = self;
    _editingHairColorCell.pickerView.delegate = self;
  }

  _editingHairColorCell.titleLabel.text = NSLocalizedString(@"AWF_HAIR_COLOR", nil);

  return _editingHairColorCell;
}

- (AWFPickerViewCell *)editingEyeColorCell {
  if (!_editingEyeColorCell) {
    _editingEyeColorCell = [[AWFPickerViewCell alloc] init];
    _editingEyeColorCell.pickerView.dataSource = self;
    _editingEyeColorCell.pickerView.delegate = self;
  }

  _editingEyeColorCell.titleLabel.text = NSLocalizedString(@"AWF_EYE_COLOR", nil);

  return _editingEyeColorCell;
}

#pragma mark - Cell arrays

- (NSArray *)normalCells {
  return @[@[self.locationCell],
           @[self.genderCell, self.ageCell, self.birthdayCell],
           @[self.heightCell, self.weightCell, self.bodyBuildCell,
             self.hairLengthCell, self.hairColorCell, self.eyeColorCell]];
}

- (NSArray *)editingCells {
  return @[@[self.editingGenderCell, self.editingBirthdayCell],
           @[self.editingHeightCell, self.editingWeightCell, self.editingBodyBuildCell,
             self.editingHairLengthCell, self.editingHairColorCell, self.editingEyeColorCell]];
}

- (NSArray *)currentCells {
  return self.editing ? self.editingCells : self.normalCells;
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

#pragma mark - Data Arrays

- (NSArray *)genders {
  if (!_genders) {
    _genders = @[@(AWFGenderUnknown), @(AWFGenderFemale), @(AWFGenderMale)];
  }
  return _genders;
}

- (NSArray *)bodyBuilds {
  if (!_bodyBuilds) {
    _bodyBuilds = @[@(AWFBodyBuildUnknown),
                    @(AWFBodyBuildSlim),
                    @(AWFBodyBuildAverage),
                    @(AWFBodyBuildAthletic),
                    @(AWFBodyBuildExtraPounds)];
  }
  return _bodyBuilds;
}

- (NSArray *)hairLengths {
  if (!_hairLengths) {
    _hairLengths = @[@(AWFHairLengthUnknown), @(AWFHairLengthShort), @(AWFHairLengthMedium), @(AWFHairLengthLong)];
  }
  return _hairLengths;
}

- (NSArray *)hairColors {
  if (!_hairColors) {
    _hairColors = @[@(AWFHairColorUnknown),
                    @(AWFHairColorAuburn),
                    @(AWFHairColorBlack),
                    @(AWFHairColorBlond),
                    @(AWFHairColorBrown),
                    @(AWFHairColorChestnut),
                    @(AWFHairColorGray),
                    @(AWFHairColorRed),
                    @(AWFHairColorWhite)];;
  }
  return _hairColors;
}

- (NSArray *)eyeColors {
  if (!_eyeColors) {
    _eyeColors = @[@(AWFEyeColorUnknown),
                   @(AWFEyeColorAmber),
                   @(AWFEyeColorBlue),
                   @(AWFEyeColorBrown),
                   @(AWFEyeColorGray),
                   @(AWFEyeColorGreen),
                   @(AWFEyeColorHazel),
                   @(AWFEyeColorRed),
                   @(AWFEyeColorViolet)];
  }
  return _eyeColors;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  if (pickerView == self.editingGenderCell.pickerView) {
    return 1;
  }
  else if (pickerView == self.editingHeightCell.pickerView) {
    return 2;
  }
  else if (pickerView == self.editingWeightCell.pickerView) {
    return 1;
  }
  else if (pickerView == self.editingBodyBuildCell.pickerView) {
    return 1;
  }
  else if (pickerView == self.editingHairLengthCell.pickerView) {
    return 1;
  }
  else if (pickerView == self.editingHairColorCell.pickerView) {
    return 1;
  }
  else if (pickerView == self.editingEyeColorCell.pickerView) {
    return 1;
  }

  return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if (pickerView == self.editingGenderCell.pickerView) {
    return [self.genders count];
  }
  else if (pickerView == self.editingHeightCell.pickerView) {
    if (isMetric) {
      if (component == 0) {
        return 3;
      }
      else {
        return 100;
      }
    }
    else {
      if (component == 0) {
        return 5;
      }
      else {
        return 12;
      }
    }
    return 180;
  }
  else if (pickerView == self.editingWeightCell.pickerView) {
    return 200;
  }
  else if (pickerView == self.editingBodyBuildCell.pickerView) {
    return [self.bodyBuilds count];
  }
  else if (pickerView == self.editingHairLengthCell.pickerView) {
    return [self.hairLengths count];
  }
  else if (pickerView == self.editingHairColorCell.pickerView) {
    return [self.hairColors count];
  }
  else if (pickerView == self.editingEyeColorCell.pickerView) {
    return [self.eyeColors count];
  }

  return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

  if (pickerView == self.editingGenderCell.pickerView) {
    return [[self.genderFormatter stringForObjectValue:self.genders[row]] capitalizedString];
  }
  else if (pickerView == self.editingHeightCell.pickerView) {
    if (isMetric) {
      return [self.heightFormatter stringFromHeight:@(row)];
    }
    else {
      if (component == 0) {
        return [self.heightFormatter stringFromHeight:@((row + 3.0f) * 30.48f)];
      }
      else {
        return [self.heightFormatter stringFromHeight:@(row * 2.54f)];
      }
    }
  }
  else if (pickerView == self.editingWeightCell.pickerView) {
    if (isMetric) {
      return [self.weightFormatter stringFromWeight:@(row + 30.0f)];
    }
    else {
      return [self.weightFormatter stringFromWeight:@(row * 0.45f + 30.0f)];
    }
  }
  else if (pickerView == self.editingBodyBuildCell.pickerView) {
    return [[self.bodyBuildFormatter stringForObjectValue:self.bodyBuilds[row]] capitalizedString];
  }
  else if (pickerView == self.editingHairLengthCell.pickerView) {
    return [[self.hairLengthFormatter stringForObjectValue:self.hairLengths[row]] capitalizedString];
  }
  else if (pickerView == self.editingHairColorCell.pickerView) {
    return [[self.hairColorFormatter stringForObjectValue:self.hairColors[row]] capitalizedString];
  }
  else if (pickerView == self.editingEyeColorCell.pickerView) {
    return [[self.eyeColorFormatter stringForObjectValue:self.eyeColors[row]] capitalizedString];
  }

  return nil;
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

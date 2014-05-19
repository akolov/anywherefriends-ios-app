//
//  AWFProfileDataSource.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import UIKit;

@class AWFAgeFormatter;
@class AWFBodyBuildFormatter;
@class AWFEyeColorFormatter;
@class AWFGenderFormatter;
@class AWFHairColorFormatter;
@class AWFHairLengthFormatter;
@class AWFHeightFormatter;
@class AWFWeightFormatter;
@class TTTTimeIntervalFormatter;

@class AWFDatePickerViewCell;
@class AWFPerson;
@class AWFPickerViewCell;
@class AWFProfileCell;

@interface AWFProfileDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableViewCell *locationCell;
@property (nonatomic, strong, readonly) UITableViewCell *genderCell;
@property (nonatomic, strong, readonly) UITableViewCell *ageCell;
@property (nonatomic, strong, readonly) UITableViewCell *birthdayCell;
@property (nonatomic, strong, readonly) UITableViewCell *heightCell;
@property (nonatomic, strong, readonly) UITableViewCell *weightCell;
@property (nonatomic, strong, readonly) UITableViewCell *bodyBuildCell;
@property (nonatomic, strong, readonly) UITableViewCell *hairLengthCell;
@property (nonatomic, strong, readonly) UITableViewCell *hairColorCell;
@property (nonatomic, strong, readonly) UITableViewCell *eyeColorCell;

@property (nonatomic, strong, readonly) AWFPickerViewCell *editingGenderCell;
@property (nonatomic, strong, readonly) AWFDatePickerViewCell *editingBirthdayCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingHeightCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingWeightCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingBodyBuildCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingHairLengthCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingHairColorCell;
@property (nonatomic, strong, readonly) AWFPickerViewCell *editingEyeColorCell;

@property (nonatomic, strong, readonly) NSArray *currentCells;
@property (nonatomic, strong, readonly) NSArray *normalCells;
@property (nonatomic, strong, readonly) NSArray *editingCells;

@property (nonatomic, strong, readonly) AWFAgeFormatter *ageFormatter;
@property (nonatomic, strong, readonly) NSDateFormatter *birthdayFormatter;
@property (nonatomic, strong, readonly) AWFBodyBuildFormatter *bodyBuildFormatter;
@property (nonatomic, strong, readonly) AWFEyeColorFormatter *eyeColorFormatter;
@property (nonatomic, strong, readonly) AWFGenderFormatter *genderFormatter;
@property (nonatomic, strong, readonly) AWFHairColorFormatter *hairColorFormatter;
@property (nonatomic, strong, readonly) AWFHairLengthFormatter *hairLengthFormatter;
@property (nonatomic, strong, readonly) AWFHeightFormatter *heightFormatter;
@property (nonatomic, strong, readonly) AWFWeightFormatter *weightFormatter;
@property (nonatomic, strong, readonly) TTTTimeIntervalFormatter *timeFormatter;

@property (nonatomic, strong) AWFPerson *person;
@property (nonatomic, assign, getter = isEditing) BOOL editing;
@property (nonatomic, assign, getter = isOwnProfile) BOOL ownProfile;

+ (void)setupNormalCellStyle:(UITableViewCell *)cell;
+ (void)setupEditingCellStyle:(UITableViewCell *)cell;

@end

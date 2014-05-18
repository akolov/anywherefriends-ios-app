//
//  AWFDatePickerViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFDatePickerViewCell.h"

@interface AWFDatePickerViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation AWFDatePickerViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleLabel];

    self.datePicker = [UIDatePicker autolayoutView];
    self.datePicker.tintColor = [UIColor whiteColor];
    [self.contentView addSubview:self.datePicker];
  }
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    CGRect bounds = self.contentView.bounds;
    bounds.size.height = 100.0f;
    self.contentView.bounds = bounds;

    [self.contentView pin:@"H:|-15.0-[titleLabel]-(>=0)-|" options:0 owner:self];
    [self.datePicker pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView pin:@"V:|-15.0-[titleLabel]-[datePicker]-15.0-|" options:0 owner:self];

    self.didSetupConstraints = YES;
  }
  [super updateConstraints];
}

- (UILabel *)textLabel {
  return self.titleLabel;
}
@end

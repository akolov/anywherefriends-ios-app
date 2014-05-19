//
//  AWFPickerViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFPickerViewCell.h"

@interface AWFPickerViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation AWFPickerViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.titleLabel];

    self.pickerView = [UIPickerView autolayoutView];
    self.pickerView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    [self.contentView addSubview:self.pickerView];
  }
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    CGRect bounds = self.contentView.bounds;
    bounds.size.height = 100.0f;
    self.contentView.bounds = bounds;

    [self.contentView pin:@"H:|-15.0-[titleLabel]-(>=0)-|" options:0 owner:self];
    [self.pickerView pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView pin:@"V:|-15.0-[titleLabel]-[pickerView]-15.0-|" options:0 owner:self];

    self.didSetupConstraints = YES;
  }
  [super updateConstraints];
}

- (UILabel *)textLabel {
  return self.titleLabel;
}


@end

//
//  AWFPickerViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFPickerViewCell.h"

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
    [self.contentView addSubview:self.pickerView];

    [self pin:@"H:|-15.0-[titleLabel]-(>=0)-|" options:0 owner:self];
    [self.pickerView pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self pin:@"V:|-15.0-[titleLabel]-[pickerView]-15.0-|" options:0 owner:self];
  }
  return self;
}

@end

//
//  AWFLoginFormViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/6/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFLoginFormViewCell.h"


@interface AWFLoginFormViewCell ()

@property (nonatomic, strong) UITextField *textField;

@end


@implementation AWFLoginFormViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 11.0f, CGRectGetWidth(self.bounds) - 100.0f - 20.0f, 22.0f)];
    self.textField.font = [UIFont avenirNextCondensedFontOfSize:16.0f];
    [self.contentView addSubview:self.textField];

    self.textLabel.font = [UIFont demiBoldAvenirNextCondensedFontOfSize:16.0f];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.textLabel setFrameWidth:70.0f];
}

@end

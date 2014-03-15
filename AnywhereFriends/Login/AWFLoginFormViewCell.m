//
//  AWFLoginFormViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/6/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLoginFormViewCell.h"

@implementation AWFLoginFormViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

//    self.textField.font = [UIFont helveticaNeueCondensedLightFontOfSize:16.0f];

    self.textLabel.font = [UIFont helveticaNeueCondensedMediumFontOfSize:16.0f];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect frame = self.textLabel.frame;
  frame.size.width = 70.0f;
  self.textLabel.frame = frame;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.field removeFromSuperview];
}

- (void)setField:(UIView *)field {
  if (_field == field) {
    return;
  }

  _field = field;

  [self addSubview:field];
}

@end

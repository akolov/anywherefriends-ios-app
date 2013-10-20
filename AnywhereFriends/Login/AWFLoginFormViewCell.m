//
//  AWFLoginFormViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/6/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFLoginFormViewCell.h"


@interface AWFLoginFormViewCell ()

@end


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
  [self.textLabel setFrameWidth:70.0f];
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

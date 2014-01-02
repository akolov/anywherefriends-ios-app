//
//  AWFNearbyViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNearbyViewCell.h"

@implementation AWFNearbyViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 52.0f, 0, 0);

    _placeholderView = [UILabel autolayoutView];
    _placeholderView.backgroundColor = [UIColor lightGrayColor];
    _placeholderView.textAlignment = NSTextAlignmentCenter;
    _placeholderView.textColor = [UIColor whiteColor];
    _placeholderView.layer.cornerRadius = 17.5f;
    _placeholderView.layer.masksToBounds = YES;
    [self.contentView addSubview:_placeholderView];

    _nameLabel = [UILabel autolayoutView];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:_nameLabel];

    _locationLabel = [UILabel autolayoutView];
    _locationLabel.backgroundColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:_locationLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _locationLabel, _placeholderView);

    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-8.0-[_placeholderView(35.0)]-[_nameLabel]"
                          options:NSLayoutFormatAlignAllTop
                          metrics:nil
                          views:views]];

    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeholderView
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:self.contentView
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1.0f
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeholderView
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1.0f
                         constant:35.0f]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeholderView
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:_locationLabel
                         attribute:NSLayoutAttributeBaseline
                         multiplier:1.0f
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_nameLabel
                         attribute:NSLayoutAttributeLeading
                         relatedBy:NSLayoutRelationEqual
                         toItem:_locationLabel
                         attribute:NSLayoutAttributeLeading
                         multiplier:1.0f
                         constant:0]];
  }
  return self;
}

@end

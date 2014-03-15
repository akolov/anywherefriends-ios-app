//
//  AWFNearbyViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 23/12/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
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
    _locationLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_locationLabel];

    [self.contentView pin:@"H:|-8.0-[placeholderView(35.0)]-[nameLabel]|" options:NSLayoutFormatAlignAllTop owner:self];
    [self.contentView pin:@"H:[placeholderView]-[locationLabel]|" options:0 owner:self];
    [_placeholderView pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [_placeholderView pinEdge:NSLayoutAttributeBottom toView:_locationLabel edge:NSLayoutAttributeBaseline];
    [_placeholderView pinHeight:35.0f withRelation:NSLayoutRelationEqual];
  }
  return self;
}

@end

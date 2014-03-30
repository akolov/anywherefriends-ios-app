//
//  AWFMessagesViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMessagesViewCell.h"

@implementation AWFMessagesViewCell

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

    _unreadIndicator = [UIView autolayoutView];
    _unreadIndicator.backgroundColor = [UIColor redColor];
    _unreadIndicator.layer.cornerRadius = 5.0f;
    _unreadIndicator.layer.masksToBounds = YES;
    [self.contentView addSubview:_unreadIndicator];

    _nameLabel = [UILabel autolayoutView];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:_nameLabel];

    _timeLabel = [UILabel autolayoutView];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];

    _lastMessageLabel = [UILabel autolayoutView];
    _lastMessageLabel.backgroundColor = [UIColor whiteColor];
    _lastMessageLabel.font = [UIFont systemFontOfSize:12.0f];
    _lastMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _lastMessageLabel.numberOfLines = 0;
    _lastMessageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 16.0f - 35.0f - 8.0f;
    _lastMessageLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_lastMessageLabel];

    [_lastMessageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [self.contentView pin:@"H:|-8.0-[placeholderView]-8.0-[nameLabel]-(>=0)-[timeLabel]-8.0-|"
                  options:NSLayoutFormatAlignAllTop owner:self];
    [self.contentView pin:@"V:|-8.0-[nameLabel]-4.0-[lastMessageLabel]-(>=8.0)-|" options:0 owner:self];
    [self.contentView pin:@"H:[placeholderView]-8.0-[lastMessageLabel]-8.0-|" options:0 owner:self];
    [_placeholderView pinSize:CGSizeMake(35.0f, 35.0f) withRelation:NSLayoutRelationEqual];

    [_unreadIndicator pinSize:CGSizeMake(10.0f, 10.0f) withRelation:NSLayoutRelationEqual];
    [_unreadIndicator pinToCenterOfView:_placeholderView onAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView pin:@"V:[placeholderView]-8.0-[unreadIndicator]" options:0 owner:self];
  }
  return self;
}

@end

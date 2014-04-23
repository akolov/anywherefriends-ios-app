//
//  AWFMessagesRequestCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 22/04/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMessagesRequestCell.h"

@interface AWFMessagesRequestCell ()

- (void)onAcceptButtonTouchUpInside:(id)sender;
- (void)onIgnoreButtonTouchUpInside:(id)sender;

@end

@implementation AWFMessagesRequestCell

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

    _acceptButton = [UIButton autolayoutView];
    _acceptButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_acceptButton setTitle:[NSLocalizedString(@"AWF_ACCEPT", nil) uppercaseString] forState:UIControlStateNormal];
    [_acceptButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_acceptButton addTarget:self action:@selector(onAcceptButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_acceptButton];

    _ignoreButton = [UIButton autolayoutView];
    _ignoreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_ignoreButton setTitle:[NSLocalizedString(@"AWF_REJECT", nil) uppercaseString] forState:UIControlStateNormal];
    [_ignoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_ignoreButton addTarget:self action:@selector(onIgnoreButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_ignoreButton];

    [self.contentView pin:@"H:|-8.0-[placeholderView]-8.0-[nameLabel]-(>=0)-[timeLabel]-8.0-|"
                  options:NSLayoutFormatAlignAllTop owner:self];
    [self.contentView pin:@"V:|-8.0-[nameLabel]-4.0-[lastMessageLabel]-8.0-[ignoreButton]-(>=8.0)-|" options:0 owner:self];
    [self.contentView pin:@"H:[placeholderView]-8.0-[lastMessageLabel]-8.0-|" options:0 owner:self];
    [self.contentView pin:@"H:[placeholderView]-8.0-[ignoreButton][acceptButton(==ignoreButton)]-8.0-|" options:0 owner:self];
    [_acceptButton pinToCenterOfView:_ignoreButton onAxis:UILayoutConstraintAxisVertical];
    [_placeholderView pinSize:CGSizeMake(35.0f, 35.0f) withRelation:NSLayoutRelationEqual];
  }
  return self;
}

- (void)onAcceptButtonTouchUpInside:(id)sender {
  AWF_SAFE_CALLBACK(self.onAcceptAction);
}

- (void)onIgnoreButtonTouchUpInside:(id)sender {
  AWF_SAFE_CALLBACK(self.onIgnoreAction);
}

@end

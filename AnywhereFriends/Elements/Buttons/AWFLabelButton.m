//
//  AWFLabelButton.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFLabelButton.h"


@interface AWFLabelButton ()

@property (nonatomic, strong) NSMutableDictionary *titleColors;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation AWFLabelButton

#pragma mark - UIControl methods

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
  }
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
  }
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
  }
}

#pragma mark - Private methods

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [UILabel autolayoutView];
    _titleLabel.backgroundColor = nil;
    _titleLabel.opaque = NO;
    [self addSubview:_titleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
  }
  return _titleLabel;
}

- (UIColor *)titleColorForState:(UIControlState)state {
  return self.titleColors[@(state)] ?: self.titleColors[@(UIControlStateNormal)];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
  if (!self.titleColors) {
    self.titleColors = [NSMutableDictionary dictionary];
  }

  if (color) {
    self.titleColors[@(state)] = color;
  }
  else {
    [self.titleColors removeObjectForKey:@(state)];
  }

  if (state == self.state) {
    self.titleLabel.textColor = [self titleColorForState:self.state];
  }
}

@end

//
//  AWFLabelButton.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFLabelButton.h"


@interface AWFLabelButton ()

@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *titleColors;
@property (nonatomic, strong) NSMutableDictionary *insets;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) NSLayoutConstraint *horizontalConstraint;
@property (nonatomic, weak) NSLayoutConstraint *verticalConstraint;

- (void)updateButtonForState:(UIControlState)state;

@end


@implementation AWFLabelButton

#pragma mark - UIControl methods

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  [self updateButtonForState:self.state];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  [self updateButtonForState:self.state];
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [self updateButtonForState:self.state];
}

#pragma mark - Private methods

- (void)updateButtonForState:(UIControlState)state {
  NSString *text = [self titleTextForState:self.state];
  if (text) {
    self.titleLabel.text = text;
  }

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
  }

  UIEdgeInsets inset = [self contentEdgeInsetsForState:self.state];
  self.horizontalConstraint.constant = inset.left - inset.right;
  self.verticalConstraint.constant = inset.top - inset.bottom;
}

#pragma mark - Public methods

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [UILabel autolayoutView];
    _titleLabel.backgroundColor = nil;
    _titleLabel.opaque = NO;
    [self addSubview:_titleLabel];

    UIEdgeInsets inset = [self contentEdgeInsetsForState:self.state];
    NSLayoutConstraint *horizontal = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:(inset.left - inset.right)];
    NSLayoutConstraint *vertical = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:(inset.top - inset.bottom)];

    [self addConstraint:horizontal];
    [self addConstraint:vertical];

    self.horizontalConstraint = horizontal;
    self.verticalConstraint = vertical;
  }
  return _titleLabel;
}

- (NSString *)titleTextForState:(UIControlState)state {
  return self.titles[@(state)] ?: self.titleLabel.text;
}

- (void)setTitleText:(NSString *)text forState:(UIControlState)state {
  if (!self.titles) {
    self.titles = [NSMutableDictionary dictionary];
  }

  if (text) {
    self.titles[@(state)] = text;
  }
  else {
    [self.titles removeObjectForKey:@(state)];
  }

  if (state == self.state) {
    self.titleLabel.text = [self titleTextForState:self.state];
  }
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

- (UIEdgeInsets)contentEdgeInsetsForState:(UIControlState)state {
  return [self.insets[@(state)] UIEdgeInsetsValue];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)inset forState:(UIControlState)state {
  if (!self.insets) {
    self.insets = [NSMutableDictionary dictionary];
  }

  self.insets[@(state)] = [NSValue valueWithUIEdgeInsets:inset];

  if (state == self.state) {
    self.horizontalConstraint.constant = inset.left - inset.right;
    self.verticalConstraint.constant = inset.top - inset.bottom;
  }
}

@end

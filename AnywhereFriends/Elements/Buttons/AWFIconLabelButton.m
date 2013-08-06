//
//  AWFIconLabelButton.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/5/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFIconLabelButton.h"


@interface AWFIconLabelButton ()

@property (nonatomic, strong) NSMutableDictionary *titleColors;
@property (nonatomic, strong) AWFIconLabelView *contentView;

- (void)initIconLabelButton;

@end


@implementation AWFIconLabelButton

- (void)initIconLabelButton {
  self.contentView = [AWFIconLabelView autolayoutView];
  self.contentView.userInteractionEnabled = NO;
  [self addSubview:self.contentView];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initIconLabelButton];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initIconLabelButton];
}

- (void)invalidateIntrinsicContentSize {
  [self.subviews makeObjectsPerformSelector:@selector(invalidateIntrinsicContentSize)];
  [super invalidateIntrinsicContentSize];
}

#pragma mark - UIControl methods

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];

  UIColor *color = [self titleColorForState:self.state];
  if (color) {
    self.titleLabel.textColor = color;
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

#pragma mark - Public Methods

- (AWFShapeView *)icon {
  return self.contentView.icon;
}

- (UILabel *)titleLabel {
  return self.contentView.label;
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
    UIColor *stateColor = [self titleColorForState:self.state];
    self.titleLabel.textColor = stateColor;
    self.icon.shapeLayer.fillColor = stateColor.CGColor;
  }
}

@end

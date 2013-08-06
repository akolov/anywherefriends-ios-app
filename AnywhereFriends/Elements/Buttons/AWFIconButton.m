//
//  AWFIconButton.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFIconButton.h"
#import "AWFShapeView.h"


@interface AWFIconButton ()

@property (nonatomic, strong) AWFShapeView *icon;
@property (nonatomic, strong) NSMutableDictionary *iconColors;

@end


@implementation AWFIconButton

- (CGSize)intrinsicContentSize {
  return self.icon.intrinsicContentSize;
}

#pragma mark - UIControl methods

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];

  UIColor *color = [self iconColorForState:self.state];
  if (color) {
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  UIColor *color = [self iconColorForState:self.state];
  if (color) {
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];

  UIColor *color = [self iconColorForState:self.state];
  if (color) {
    self.icon.shapeLayer.fillColor = color.CGColor;
  }
}

#pragma mark - Private methods

- (AWFShapeView *)icon {
  if (!_icon) {
    self.icon = [AWFShapeView autolayoutView];
    self.icon.userInteractionEnabled = NO;
    [self addSubview:self.icon];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
  }
  return _icon;
}

- (UIColor *)iconColorForState:(UIControlState)state {
  if (!self.iconColors) {
    return [UIColor blackColor];
  }

  return self.iconColors[@(state)] ?: self.iconColors[@(UIControlStateNormal)];
}

- (void)setIconColor:(UIColor *)color forState:(UIControlState)state {
  if (!self.iconColors) {
    self.iconColors = [NSMutableDictionary dictionary];
  }

  if (color) {
    self.iconColors[@(state)] = color;
  }
  else {
    [self.iconColors removeObjectForKey:@(state)];
  }

  if (state == self.state) {
    self.icon.shapeLayer.fillColor = [self iconColorForState:self.state].CGColor;
  }
}

@end

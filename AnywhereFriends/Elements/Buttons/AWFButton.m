//
//  AWFButton.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFButton.h"


@interface AWFButton ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableDictionary *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary *backgroundImages;

@end


@implementation AWFButton

#pragma mark - UIControl methods

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];

  UIColor *color = [self backgroundColorForState:self.state];
  if (color) {
    self.backgroundColor = color;
  }

  UIImage *image = [self backgroundImageForState:self.state];
  if (image) {
    self.backgroundImageView.image = image;
  }
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  UIColor *color = [self backgroundColorForState:self.state];
  if (color) {
    self.backgroundColor = color;
  }

  UIImage *image = [self backgroundImageForState:self.state];
  if (image) {
    self.backgroundImageView.image = image;
  }
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];

  UIColor *color = [self backgroundColorForState:self.state];
  if (color) {
    self.backgroundColor = color;
  }

  UIImage *image = [self backgroundImageForState:self.state];
  if (image) {
    self.backgroundImageView.image = image;
  }
}

#pragma mark - Private methods

- (UIImageView *)backgroundImageView {
  if (!_backgroundImageView) {
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:_backgroundImageView atIndex:0];
  }
  return _backgroundImageView;
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
  return self.backgroundColors[@(state)] ?: self.backgroundColors[@(UIControlStateNormal)];
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
  if (!self.backgroundColors) {
    self.backgroundColors = [NSMutableDictionary dictionary];
  }

  if (color) {
    self.backgroundColors[@(state)] = color;
  }
  else {
    [self.backgroundColors removeObjectForKey:@(state)];
  }

  if (state == self.state) {
    self.backgroundColor = [self backgroundColorForState:self.state];
  }
}

- (UIImage *)backgroundImageForState:(UIControlState)state {
  return self.backgroundImages[@(state)] ?: self.backgroundImages[@(UIControlStateNormal)];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state {
  if (!self.backgroundImages) {
    self.backgroundImages = [NSMutableDictionary dictionary];
  }

  if (backgroundImage) {
    self.backgroundImages[@(state)] = backgroundImage;
  }
  else {
    [self.backgroundImages removeObjectForKey:@(state)];
  }

  if (state == self.state) {
    UIImage *image = [self backgroundImageForState:self.state];
    if (backgroundImage) {
      self.backgroundImageView.image = image;
    }
  }
}

@end

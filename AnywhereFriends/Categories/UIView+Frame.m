//
//  UIView+Frame.m
//  WeatherGrid
//
//  Created by Alexander Kolov on 2/13/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setFrameOriginX:(CGFloat)newX {
  CGRect f = self.frame;
  f.origin.x = newX;
  self.frame = f;
}

- (void)setFrameOriginY:(CGFloat)newY {
  CGRect f = self.frame;
  f.origin.y = newY;
  self.frame = f;
}

- (void)setFrameOffset:(CGSize)offset {
  self.frame = CGRectOffset(self.frame, offset.width, offset.height);
}

- (void)setFrameOffsetX:(CGFloat)offsetX {
  self.frame = CGRectOffset(self.frame, offsetX, 0);
}

- (void)setFrameOffsetY:(CGFloat)offsetY {
  self.frame = CGRectOffset(self.frame, 0, offsetY);
}

- (void)setFrameWidth:(CGFloat)newWidth {
  CGRect f = self.frame;
  f.size.width = newWidth;
  self.frame = f;
}

- (void)setFrameHeight:(CGFloat)newHeight {
  CGRect f = self.frame;
  f.size.height = newHeight;
  self.frame = f;
}

- (void)setFrameOrigin:(CGPoint)origin {
  CGRect f = self.frame;
  f.origin = origin;
  self.frame = f;
}

- (void)setFrameSize:(CGSize)size {
  CGRect f = self.frame;
  f.size = size;
  self.frame = f;
}

- (void)growFrameWidth:(CGFloat)growWidth {
  CGRect f = self.frame;
  f.size.width += growWidth;
  self.frame = f;
}

- (void)growFrameHeight:(CGFloat)growHeight {
  CGRect f = self.frame;
  f.size.height += growHeight;
  self.frame = f;
}

@end

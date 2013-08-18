//
//  UIBezierPath+AccessoryArrowGlyph.m
//  Stylight
//
//  Created by Alexander Kolov on 8/5/13.
//  Copyright (c) 2013 Stylight. All rights reserved.
//

#import "UIBezierPath+AccessoryArrowGlyph.h"

@implementation UIBezierPath (AccessoryArrowGlyph)

+ (instancetype)accessoryArrowGlyph {
  UIBezierPath* accessoryArrowPath = [UIBezierPath bezierPath];
  [accessoryArrowPath moveToPoint:CGPointMake(0, 1.29f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(4.52f, 5.86f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(0, 10.71f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(1.31f, 12.0f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(7.0f, 6.0f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(6.79f, 5.83f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(7.0f, 5.57f)];
  [accessoryArrowPath addLineToPoint:CGPointMake(1.31f, 0)];
  [accessoryArrowPath addLineToPoint:CGPointMake(0, 1.29f)];
  [accessoryArrowPath closePath];
  [accessoryArrowPath setMiterLimit:4.0f];
  return accessoryArrowPath;
}

@end

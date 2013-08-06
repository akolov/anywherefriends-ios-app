//
//  UIBezierPath+FacebookGlyph.m
//  Stylight
//
//  Created by Alexander Kolov on 5/24/13.
//  Copyright (c) 2013 Stylight. All rights reserved.
//

#import "UIBezierPath+FacebookGlyph.h"

@implementation UIBezierPath (FacebookGlyph)

+ (instancetype)facebookGlyph {
  UIBezierPath *facebookPath = [UIBezierPath bezierPath];
  [facebookPath moveToPoint:CGPointMake(19.0f, 6.22f)];
  [facebookPath addLineToPoint:CGPointMake(14.14f, 6.22f)];
  [facebookPath addCurveToPoint:CGPointMake(12.93f, 7.95f) controlPoint1:CGPointMake(13.57f, 6.22f) controlPoint2:CGPointMake(12.93f, 6.96f)];
  [facebookPath addLineToPoint:CGPointMake(12.93f, 11.38f)];
  [facebookPath addLineToPoint:CGPointMake(19.0f, 11.38f)];
  [facebookPath addLineToPoint:CGPointMake(19.0f, 16.28f)];
  [facebookPath addLineToPoint:CGPointMake(12.93f, 16.28f)];
  [facebookPath addLineToPoint:CGPointMake(12.93f, 31.0f)];
  [facebookPath addLineToPoint:CGPointMake(7.2f, 31.0f)];
  [facebookPath addLineToPoint:CGPointMake(7.2f, 16.28f)];
  [facebookPath addLineToPoint:CGPointMake(2.0f, 16.28f)];
  [facebookPath addLineToPoint:CGPointMake(2.0f, 11.38f)];
  [facebookPath addLineToPoint:CGPointMake(7.2f, 11.38f)];
  [facebookPath addLineToPoint:CGPointMake(7.2f, 8.5f)];
  [facebookPath addCurveToPoint:CGPointMake(14.14f, 1.0f) controlPoint1:CGPointMake(7.2f, 4.36f) controlPoint2:CGPointMake(10.12f, 1.0f)];
  [facebookPath addLineToPoint:CGPointMake(19.0f, 1.0f)];
  [facebookPath addLineToPoint:CGPointMake(19.0f, 6.22f)];
  [facebookPath closePath];
  [facebookPath setMiterLimit:4.0f];
  return facebookPath;
}

@end

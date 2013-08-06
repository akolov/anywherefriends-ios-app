//
//  UIBezierPath+TwitterGlyph.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 5/24/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "UIBezierPath+TwitterGlyph.h"

@implementation UIBezierPath (TwitterGlyph)

+ (instancetype)twitterGlyph {
  UIBezierPath *twitterPath = [UIBezierPath bezierPath];
  [twitterPath moveToPoint:CGPointMake(33.0f, 3.96f)];
  [twitterPath addCurveToPoint:CGPointMake(29.35f, 4.95f) controlPoint1:CGPointMake(31.86f, 4.46f) controlPoint2:CGPointMake(30.63f, 4.8f)];
  [twitterPath addCurveToPoint:CGPointMake(32.14f, 1.46f) controlPoint1:CGPointMake(30.66f, 4.17f) controlPoint2:CGPointMake(31.67f, 2.94f)];
  [twitterPath addCurveToPoint:CGPointMake(28.1f, 2.99f) controlPoint1:CGPointMake(30.91f, 2.18f) controlPoint2:CGPointMake(29.55f, 2.71f)];
  [twitterPath addCurveToPoint:CGPointMake(23.46f, 1.0f) controlPoint1:CGPointMake(26.94f, 1.77f) controlPoint2:CGPointMake(25.29f, 1.0f)];
  [twitterPath addCurveToPoint:CGPointMake(17.1f, 7.31f) controlPoint1:CGPointMake(19.95f, 1.0f) controlPoint2:CGPointMake(17.1f, 3.83f)];
  [twitterPath addCurveToPoint:CGPointMake(17.27f, 8.75f) controlPoint1:CGPointMake(17.1f, 7.81f) controlPoint2:CGPointMake(17.16f, 8.29f)];
  [twitterPath addCurveToPoint:CGPointMake(4.16f, 2.15f) controlPoint1:CGPointMake(11.98f, 8.49f) controlPoint2:CGPointMake(7.29f, 5.97f)];
  [twitterPath addCurveToPoint:CGPointMake(3.3f, 5.33f) controlPoint1:CGPointMake(3.61f, 3.09f) controlPoint2:CGPointMake(3.3f, 4.17f)];
  [twitterPath addCurveToPoint:CGPointMake(6.13f, 10.58f) controlPoint1:CGPointMake(3.3f, 7.52f) controlPoint2:CGPointMake(4.42f, 9.45f)];
  [twitterPath addCurveToPoint:CGPointMake(3.25f, 9.79f) controlPoint1:CGPointMake(5.08f, 10.55f) controlPoint2:CGPointMake(4.1f, 10.26f)];
  [twitterPath addCurveToPoint:CGPointMake(3.24f, 9.87f) controlPoint1:CGPointMake(3.24f, 9.82f) controlPoint2:CGPointMake(3.24f, 9.84f)];
  [twitterPath addCurveToPoint:CGPointMake(8.35f, 16.06f) controlPoint1:CGPointMake(3.24f, 12.93f) controlPoint2:CGPointMake(5.44f, 15.48f)];
  [twitterPath addCurveToPoint:CGPointMake(6.67f, 16.28f) controlPoint1:CGPointMake(7.81f, 16.2f) controlPoint2:CGPointMake(7.25f, 16.28f)];
  [twitterPath addCurveToPoint:CGPointMake(5.47f, 16.17f) controlPoint1:CGPointMake(6.26f, 16.28f) controlPoint2:CGPointMake(5.86f, 16.24f)];
  [twitterPath addCurveToPoint:CGPointMake(11.42f, 20.55f) controlPoint1:CGPointMake(6.28f, 18.67f) controlPoint2:CGPointMake(8.63f, 20.5f)];
  [twitterPath addCurveToPoint:CGPointMake(3.52f, 23.25f) controlPoint1:CGPointMake(9.24f, 22.24f) controlPoint2:CGPointMake(6.5f, 23.25f)];
  [twitterPath addCurveToPoint:CGPointMake(2.0f, 23.16f) controlPoint1:CGPointMake(3.0f, 23.25f) controlPoint2:CGPointMake(2.5f, 23.22f)];
  [twitterPath addCurveToPoint:CGPointMake(11.75f, 26.0f) controlPoint1:CGPointMake(4.81f, 24.95f) controlPoint2:CGPointMake(8.16f, 26.0f)];
  [twitterPath addCurveToPoint:CGPointMake(29.84f, 8.04f) controlPoint1:CGPointMake(23.45f, 26.0f) controlPoint2:CGPointMake(29.84f, 16.38f)];
  [twitterPath addCurveToPoint:CGPointMake(29.83f, 7.23f) controlPoint1:CGPointMake(29.84f, 7.77f) controlPoint2:CGPointMake(29.84f, 7.5f)];
  [twitterPath addCurveToPoint:CGPointMake(33.0f, 3.96f) controlPoint1:CGPointMake(31.07f, 6.34f) controlPoint2:CGPointMake(32.15f, 5.22f)];
  [twitterPath closePath];
  [twitterPath setMiterLimit:4.0f];
  return twitterPath;
}

@end

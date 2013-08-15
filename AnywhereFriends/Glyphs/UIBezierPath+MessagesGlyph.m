//
//  UIBezierPath+MessagesGlyph.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIBezierPath+MessagesGlyph.h"

@implementation UIBezierPath (MessagesGlyph)

+ (instancetype)messagesGlyph {
  UIBezierPath *messagesGlyphPath = [UIBezierPath bezierPath];
  [messagesGlyphPath moveToPoint:CGPointMake(8.5f, 12.79f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(16.5f, 6.64f) controlPoint1:CGPointMake(12.92f, 12.79f) controlPoint2:CGPointMake(16.5f, 10.04f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(8.5f, 0.5f) controlPoint1:CGPointMake(16.5f, 3.25f) controlPoint2:CGPointMake(12.92f, 0.5f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(0.5f, 6.64f) controlPoint1:CGPointMake(4.08f, 0.5f) controlPoint2:CGPointMake(0.5f, 3.25f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(3.78f, 11.61f) controlPoint1:CGPointMake(0.5f, 8.68f) controlPoint2:CGPointMake(1.79f, 10.49f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(1.31f, 15.5f) controlPoint1:CGPointMake(3.78f, 11.62f) controlPoint2:CGPointMake(1.31f, 15.5f)];
  [messagesGlyphPath addLineToPoint:CGPointMake(7.04f, 12.68f)];
  [messagesGlyphPath addCurveToPoint:CGPointMake(8.5f, 12.79f) controlPoint1:CGPointMake(7.51f, 12.75f) controlPoint2:CGPointMake(8.0f, 12.79f)];
  [messagesGlyphPath closePath];
  return messagesGlyphPath;
}

@end

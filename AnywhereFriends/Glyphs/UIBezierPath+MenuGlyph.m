//
//  UIBezierPath+MenuGlyph.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UIBezierPath+MenuGlyph.h"

@implementation UIBezierPath (MenuGlyph)

+ (instancetype)menuGlyph {
  UIBezierPath *menuGlyphPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 22.0f, 3.0f) cornerRadius:2.0f];
  [menuGlyphPath appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 6.0f, 22.0f, 3.0f) cornerRadius:2.0f]];
  [menuGlyphPath appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 12.0f, 22.0f, 3.0f) cornerRadius:2.0f]];
  return menuGlyphPath;
}

@end

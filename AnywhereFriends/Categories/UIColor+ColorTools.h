//
//  UIColor+ColorTools.h
//  Stylight
//
//  Created by Alexander Kolov on 7/19/13.
//  Copyright (c) 2013 Stylight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorTools)

@property (readonly) CGFloat alpha;

+ (UIColor *)colorWithDecimalWhite:(CGFloat)white alpha:(CGFloat)alpha;
+ (UIColor *)colorWithDecimalRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end

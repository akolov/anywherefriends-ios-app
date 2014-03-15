//
//  UIImage+CustomBackgrounds.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFConfig.h"
#import "UIImage+CustomBackgrounds.h"
#import "UIColor+ColorTools.h"

NSString *const UIImageBackgroundColor = @"UIImageBackgroundColor";
NSString *const UIImageForegroundColor = @"UIImageForegroundColor";
NSString *const UIImageGradientColors = @"UIImageGradientColors";
NSString *const UIImageTopStrokeColor = @"UIImageTopStrokeColor";
NSString *const UIImageBottomStrokeColor = @"UIImageBottomStrokeColor";
NSString *const UIImageStrokeColor = @"UIImageStrokeColor";
NSString *const UIImageStrokeWidth = @"UIImageStrokeWidth";

@implementation UIImage (CustomBackgrounds)

+ (UIImage *)normalResizeablePushImageWithColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius {
  NSDictionary *const options = @{UIImageForegroundColor: color,
                                  UIImageBackgroundColor: backgroundColor ?: [UIColor clearColor],
                                  UIImageTopStrokeColor: [UIColor colorWithWhite:1.0f alpha:0.5f]};
  return [[self buttonImageWithSize:CGSizeMake(radius * 2.0f + 1.0f, radius * 2.0f + 1.0f) options:options cornerRadius:radius] resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
}

+ (UIImage *)pushedResizeablePushImageWithColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius {
  NSDictionary *const options = @{UIImageForegroundColor: color,
                                  UIImageBackgroundColor: backgroundColor ?: [UIColor clearColor],
                                  UIImageTopStrokeColor: [UIColor colorWithWhite:0 alpha:0.5f],
                                  UIImageBottomStrokeColor: [UIColor whiteColor]};
  return [[self buttonImageWithSize:CGSizeMake(radius * 2.0f + 1.0f, radius * 2.0f + 1.0f) options:options cornerRadius:radius] resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
}

+ (UIImage *)normalPushImageWithSize:(CGSize)size gradient:(NSArray *)gradient backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius {
  NSDictionary *const options = @{UIImageGradientColors: gradient,
                                  UIImageBackgroundColor: backgroundColor ?: [UIColor clearColor],
                                  UIImageStrokeColor: [UIColor colorWithWhite:0.78f alpha:1.0f],
                                  UIImageStrokeWidth: @(1.2f)};
  return [self buttonImageWithSize:size options:options cornerRadius:radius];
}

+ (UIImage *)pushedPushImageWithSize:(CGSize)size gradient:(NSArray *)gradient backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius {
  NSDictionary *const options = @{UIImageGradientColors: gradient,
                                  UIImageBackgroundColor: backgroundColor ?: [UIColor clearColor],
                                  UIImageTopStrokeColor: [UIColor colorWithWhite:0 alpha:0.5f],
                                  UIImageBottomStrokeColor: [UIColor whiteColor]};
  return [self buttonImageWithSize:size options:options cornerRadius:radius];
}

+ (UIImage *)buttonImageWithSize:(CGSize)size options:(NSDictionary *)options cornerRadius:(CGFloat)radius {
  return [UIGraphicsContextWithOptions(size, NO, 0, ^(CGRect rect, CGContextRef context) {
    
    CGFloat const maxx = CGRectGetMaxX(rect);
    CGFloat const maxy = CGRectGetMaxY(rect);
    CGFloat const bevel = 1.0f;
    CGFloat const strokeWidth = [options[UIImageStrokeWidth] floatValue] ?: 2.0f;

    UIColor *const backgroundColor = options[UIImageBackgroundColor];
    UIColor *const foregroundColor = options[UIImageForegroundColor];
    NSArray *const gradientColors = options[UIImageGradientColors];
    UIColor *const topStrokeColor = options[UIImageTopStrokeColor];
    UIColor *const bottomStrokeColor = options[UIImageBottomStrokeColor];
    UIColor *const strokeColor = options[UIImageStrokeColor];

    if (backgroundColor && backgroundColor.alpha != 0) {
      [backgroundColor setFill];
      CGContextFillRect(context, rect);
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];

    if (foregroundColor) {
      [foregroundColor setFill];
      [path fill];
    }

    if (gradientColors) {
      if (radius > 0) {
        [path addClip];
      }

      UIGraphicsPushedContext(context, ^{
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:gradientColors.count];
        for (UIColor *c in gradientColors) {
          [components addObject:(__bridge id)c.CGColor];
        }

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)components, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, size.height), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
      });
    }

    if (strokeColor && bottomStrokeColor) {
      [strokeColor setStroke];

      UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, maxx, maxy - bevel) cornerRadius:radius];
      [strokePath setLineWidth:strokeWidth];
      [strokePath stroke];
    }
    else if (strokeColor) {
      [strokeColor setStroke];
      [path setLineWidth:strokeWidth];
      [path stroke];
    }

    if (topStrokeColor || bottomStrokeColor) {
      UIBezierPath *stroke = [UIBezierPath bezierPath];
      [stroke moveToPoint:CGPointMake(0, radius)];
      [stroke addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:(CGFloat)M_PI endAngle:3.0f * (CGFloat)M_PI_2 clockwise:YES];
      [stroke addLineToPoint:CGPointMake(maxx - radius, 0)];
      [stroke addArcWithCenter:CGPointMake(maxx - radius, radius) radius:radius startAngle:3.0f * (CGFloat)M_PI_2 endAngle:0 clockwise:YES];
      [stroke addArcWithCenter:CGPointMake(maxx - radius, radius + bevel) radius:radius startAngle:0 endAngle:3.0f * (CGFloat)M_PI_2 clockwise:NO];
      [stroke addLineToPoint:CGPointMake(radius, bevel)];
      [stroke addArcWithCenter:CGPointMake(radius, radius + bevel) radius:radius startAngle:3.0f * (CGFloat)M_PI_2 endAngle:(CGFloat)M_PI clockwise:NO];
      [stroke closePath];

      if (topStrokeColor) {
        [topStrokeColor setFill];
        [stroke fill];
      }

      if (bottomStrokeColor) {
        [bottomStrokeColor setFill];
        [stroke applyTransform:CGAffineTransformMake(1.0f, 0, 0, -1.0f, 0, maxy)];
        [stroke fill];
      }
    }

  }) resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
}

@end

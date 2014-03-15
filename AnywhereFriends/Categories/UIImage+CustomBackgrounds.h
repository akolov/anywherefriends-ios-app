//
//  UIImage+CustomBackgrounds.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

@import UIKit;


OBJC_EXPORT NSString *const UIImageBackgroundColor;
OBJC_EXPORT NSString *const UIImageForegroundColor;
OBJC_EXPORT NSString *const UIImageGradientColors;
OBJC_EXPORT NSString *const UIImageTopStrokeColor;
OBJC_EXPORT NSString *const UIImageBottomStrokeColor;
OBJC_EXPORT NSString *const UIImageStrokeColor;
OBJC_EXPORT NSString *const UIImageStrokeWidth;


@interface UIImage (CustomBackgrounds)

+ (UIImage *)normalResizeablePushImageWithColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius;
+ (UIImage *)pushedResizeablePushImageWithColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius;
+ (UIImage *)normalPushImageWithSize:(CGSize)size gradient:(NSArray *)gradient backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius;
+ (UIImage *)pushedPushImageWithSize:(CGSize)size gradient:(NSArray *)gradient backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)radius;
+ (UIImage *)buttonImageWithSize:(CGSize)size options:(NSDictionary *)options cornerRadius:(CGFloat)radius;

@end

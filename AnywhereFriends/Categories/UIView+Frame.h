//
//  UIView+Frame.h
//  WeatherGrid
//
//  Created by Alexander Kolov on 2/13/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (void)setFrameOriginX:(CGFloat)newX;
- (void)setFrameOriginY:(CGFloat)newY;

- (void)setFrameOffset:(CGSize)offset;
- (void)setFrameOffsetX:(CGFloat)offsetX;
- (void)setFrameOffsetY:(CGFloat)offsetY;

- (void)setFrameWidth:(CGFloat)newWidth;
- (void)setFrameHeight:(CGFloat)newHeight;

- (void)setFrameOrigin:(CGPoint)origin;
- (void)setFrameSize:(CGSize)size;

- (void)growFrameWidth:(CGFloat)growWidth;
- (void)growFrameHeight:(CGFloat)growHeight;

@end

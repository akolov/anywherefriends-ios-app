//
//  CGContext+Blocks.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 5/24/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFConfig.h"
#import "CGContext+Blocks.h"

void UIGraphicsPushedContext(CGContextRef context, CGStateBlock actions) {
  UIGraphicsPushContext(context);
  actions();
  UIGraphicsPopContext();
}

UIImage * UIGraphicsContextWithOptions(CGSize size, BOOL opaque, CGFloat scale, CGContextBlock actions) {
  UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect rect = {.origin = CGPointZero, .size = size};
  actions(rect, context);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

void CGContextState(CGContextRef context, CGStateBlock actions) {
  CGContextSaveGState(context);
  actions();
  CGContextRestoreGState(context);
}

void CGContextTransparencyLayer(CGContextRef context, CGStateBlock actions) {
  CGContextBeginTransparencyLayer(context, NULL);
  actions();
  CGContextEndTransparencyLayer(context);
}

//
//  CGContext+Blocks.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 5/24/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CGStateBlock)();
typedef void(^CGContextBlock)(CGRect rect, CGContextRef context);

void UIGraphicsPushedContext(CGContextRef context, CGStateBlock actions);
UIImage * UIGraphicsContextWithOptions(CGSize size, BOOL opaque, CGFloat scale, CGContextBlock actions);

void CGContextState(CGContextRef context, CGStateBlock actions);
void CGContextTransparencyLayer(CGContextRef context, CGStateBlock actions);

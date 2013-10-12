//
//  AWFNavigationBar.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNavigationBar.h"


@implementation AWFNavigationBar

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  if (self.extended) {
    return [self.backgroundView pointInside:point withEvent:event];
  }
  return [super pointInside:point withEvent:event];
}

- (void)setExtended:(BOOL)extended {
  if (_extended == extended) {
    return;
  }

  _extended = extended;

  CGFloat growHeight = extended ? 34.0f : -34.0f;
  [self.backgroundView growFrameHeight:growHeight];
}

- (UIView *)backgroundView {
  return self.subviews.firstObject;
}

@end

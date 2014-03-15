//
//  AWFNavigationTitleView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFNavigationTitleView.h"

@implementation AWFNavigationTitleView

+ (instancetype)navigationTitleView {
  AWFNavigationTitleView *view = [[AWFNavigationTitleView alloc] initWithFrame:CGRectZero];
  [view sizeToFit];
  return view;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = nil;
    self.font = [UIFont magnetoBoldFontOfSize:19.0f];
    self.opaque = NO;
    self.text = @"AnywhereFriends";
    self.textColor = [UIColor whiteColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [self.text drawInRect:CGRectOffset(rect, 2.0f, 0) withAttributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.textColor}];
}

@end

//
//  AWFShapeView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 6/25/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFShapeView.h"

@implementation AWFShapeView

+ (Class)layerClass {
  return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
  return (CAShapeLayer *)self.layer;
}

- (void)setPath:(UIBezierPath *)path {
  _path = path;
  self.shapeLayer.path = _path.CGPath;
  self.shapeLayer.frame = _path.bounds;
  [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
  CGRect bounds = self.path.bounds;
  return CGRectIsEmpty(bounds) ? CGSizeZero : CGSizeMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
}

#pragma mark - Public methods

- (void)sizeToFit {
  self.bounds = CGRectMake(0, 0, self.intrinsicContentSize.width, self.intrinsicContentSize.height);
}

@end

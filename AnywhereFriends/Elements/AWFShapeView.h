//
//  AWFShapeView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 6/25/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

@import UIKit;
#import <QuartzCore/QuartzCore.h>


@interface AWFShapeView : UIView

@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;

- (void)sizeToFit;

@end

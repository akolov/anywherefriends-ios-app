//
//  AWFButton.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 Stylight. All rights reserved.
//

@import UIKit;

@interface AWFButton : UIControl

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

- (UIColor *)backgroundColorForState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (UIImage *)backgroundImageForState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;

@end

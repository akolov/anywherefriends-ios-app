//
//  AWFLabelButton.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFButton.h"

@interface AWFLabelButton : AWFButton

@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (NSString *)titleTextForState:(UIControlState)state;
- (void)setTitleText:(NSString *)text forState:(UIControlState)state;

- (UIColor *)titleColorForState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

- (UIEdgeInsets)contentEdgeInsetsForState:(UIControlState)state;
- (void)setContentEdgeInsets:(UIEdgeInsets)inset forState:(UIControlState)state;

@end
